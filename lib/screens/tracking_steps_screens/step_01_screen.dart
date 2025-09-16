import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'step_02_screen.dart';
import '../../widgets/big_action_button.dart';
import 'package:provider/provider.dart';
import '../../models/tracking_data.dart';
import '../../l10n/app_localizations.dart';

class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();
  }

  void _loadSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('name');
    if (savedName != null && mounted) {
      Provider.of<TrackingData>(context, listen: false)
          .setPersonName(savedName);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(AppLocalizations.of(context).step1Title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).step1Question,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).step1Description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _noteController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).step1Placeholder,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Spacer(),
              BigActionButton(
                text: AppLocalizations.of(context).nextButton,
                onPressed: () {
                  if (_noteController.text.isNotEmpty) {
                    Provider.of<TrackingData>(context, listen: false)
                        .setNote(_noteController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StepTwoScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context).step1Validation)),
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
