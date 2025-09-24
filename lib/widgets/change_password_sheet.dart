// lib/widgets/change_password_sheet.dart
import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/l10n/app_localizations.dart';
import 'package:ihadi_time_tracker/services/api_service.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _new2Ctrl = TextEditingController();

  bool _submitting = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showNew2 = false;
  String? _error;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _new2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    setState(() => _error = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      await ApiService.changePassword(
        currentPassword: _currentCtrl.text.trim(),
        newPassword: _newCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.changePasswordSuccess)),
        );
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      setState(() => _error = msg.isEmpty ? t.changePasswordErrorGeneric : msg);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          // levanta el modal cuando abre el teclado
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.changePasswordTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(false),
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  )
                ],
              ),
              const SizedBox(height: 8),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),

              // Current password
              TextFormField(
                controller: _currentCtrl,
                obscureText: !_showCurrent,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: t.currentPasswordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _showCurrent = !_showCurrent),
                    icon: Icon(_showCurrent ? Icons.visibility_off : Icons.visibility),
                    tooltip: _showCurrent
                        ? MaterialLocalizations.of(context).hideAccountsLabel
                        : MaterialLocalizations.of(context).showAccountsLabel,
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? t.changePasswordValidationCurrentRequired
                    : null,
              ),
              const SizedBox(height: 12),

              // New password
              TextFormField(
                controller: _newCtrl,
                obscureText: !_showNew,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: t.newPasswordLabel,
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _showNew = !_showNew),
                    icon: Icon(_showNew ? Icons.visibility_off : Icons.visibility),
                    tooltip: _showNew
                        ? MaterialLocalizations.of(context).hideAccountsLabel
                        : MaterialLocalizations.of(context).showAccountsLabel,
                  ),
                ),
                validator: (v) {
                  final text = (v ?? '').trim();
                  if (text.length < 8) return t.changePasswordValidationMinLength(8);
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Repeat new password
              TextFormField(
                controller: _new2Ctrl,
                obscureText: !_showNew2,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: t.repeatNewPasswordLabel,
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _showNew2 = !_showNew2),
                    icon: Icon(_showNew2 ? Icons.visibility_off : Icons.visibility),
                    tooltip: _showNew2
                        ? MaterialLocalizations.of(context).hideAccountsLabel
                        : MaterialLocalizations.of(context).showAccountsLabel,
                  ),
                ),
                validator: (v) {
                  if ((v ?? '').trim() != _newCtrl.text.trim()) {
                    return t.changePasswordValidationRepeatMismatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(t.changePasswordSubmit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
