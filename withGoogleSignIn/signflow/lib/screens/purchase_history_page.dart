import 'package:flutter/material.dart';
import 'package:signflow/model/purchase_history.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/progress_service.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  List<PurchaseHistoryItem> purchaseHistory = [];
  bool isLoading = true;

  final ProgressService _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    _loadPurchaseHistory();
  }

  Future<void> _loadPurchaseHistory() async {
    try {
      final history = await _progressService.loadPurchaseHistory();
      if (mounted) {
        setState(() {
          purchaseHistory = history;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading purchase history: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.enText['purchase_history_title']!),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : purchaseHistory.isEmpty
              ? Center(
                child: Text(
                  AppText.enText['no_purchase_history']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: purchaseHistory.length,
                itemBuilder: (context, index) {
                  final item = purchaseHistory[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: AppColors.purchaseHistoryCardBackground,
                    child: ListTile(
                      leading: Icon(
                        item.type == 'HP' ? Icons.favorite : Icons.star,
                        color:
                            item.type == 'HP'
                                ? AppColors.purchaseListItemIcon
                                : AppColors.purchaseHistorySubscriptionIcon,
                      ),
                      title: Text(
                        item.productName,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        '${AppText.enText['date_label_prefix']!}${item.date}',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
