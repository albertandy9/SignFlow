import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart'; 
import 'package:signflow/style/text.dart'; 

class CertificatePage extends StatelessWidget { 
  final String? username;

  const CertificatePage({super.key, required this.username});

  void _showDownloadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 125, 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10), 
            ListTile(
              leading: const Icon(Icons.image, color: AppColors.textPrimary),
              title: Text(AppText.enText['download_as_image']!, style: const TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.enText['certificate_image_downloaded']!)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: AppColors.textPrimary),
              title: Text(AppText.enText['download_as_pdf']!, style: const TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.enText['certificate_pdf_downloaded']!)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.enText['download_certificate_title_page']!), 
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.textPrimary),
            onPressed: () => _showDownloadOptions(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.certificateBorder, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.certificateBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.description,
                        size: 80,
                        color: AppColors.certificateIcon,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppText.enText['certificate_main_title']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${AppText.enText['issued_to']!}${username ?? "Unknown"}',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    Text(
                      '${AppText.enText['date_prefix']!}$formattedDate',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppText.enText['certificate_completion_note']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _showDownloadOptions(context),
                icon: const Icon(
                  Icons.download,
                  color: AppColors.textOnPrimary,
                ),
                label: Text(
                  AppText.enText['download_button']!, 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.certificateDownloadButton, 
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
