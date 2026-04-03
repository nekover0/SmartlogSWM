import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onForgotPassword,
    this.errorMessage,
  });

  final bool isSubmitting;
  final Future<void> Function(String username, String password) onSubmit;
  final VoidCallback onForgotPassword;
  final String? errorMessage;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocusNode;
  bool _obscurePassword = true;

  bool get _canSubmit =>
      !widget.isSubmitting &&
      _usernameController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _usernameController.addListener(_handleFieldChanged);
    _passwordController.addListener(_handleFieldChanged);
  }

  @override
  void dispose() {
    _usernameController
      ..removeListener(_handleFieldChanged)
      ..dispose();
    _passwordController
      ..removeListener(_handleFieldChanged)
      ..dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleFieldChanged() {
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_canSubmit) {
      return;
    }

    await widget.onSubmit(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Đăng nhập hệ thống', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Truy cập hệ thống quản lý kho thông minh của bạn.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              key: const Key('login_username_field'),
              controller: _usernameController,
              autofocus: true,
              enabled: !widget.isSubmitting,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Tên đăng nhập',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              onSubmitted: (_) {
                _passwordFocusNode.requestFocus();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('login_password_field'),
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              enabled: !widget.isSubmitting,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  key: const Key('login_password_toggle'),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              onSubmitted: (_) async {
                await _submit();
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('forgot_password_button'),
                onPressed: widget.isSubmitting ? null : widget.onForgotPassword,
                child: const Text('Quên mật khẩu?'),
              ),
            ),
            if (widget.errorMessage != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.08),
                  borderRadius: AppSpacing.controlRadius,
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.danger,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        widget.errorMessage!,
                        key: const Key('login_inline_error'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              height: 52,
              child: ElevatedButton(
                key: const Key('login_submit_button'),
                onPressed: _canSubmit ? _submit : null,
                child: widget.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.surface,
                        ),
                      )
                    : const Text('Đăng nhập'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
