import 'package:flutter/material.dart';
import 'package:signflow/components/profile/profile_section.dart';
import 'package:signflow/components/profile/setting_item.dart';
import 'package:signflow/components/profile/edit_personal_data_form.dart';
import 'package:signflow/components/profile/change_password_form.dart';
import 'package:signflow/screens/payment_plans_page.dart';
import 'package:signflow/screens/download_certificate_page.dart';
import 'package:signflow/screens/help_page.dart';
import 'package:signflow/components/profile/logout_confirmation_dialogue.dart';
import 'package:signflow/screens/auth_page.dart';
import 'package:signflow/screens/streak_calendar_page.dart';
import 'package:signflow/components/profile/user_streak_section.dart';
import 'package:signflow/screens/purchase_history_page.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/user_profile_service.dart';
import 'package:signflow/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  int currentStreak = 0;
  Map<String, bool> loginDays = {};

  final UserProfileService _userProfileService = UserProfileService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadAllUserData();
  }

  Future<void> _loadAllUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          username = null;
          email = null;
          currentStreak = 0;
          loginDays = {};
        });
      }
      return;
    }

    final userData =
        _userProfileService
            .getCurrentUserData(); 
    final streakData =
        await _userProfileService.loadStreakData(); 

    if (mounted) {
      setState(() {
        username = userData['username'];
        email = userData['email'];
        currentStreak = streakData['currentStreak'];
        loginDays = streakData['loginDays'];
      });
    }
  }

  void _navigateToEditPersonalData(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditPersonalDataForm()),
    );

    if (result == true) {
      _loadAllUserData();
    }
  }

  void _navigateToStreakCalendar(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StreakCalendarPage()),
    );
    if (result == true) {
      _loadAllUserData();
    }
  }

  void _navigateToPurchaseHistory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PurchaseHistoryPage()),
    );
    if (result == true) {
      _loadAllUserData();
    }
  }

  void _navigateToPaymentPlans(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentPlansPage()),
    );
    if (result == true) {
      _loadAllUserData();
    }
  }

  void _navigateToDownloadCertificate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificatePage(username: username),
      ),
    );
  }

  void _showChangePasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const ChangePasswordForm(),
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSection(username: username, email: email),
            UserStreakSection(
              key: ValueKey(
                currentStreak.toString() + loginDays.keys.join(),
              ),
              currentStreak: currentStreak,
              loginDays: loginDays,
            ),

            // Login Streak Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () => _navigateToStreakCalendar(context),
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
                  AppText.enText['login_streak_button']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Account Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                AppText.enText['account_section_title']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _buildCard([
              buildSettingsItem(
                icon: Icons.person_outline,
                title: AppText.enText['edit_personal_data']!,
                onTap: () => _navigateToEditPersonalData(context),
              ),
              _divider(),
              buildSettingsItem(
                icon: Icons.lock_outline,
                title: AppText.enText['change_password']!,
                onTap: () => _showChangePasswordModal(context),
              ),
            ]),

            // Subscription Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                AppText.enText['subscription_section_title']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _buildCard([
              buildSettingsItem(
                icon: Icons.payment_outlined,
                title: AppText.enText['payment_plans']!,
                trailing: _trialBadge(),
                onTap: () => _navigateToPaymentPlans(context),
              ),
              _divider(),
              buildSettingsItem(
                icon: Icons.history,
                title: AppText.enText['history_pembelian']!,
                onTap: () => _navigateToPurchaseHistory(context),
              ),
            ]),

            // Learning Progress Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                AppText.enText['learning_progress_section_title']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _buildCard([
              buildSettingsItem(
                icon: Icons.badge_outlined,
                title: AppText.enText['download_certificate']!,
                onTap: () => _navigateToDownloadCertificate(context),
              ),
            ]),

            // Support Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                AppText.enText['support_section_title']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _buildCard([
              buildSettingsItem(
                icon: Icons.help_outline,
                title: AppText.enText['help_support']!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpPage()),
                  );
                },
              ),
            ]),

            // Log Out Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: OutlinedButton(
                onPressed: () {
                  showLogoutConfirmationDialog(context, _handleLogout);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.logoutButton,
                  side: const BorderSide(color: AppColors.logoutButtonBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: Text(
                  AppText.enText['log_out_button']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Legal Info
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Divider(height: 1, color: AppColors.profileCardBorder),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      AppText.enText['terms_and_conditions']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: AppColors.profileCardBorder),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      AppText.enText['privacy_policy']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppText.enText['copyright_text']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.profileCardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.profileCardBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    thickness: 1,
    indent: 16,
    endIndent: 16,
    color: AppColors.profileCardBorder,
  );

  Widget _trialBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.trialBadgeBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppText.enText['start_trial_badge']!,
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
