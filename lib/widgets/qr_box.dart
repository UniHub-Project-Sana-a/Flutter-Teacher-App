import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrBox extends StatelessWidget {
  final String data;
  final double maxSize;
  const QrBox({super.key, required this.data, this.maxSize = 320});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        // نحدد حجم المربع الأقصى ونوسّطه
        final double size = (constraints.maxWidth - 48).clamp(180.0, maxSize);
        return Card(
          elevation: 6,
          shadowColor: const Color(0x22000000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: size,
                height: size,
                child: QrImageView(
                  data: data,
                  version: QrVersions.auto,
                  gapless: true,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black87,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}