import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../domain/validators.dart';
import 'widgets/auth_progress_widget.dart';
import 'widgets/birth_date_widget.dart';
import 'widgets/name_input_widget.dart';
import 'widgets/phone_input_widget.dart';
import 'widgets/verify_phone_widget.dart';

export 'onboarding_page.dart';
export 'welcome_page.dart';

class AuthFlowPage extends ConsumerStatefulWidget {
  const AuthFlowPage({super.key, required this.isLogin});
  final bool isLogin;

  @override
  ConsumerState<AuthFlowPage> createState() => _AuthFlowPageState();
}

class _AuthFlowPageState extends ConsumerState<AuthFlowPage> {
  final phone = TextEditingController();
  final otp = TextEditingController();
  final first = TextEditingController();
  final last = TextEditingController();
  final month = TextEditingController();
  final day = TextEditingController();
  final year = TextEditingController();
  final phoneFocus = FocusNode();
  Timer? timer;
  int step = 0;
  int wrong = 0;
  int seconds = 300;
  bool busy = false;
  bool phoneTouched = false;
  String? error;

  @override
  void initState() {
    super.initState();
    phoneFocus.addListener(_handlePhoneFocus);
  }

  void _handlePhoneFocus() {
    if (!phoneFocus.hasFocus && mounted) setState(() => phoneTouched = true);
  }

  @override
  void dispose() {
    timer?.cancel();
    phoneFocus.removeListener(_handlePhoneFocus);
    phoneFocus.dispose();
    for (final c in [phone, otp, first, last, month, day, year]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get valid {
    switch (step) {
      case 0:
        return Validators.phone(phone.text);
      case 1:
        return Validators.otp(otp.text) && wrong < 3;
      case 2:
        return Validators.name(first.text) &&
            Validators.name(last.text, optional: true);
      default:
        return Validators.birthDate(int.tryParse(year.text) ?? 0,
            int.tryParse(month.text) ?? 0, int.tryParse(day.text) ?? 0);
    }
  }

  void startTimer() {
    timer?.cancel();
    setState(() => seconds = 300);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (seconds > 0) seconds--;
      });
      if (seconds == 0) timer.cancel();
    });
  }

  void next() {
    setState(() {
      step++;
      error = null;
    });
    if (step == 1) startTimer();
  }

  void back() {
    if (busy) return;
    if (step == 0) {
      context.pop();
      return;
    }
    setState(() {
      step--;
      error = null;
    });
    if (step != 1) timer?.cancel();
  }

  void resend() {
    setState(() {
      wrong = 0;
      otp.clear();
      error = null;
    });
    startTimer();
  }

  Future<void> submit() async {
    if (busy || !valid) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      final number = '+95${Validators.normalizePhone(phone.text)}';
      if (step == 0) {
        if (widget.isLogin && !await repo.exists(number)) {
          if (mounted) {
            setState(() => error = 'Number not registered. Register instead.');
          }
          return;
        }
        if (mounted) next();
      } else if (step == 1) {
        await Future<void>.delayed(const Duration(milliseconds: 450));
        if (!mounted) return;
        if (otp.text != '123456') {
          setState(() {
            wrong++;
            otp.clear();
            error = wrong >= 3
                ? 'Too many attempts. Resend to unlock.'
                : 'Incorrect code. Try again.';
          });
          return;
        }
        timer?.cancel();
        if (widget.isLogin) {
          if (await repo.login(number) && mounted) context.go('/home');
        } else {
          next();
        }
      } else if (step == 2) {
        next();
      } else {
        await repo.register(
            number,
            first.text.trim(),
            last.text.trim(),
            DateTime(int.parse(year.text), int.parse(month.text),
                int.parse(day.text)));
        if (mounted) context.go('/welcome');
      }
    } catch (e) {
      if (mounted) {
        setState(() => error = 'Unable to continue. Please try again.');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const headings = [
      'Enter your phone\nnumber',
      'Verify your number',
      "What's your\nname?",
      "What's your\ndate of birth?"
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                IconButton(
                    onPressed: back,
                    icon: const Icon(Icons.arrow_back_ios_new)),
                const Spacer(),
                AuthProgressWidget(step: step),
              ]),
              const SizedBox(height: 38),
              Text(headings[step],
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 220),
                    child: Column(
                      key: ValueKey(step),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (step == 0)
                          PhoneInputWidget(
                            controller: phone,
                            focusNode: phoneFocus,
                            onChanged: (_) => setState(() {}),
                            error: phoneTouched &&
                                    phone.text.isNotEmpty &&
                                    !Validators.phone(phone.text)
                                ? 'Enter a valid Myanmar phone number'
                                : null,
                          ),
                        if (step == 1)
                          VerifyPhoneWidget(
                            phoneNumber:
                                '+95${Validators.normalizePhone(phone.text)}',
                            controller: otp,
                            secondsRemaining: seconds,
                            wrongAttempts: wrong,
                            onChanged: (_) => setState(() => error = null),
                            onResend: resend,
                          ),
                        if (step == 2)
                          NameInputWidget(
                            firstController: first,
                            lastController: last,
                            onChanged: () => setState(() {}),
                          ),
                        if (step == 3)
                          BirthDateWidget(
                            month: month,
                            day: day,
                            year: year,
                            onChanged: () => setState(() {}),
                          ),
                        if (error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(error!,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        if (step == 0 && widget.isLogin)
                          TextButton(
                            onPressed: () => context.go('/auth/register'),
                            child: const Text('Register instead'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                  text: 'Continue',
                  onPressed: valid && !busy ? submit : null,
                  loading: busy),
              const SizedBox(height: 18),
              const Center(
                  child: Text(
                'By continuing you accept our Terms of Use and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Palette.muted),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
