import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_client/providers/registration_form.dart';
import 'package:mobile_client/routes/app_routes.dart';
import 'dart:io';

import 'package:mobile_client/widgets/custom_button.dart';

class Step4ProfilePhoto extends ConsumerStatefulWidget {
  const Step4ProfilePhoto({super.key});

  @override
  ConsumerState<Step4ProfilePhoto> createState() => _Step4ProfilePhotoState();
}

class _Step4ProfilePhotoState extends ConsumerState<Step4ProfilePhoto> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final profilePhoto = ref.watch(
      registrationFormProvider.select((state) => state.profilePhoto),
    );

    final formNotifier = ref.read(registrationFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Profile Photo",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                (profilePhoto?.isNotEmpty ?? false)
                    ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(profilePhoto!)),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),

                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      formNotifier.updateProfilePhoto(image.path);
                    }
                  },
                  child: const Text("Pick Image"),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: CustomButton(
                    text: 'Register',
                    onPressed: () async {
                      final success = await formNotifier.submit();

                      if (!mounted) return;

                      if (success) {
                        Navigator.pushNamed(context, AppRoutes.landing);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "There was an error while creating your account",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
