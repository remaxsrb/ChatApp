import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_client/providers/registration_form.dart';
import 'package:mobile_client/routes/app_routes.dart';

class Step3DOBGender extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();

  Step3DOBGender({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(registrationFormProvider);
    final formNotifier = ref.read(registrationFormProvider.notifier);

    // Function to open Date Picker
    Future<void> selectDate(BuildContext context) async {
      DateTime selectedDate = DateTime.now().subtract(Duration(days: 365 * 13));

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != selectedDate) {
        _dobController.text = "${picked.toLocal()}".split(' ')[0]; // Format the date as needed
        formNotifier.updateDateOfBirth(picked); // Update the form state
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.pushNamed(context, AppRoutes.signupStep4);
                }
              },
              child: Row(
                children: [
                  Text('Next'),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Padding around the form
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title for Date of Birth
              const Text(
                "Date of Birth",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Date Picker as a TextField
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: "Select Date of Birth",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode()); // Dismiss keyboard
                  selectDate(context); // Open DatePicker on Tap
                },
                readOnly: true, // Make it read-only so users can't type directly
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Title for Gender Selection
              const Text(
                "Gender",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Horizontal Gender Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Male Radio Button
                  Row(
                    children: [
                      Radio<String>(
                        value: "Male",
                        groupValue: form.gender,
                        onChanged: formNotifier.updateGender,
                      ),
                      const Text("Male"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // Female Radio Button
                  Row(
                    children: [
                      Radio<String>(
                        value: "Female",
                        groupValue: form.gender,
                        onChanged: formNotifier.updateGender,
                      ),
                      const Text("Female"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
