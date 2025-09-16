import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/widgets/custom_drawer.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';
import '../l10n/app_localizations.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();

  UserProfile? _profile;
  bool _saving = false;

  late Future<UserMe> _meFuture;

  /// Traduce el nombre del rol del sistema
  String _translateRole(String role) {
    return switch (role) {
      'ADMIN' => AppLocalizations.of(context).roleAdmin,
      'FIELD_MANAGER' => AppLocalizations.of(context).roleFieldManager,
      'USER' => AppLocalizations.of(context).roleUser,
      _ => role,
    };
  }

  @override
  void initState() {
    super.initState();
    _meFuture = UserService.getMe();
    _meFuture.then((me) {
      if (_nameCtrl.text.isEmpty && me.name.isNotEmpty) {
        _nameCtrl.text = me.name;
      }
      if (_emailCtrl.text.isEmpty) {
        _emailCtrl.text = me.email;
      }
      if (_countryCtrl.text.isEmpty) {
        _countryCtrl.text = me.country;
      }
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _profile == null) return;

    setState(() => _saving = true);
    try {
      _profile!
        ..name = _nameCtrl.text.trim()
        ..supportedCountry = _countryCtrl.text.trim();

      final updated = await UserService.updateProfile(_profile!);
      _profile = updated;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profileUpdatedMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).saveErrorMessage(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _header(UserMe me) {
    final initials = (me.name.isNotEmpty
            ? me.name.trim().split(RegExp(r'\s+')).map((p) => p[0]).take(2).join()
            : '?')
        .toUpperCase();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Text(
                initials,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(me.name.isEmpty ? AppLocalizations.of(context).defaultUserName : me.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(me.email, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(AppLocalizations.of(context).userCountryLabel(me.country),
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                    ),
                    child: Text(
                      AppLocalizations.of(context).userRoleLabel(_translateRole(me.role)),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).nameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? AppLocalizations.of(context).nameRequiredValidation : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).emailLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryCtrl,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).countryFieldLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(AppLocalizations.of(context).saveChangesButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(title: Text(AppLocalizations.of(context).accountTitle)),
      body: FutureBuilder<UserMe>(
        future: _meFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context).genericErrorMessage(snapshot.error.toString())));
          }
          final me = snapshot.data!;
          return ListView(
            children: [
              _header(me),
              _formSection(),
            ],
          );
        },
      ),
    );
  }
}
