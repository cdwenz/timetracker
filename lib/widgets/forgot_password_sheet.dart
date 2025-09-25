// lib/widgets/forgot_password_sheet.dart
import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/l10n/app_localizations.dart';
import 'package:ihadi_time_tracker/services/auth_service.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    setState(() => _error = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final resetLink = await AuthService.requestPasswordReset(_emailCtrl.text.trim());
      if (mounted) {
        Navigator.of(context).pop(true); // devolvemos éxito al caller
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.forgotPasswordSent)), // "Revisá tu correo"
        );
        // Si querés debug/QA:
        // if (resetLink != null) debugPrint('reset_link: $resetLink');
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      setState(() => _error = msg.isEmpty ? t.forgotPasswordErrorGeneric : msg);
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
                    child: Text(t.forgotPasswordTitle, style: theme.textTheme.titleLarge),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(false),
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(t.forgotPasswordInstruction),
              const SizedBox(height: 12),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                ),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: t.emailLabel,
                  prefixIcon: const Icon(Icons.alternate_email),
                ),
                validator: (v) {
                  final x = (v ?? '').trim();
                  final emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (x.isEmpty) return t.emailRequired;
                  if (!emailRe.hasMatch(x)) return t.invalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(t.sendButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
