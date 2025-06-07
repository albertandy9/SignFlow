import 'package:signflow/services/progress_service.dart'; 

class SubscriptionService {
  final ProgressService _progressService;

  SubscriptionService(this._progressService);

  Future<void> purchaseSubscription(String planName, String type) async {
    // Integrate to payment gateway

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 1));

    // Save the purchase to history
    await _progressService.savePurchase(planName, type);
  }
}
