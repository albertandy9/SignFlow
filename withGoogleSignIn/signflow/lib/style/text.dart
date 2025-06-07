import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle unitLabel = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  static const TextStyle chapterText = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  static const TextStyle chapterTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  );

  static const TextStyle chapterLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  );

  static const TextStyle completedText = TextStyle(
    fontSize: 14,
    color: Colors.deepPurple,
  );
}

class AppText {
  static final enText = {
    'welcome_text': 'welcome',
    'signIn_text': 'Sign in to your account',
    'registered_text': 'Already have an acount?',
    'register_text': 'You can easily sign up',
    'signUp_text': 'Don\'t have an account?',
    'social-login': 'Or continue with social account',
    'forgot-password': 'Forgot Your Password?',
    'login_error_wrong': 'Wrong Email/Password. Try again.',
    'email_wrong': 'This email is not registered.',
    'signIn_button': 'Sign In',
    'signUp_button': 'Sign Up',
    'email_address_hint': 'Email Address',
    'email_label': 'Email',
    'password_hint': 'Password',
    'password_label': 'Password',
    'full_name_label': 'Full Name',
    'full_name_hint': 'Full Name',
    'name_empty_error': 'Enter your name',
    'signup_error_general': 'Failed to register.',
    'signup_error_unexpected': 'An unexpected error occurred during signup.',
    'alphabet_title': 'Alphabet',
    // Homepage specific texts
    'hp_status_title': 'HP Status',
    'hp_current_status': 'Your current HP: ',
    'restore_hp_button': 'Restore HP',
    'close_button': 'Close',
    'hp_restore_success': 'HP successfully restored!',
    // AppBar texts
    'app_logo_text': 'logo',
    'streak_display': '0',
    'reset_progress_tooltip': 'Reset Progress',
    // Navbar texts
    'navbar_home': 'Home',
    'navbar_dictionary': 'Dictionary',
    'navbar_profile': 'Profile',
    // MainLayout texts
    'streak_reset': 'Streak reset! You missed a login.',
    'streak_reward_hp': 'Congratulations! You reached a ',
    'streak_reward_hp_suffix': ' day streak and gained 1 HP.',
    'streak_reward_full_hp': 'Congratulations! You reached a ',
    'streak_reward_full_hp_suffix': ' day streak, but your HP is already full.',
    'progress_reset_success': 'Progress successfully reset',
    // Lessons page texts
    'loading_lessons': 'Loading lessons...',
    'learn_new_sign': 'Learn a new sign!',
    'lessons_in_chapter': ' lessons in this chapter',
    'chapter_completed_title': 'Chapter Completed!',
    'chapter_completed_congratulations': 'Congratulations! You completed ',
    'chapter_completed_trophy': '. You earned a trophy!',
    'great_button': 'Great!',
    'video_load_error': 'Video could not be loaded',
    // Lesson question page texts
    'answer_question_title': 'Answer This Question Correctly',
    'correct_answer_dialog_title': 'Your Answer is Correct',
    'wrong_answer_dialog_title': 'Your Answer is Wrong',
    'correct_answer_message':
        'You answered correctly! Please proceed to the next lesson.',
    'wrong_answer_message': 'Try again!',
    'continue_button': 'Continue',
    'try_again_button': 'Try Again',
    'hp_empty_title': 'HP Exhausted!',
    'hp_empty_message':
        'Your HP is exhausted. You cannot continue lessons before restoring HP.',
    'okay_button': 'Okay',
    'submit_button': 'Submit',
    // ChapterTitle texts
    'chapter_label_prefix': 'CHAPTER ',
    'chapter_completed_text': 'Completed',
    // LessonTitle texts
    'lesson_prefix': 'Lesson ',
    // Purchase HP Page texts
    'buy_hp_title': 'Buy Additional HP',
    'hp_current_status_purchase': 'Your current HP: ',
    'choose_hp_pack': 'Choose HP pack:',
    'price_prefix': 'Price: Rp ',
    'buy_button': 'Buy',
    'purchase_success_message': 'Successfully purchased ',
    'hp_suffix': ' HP!',
    'purchase_note': 'Note: Purchase will only fill HP up to a maximum of ',
    'hp_pack_1_hp_desc': '1 HP',
    'hp_pack_2_hp_desc': '2 HP',
    'hp_pack_full_hp_desc': 'Full HP',
    // Profile Page texts
    'account_section_title': 'Account',
    'subscription_section_title': 'Subscription',
    'learning_progress_section_title': 'Learning progress',
    'support_section_title': 'Support',
    'login_streak_button': 'Login Streak',
    'edit_personal_data': 'Edit personal data',
    'change_password': 'Change password',
    'payment_plans': 'Payment plans',
    'history_pembelian': 'History Pembelian',
    'download_certificate': 'Download certificate',
    'help_support': 'Help',
    'log_out_button': 'Log out',
    'terms_and_conditions': 'Terms and Conditions',
    'privacy_policy': 'Privacy Policy',
    'copyright_text': '© SignFlow 2025',
    'start_trial_badge': 'START TRIAL',
    'dialog_logout_title': 'Log out?',
    'dialog_logout_content': 'Are you sure you want to log out?',
    'dialog_logout_cancel': 'Cancel',
    'dialog_logout_confirm': 'Log out',
    // Change Password Form texts
    'change_password_form_title': 'Change your password',
    'current_password_label': 'Current password',
    'new_password_label': 'New password',
    'new_password_hint': 'At least 6 characters',
    'confirm_new_password_label': 'Confirm new password',
    'password_change_success': 'Password changed successfully',
    'password_mismatch_error': 'New passwords do not match.',
    'no_user_error': 'No user signed in',
    'user_email_not_found_error': 'User email not found',
    'something_wrong_error': 'Something went wrong',
    'unexpected_error': 'Unexpected error occurred.',
    'save_changes_button': 'Save changes',
    // Edit Personal Data Form texts
    'edit_personal_data_title': 'Edit Personal Data',
    'name_label': 'Name',
    'email_label_edit': 'Email',
    'current_password_edit_label': 'Current password',
    'password_to_update_email_hint':
        'Type in your password to update your email',
    'fill_all_data_error': 'Please fill in all data',
    'profile_update_success': 'Profile updated successfully',
    'failed_update_profile': 'Failed to update profile',
    // Download Certificate Page texts
    'download_certificate_title_page':
        'Download Certificate', 
    'download_as_image': 'Download as Image',
    'download_as_pdf': 'Download as PDF',
    'certificate_image_downloaded': 'Certificate downloaded as image.',
    'certificate_pdf_downloaded': 'Certificate downloaded as PDF.',
    'certificate_main_title': 'SingFlow Certificate',
    'issued_to': 'Issued to: ',
    'date_prefix': 'Date: ',
    'certificate_completion_note':
        'Your certificate will be available once you complete all courses.',
    'download_button': 'Download',
    // Help Page texts
    'help_page_title': 'Help & Support',
    'help_page_content': 'Frequently Asked Questions and contact support.',
    // User Streak Section texts
    'streak_current': 'Streak: ',
    'days_suffix': ' days',
    'most_popular_label': 'MOST POPULAR',
    'learn_for_price_per_week': 'Learn BSL for just Rp 2.000 per week.',
    'purchase_now_button': 'Purchase Now',
    'selected_plan_message': 'Selected Plan: ',
    // Streak Calendar Page texts
    'calendar_updated': 'Calendar updated!',
    'hp_bonus_title': 'HP Bonus!',
    'hp_bonus_content_prefix': 'Congratulations! You reached a streak of ',
    'hp_bonus_content_suffix_1': ' days and gained 1 HP. Your HP is now: ',
    'hp_bonus_content_suffix_2': '/',
    'ok_button': 'Ok!',
    'current_streak_display': 'Current Streak: ',
    'update_calendar_button': 'Update Calendar',
    // Purchase History Page texts
    'purchase_history_title': 'Purchase History',
    'no_purchase_history': 'No purchase history yet.',
    'date_label_prefix': 'Date: ',
    // Payment Plans page texts
    'choose_plan_after_trial': 'Choose a plan for after your\n7 day free trial',
    'annual_plan_title': 'Annual',
    'three_months_plan_title': '3 Months',
    'monthly_plan_title': 'Monthly',
  };
}
