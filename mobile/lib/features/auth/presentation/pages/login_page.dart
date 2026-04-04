import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/presentation/widgets/login_form.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final isSubmitting =
        authState.isLoading &&
        authController.lastOperation == AuthOperation.login;
    final errorMessage =
        authState.hasError &&
            authController.lastOperation == AuthOperation.login
        ? '${authState.error}'
        : null;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9F0FB),
              AppColors.background,
              Color(0xFFF8FAFD),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.xl),
                          _LoginHero(isSubmitting: isSubmitting),
                          const SizedBox(height: AppSpacing.xl),
                          LoginForm(
                            isSubmitting: isSubmitting,
                            errorMessage: errorMessage,
                            onForgotPassword: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Luồng quên mật khẩu sẽ được bổ sung ở phase sau.',
                                  ),
                                ),
                              );
                            },
                            onSubmit: (String username, String password) {
                              return authController.login(
                                username: username,
                                password: password,
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.isSubmitting});

  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A103B73),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.warehouse_outlined,
              color: AppColors.surface,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Smartlog WMS',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.surface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Đăng nhập để tiếp tục xử lý nhập, xuất, quét và theo dõi tác vụ kho.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedOpacity(
            opacity: isSubmitting ? 1 : 0.86,
            duration: const Duration(milliseconds: 180),
            child: Row(
              children: [
                const Icon(
                  Icons.flash_on_rounded,
                  color: Color(0xFFFFD27A),
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    isSubmitting
                        ? 'Đang xác thực thông tin đăng nhập...'
                        : 'Sử dụng tài khoản hệ thống để tiếp tục vào ứng dụng.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
