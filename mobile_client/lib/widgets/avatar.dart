import 'dart:io';
import 'package:flutter/material.dart';

class ProfilePhotoAvatar extends StatelessWidget {
  final String? imagePath; // The path of the image (nullable)
  final double radius; // The radius of the circular avatar

  const ProfilePhotoAvatar({
    super.key,
    this.imagePath, // The image path is optional
    this.radius = 50.0, // Default radius is 50.0
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300], // Default background color
      backgroundImage: imagePath != null
          ? FileImage(File(imagePath!))
          : null, // Show image if available
      child: imagePath == null
          ? Icon(
              Icons.camera_alt,
              size: radius / 2, // Icon size is half the radius
              color: Colors.white,
            )
          : null, // If there's no image, show the camera icon
    );
  }
}
