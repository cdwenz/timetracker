import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import 'step_04_screen.dart' show StepDateScreen; // ajustá el import/alias según tu estructura
import '../../widgets/big_action_button.dart';
import '../../l10n/app_localizations.dart';

class StepTwoScreen extends StatefulWidget {
  final String? previousStepNote;
  const StepTwoScreen({super.key, this.previousStepNote});

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _languageCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // Prefill desde Provider (esperamos al primer frame para usar context)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final t = context.read<TrackingData>();
      _recipientCtrl.text = t.recipient ?? '';
      _countryCtrl.text = t.supportedCountry ?? '';
      _languageCtrl.text = t.workingLanguage ?? '';
    });
  }

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _countryCtrl.dispose();
    _languageCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    // Normalización suave para coherencia con backend futuro
    final recipient = _recipientCtrl.text.trim();
    final supportedCountry = _countryCtrl.text.trim().toUpperCase();
    final workingLanguage = _languageCtrl.text.trim().toLowerCase();

    // ✅ Guardar en Provider (no se llama al backend acá)
    final tracking = context.read<TrackingData>();
    tracking.setRecipient(recipient);
    tracking.setSupportedCountry(supportedCountry);
    tracking.setWorkingLanguage(workingLanguage);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StepDateScreen()),
    );

    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(AppLocalizations.of(context).step2Title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).step2Question,
                    style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _recipientCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).recipientLabel,
                    hintText: AppLocalizations.of(context).recipientLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? AppLocalizations.of(context).recipientValidation : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _countryCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).supportedCountryLabel,
                    hintText: AppLocalizations.of(context).countryPlaceholder,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? AppLocalizations.of(context).countryValidation : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _languageCtrl,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).workingLanguageLabel,
                    hintText: AppLocalizations.of(context).languagePlaceholder,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? AppLocalizations.of(context).languageValidation : null,
                ),

                const Spacer(),
                BigActionButton(
                  text: _submitting ? AppLocalizations.of(context).savingButton : AppLocalizations.of(context).continueButton,
                  onPressed: _submitting ? null :  _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
