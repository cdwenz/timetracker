import 'package:flutter/material.dart';
import 'step_04_screen.dart';
import '../../widgets/big_action_button.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import '../../l10n/app_localizations.dart';

class StepThreeScreen extends StatefulWidget {
  final String? previousStepNote;

  const StepThreeScreen({super.key, this.previousStepNote});

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).step3Title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).step3Question,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).step3Description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).step3Placeholder,
                ),
              ),
              const Spacer(),
              BigActionButton(
                text: AppLocalizations.of(context).nextButton,
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    Provider.of<TrackingData>(context, listen: false)
                        .setPersonName(_nameController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StepDateScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context).step3Validation)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
