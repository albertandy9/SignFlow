import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/progress_service.dart';

class PurchaseHpPage extends StatelessWidget {
  final int currentHp;
  final int maxHp;
  final Function(int)? onHpUpdate;

  const PurchaseHpPage({
    super.key,
    required this.currentHp,
    required this.maxHp,
    this.onHpUpdate,
  });

  static const List<Map<String, dynamic>> hpPacks = [
    {
      'hp': 1,
      'price': 3.999,
      'description_key': 'hp_pack_1_hp_desc',
    }, 
    {'hp': 2, 'price': 6.999, 'description_key': 'hp_pack_2_hp_desc'},
    {'hp': 3, 'price': 9.999, 'description_key': 'hp_pack_full_hp_desc'},
  ];

  Future<void> _handlePurchase(
    BuildContext context,
    int hpToRestore,
    String descriptionKey,
  ) async {
    final ProgressService progressService = ProgressService();

    await progressService.purchaseHp(currentHp, maxHp, hpToRestore, onHpUpdate);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppText.enText['purchase_success_message']!}${AppText.enText[descriptionKey]!}${AppText.enText['hp_suffix']!}',
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.enText['buy_hp_title']!),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppText.enText['hp_current_status_purchase']!}$currentHp/$maxHp',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppText.enText['choose_hp_pack']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: hpPacks.length,
                itemBuilder: (context, index) {
                  final pack = hpPacks[index];

                  final bool isFullHpPack =
                      pack['description_key'] == 'hp_pack_full_hp_desc';
                  final bool canAddWithoutExceedingMax =
                      (currentHp + pack['hp'] <= maxHp);

                  final bool isPurchaseEnabled;
                  if (currentHp >= maxHp) {
                    isPurchaseEnabled = false;
                  } else if (isFullHpPack) {
                    isPurchaseEnabled = (currentHp == 0); 
                  } else {
                    isPurchaseEnabled = canAddWithoutExceedingMax;
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: AppColors.purchaseListItemIcon,
                        size: 30,
                      ),
                      title: Text(
                        '${AppText.enText[pack['description_key']]!} (${pack['hp']} HP)',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        '${AppText.enText['price_prefix']!}${pack['price']}',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: ElevatedButton(
                        onPressed:
                            isPurchaseEnabled
                                ? () => _handlePurchase(
                                  context,
                                  pack['hp'],
                                  pack['description_key'],
                                )
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isPurchaseEnabled
                                  ? AppColors.purchaseButtonEnabled
                                  : AppColors.purchaseButtonDisabled,
                          foregroundColor: AppColors.textOnPrimary,
                        ),
                        child: Text(AppText.enText['buy_button']!),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '${AppText.enText['purchase_note']!}$maxHp.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
