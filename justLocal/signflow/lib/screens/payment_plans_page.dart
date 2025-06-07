import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/subscription_service.dart';
import 'package:signflow/services/progress_service.dart';
import 'package:signflow/screens/purchase_history_page.dart'; 

class PaymentPlansPage extends StatefulWidget {
  const PaymentPlansPage({super.key});

  @override
  State<PaymentPlansPage> createState() => _PaymentPlansPageState();
}

class _PaymentPlansPageState extends State<PaymentPlansPage> {
  String _selectedPlan = 'Annual';
  late final SubscriptionService _subscriptionService;

  @override
  void initState() {
    super.initState();
    _subscriptionService = SubscriptionService(ProgressService());
  }

  void _selectPlan(String plan) {
    setState(() {
      _selectedPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppText.enText['choose_plan_after_trial']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                AppText.enText['learn_for_price_per_week']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            _buildPlanCard(
              planKey: 'Annual',
              label: AppText.enText['most_popular_label']!,
              title: AppText.enText['annual_plan_title']!,
              price: 'Rp 2.000/week',
              total: 'Rp 199.000',
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              planKey: '3 Months',
              title: AppText.enText['three_months_plan_title']!,
              price: 'Rp 3.000/week',
              total: 'Rp 49.000',
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              planKey: 'Monthly',
              title: AppText.enText['monthly_plan_title']!,
              price: 'Rp 4.000/week',
              total: 'Rp 19.000',
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppText.enText['selected_plan_message']!}$_selectedPlan',
                    ),
                  ),
                );
                await _subscriptionService.purchaseSubscription(
                  'Subscription ($_selectedPlan)',
                  'Subscription',
                );
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchaseHistoryPage(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 60),
              ),
              child: Text(
                AppText.enText['purchase_now_button']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String planKey,
    String? label,
    required String title,
    required String price,
    required String total,
  }) {
    final bool isSelected = _selectedPlan == planKey;

    return GestureDetector(
      onTap: () => _selectPlan(planKey),
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.paymentPlanCardSelectedBackground
                  : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.profileCardBorder,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mostPopularLabel,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            if (label != null) const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : AppColors.profileCardBorder,
                          width: 2,
                        ),
                      ),
                      child:
                          isSelected
                              ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                              : null,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              total,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
