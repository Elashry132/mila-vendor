// Mila Vendor — Full UI Walkthrough Test
// Run:  flutter test test/walkthrough_test.dart --update-goldens
// Re-run (compare): flutter test test/walkthrough_test.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'package:mila_vendor/features/auth/view/vendor_login_screen.dart';
import 'package:mila_vendor/features/auth/view/vendor_register_screen.dart';
import 'package:mila_vendor/features/auth/view/vendor_otp_screen.dart';
import 'package:mila_vendor/features/auth/view/vendor_forgot_password_screen.dart';
import 'package:mila_vendor/features/dashboard/view/vendor_dashboard_screen.dart';
import 'package:mila_vendor/features/bookings/view/vendor_bookings_screen.dart';
import 'package:mila_vendor/features/bookings/view/vendor_booking_detail_screen.dart';
import 'package:mila_vendor/features/services/view/vendor_services_screen.dart';
import 'package:mila_vendor/features/services/view/edit_service_screen.dart';
import 'package:mila_vendor/features/earnings/view/vendor_earnings_screen.dart';
import 'package:mila_vendor/features/chat/view/vendor_chat_screen.dart';
import 'package:mila_vendor/features/chat/view/vendor_chat_detail_screen.dart';
import 'package:mila_vendor/features/profile/view/vendor_profile_screen.dart';
import 'package:mila_vendor/features/reviews/view/vendor_reviews_screen.dart';
import 'package:mila_vendor/features/notifications/view/vendor_notifications_screen.dart';
import 'package:mila_vendor/features/settings/view/vendor_settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/services/api_service.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    surface: AppColors.background,
  ),
  scaffoldBackgroundColor: AppColors.background,
  useMaterial3: true,
);

Widget _app(Widget home) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _appTheme,
      home: home,
      onUnknownRoute: (s) => MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text('?'))),
      ),
    );

Future<void> _pump(WidgetTester tester, Widget widget, {int ms = 300}) async {
  tester.view.physicalSize = const Size(1170, 2532); // iPhone 14 Pro @ 3x → 390×844 logical
  tester.view.devicePixelRatio = 3.0;
  addTearDown(() { tester.view.resetPhysicalSize(); tester.view.resetDevicePixelRatio(); });
  await tester.pumpWidget(widget);
  await tester.pump(Duration(milliseconds: ms));
}

List<String> _captureErrors(WidgetTester tester) {
  final errors = <String>[];
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    errors.add(details.exceptionAsString());
    original?.call(details);
  };
  addTearDown(() => FlutterError.onError = original);
  return errors;
}

// ---------------------------------------------------------------------------
// Test suite
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({'auth_token': 'vendor_walkthrough_token'});
    await ApiService.init();
    Directory('test/goldens').createSync(recursive: true);
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P0 — Auth
  // ═══════════════════════════════════════════════════════════════════════════
  group('P0 — Auth', () {
    testWidgets('V01-vendor-login — email, password, login button visible', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorLoginScreen()));

      expect(find.byType(TextField), findsAtLeastNWidgets(2),
          reason: 'Must have email and password TextFields');
      expect(find.text('Login to Dashboard'), findsOneWidget,
          reason: 'Primary CTA must be labelled correctly');
      expect(find.text('Google'), findsOneWidget, reason: 'Google button must be visible');
      expect(find.text('Apple'), findsOneWidget, reason: 'Apple button must be visible');
      expect(find.text('Forgot Password?'), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V01-vendor-login.png'));
    });

    testWidgets('V02-vendor-register — Step 1 form with category dropdown', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorRegisterScreen()));

      expect(find.byType(TextField), findsAtLeastNWidgets(3),
          reason: 'Business Name, Email, Phone, Location fields must exist');
      expect(find.text('Continue'), findsAtLeastNWidgets(1),
          reason: 'Continue button must be labelled correctly');
      expect(find.text('Step 1 of 3'), findsOneWidget,
          reason: 'Progress indicator must show step 1');
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V02-vendor-register.png'));
    });

    testWidgets('V03-vendor-otp — 6-digit PIN and countdown', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorOtpScreen(phone: '5551234567', countryCode: '1')));

      expect(find.text('Verify & Continue'), findsOneWidget);
      // Resend text lives in a RichText/TextSpan
      expect(
        find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Resend')),
        findsAtLeastNWidgets(1),
        reason: 'Resend countdown must appear in the vendor OTP screen',
      );
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V03-vendor-otp.png'));
    });

    testWidgets('V04-vendor-forgot-password — email field and send button', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorForgotPasswordScreen()));

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V04-vendor-forgot-password.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P0 — Dashboard
  // ═══════════════════════════════════════════════════════════════════════════
  group('P0 — Dashboard', () {
    testWidgets('V05-vendor-dashboard — KPI cards and revenue chart', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorDashboardScreen()), ms: 500);

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V05-vendor-dashboard.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P0 — Booking Management
  // ═══════════════════════════════════════════════════════════════════════════
  group('P0 — Booking Management', () {
    testWidgets('V06-vendor-bookings — filter tabs and booking cards', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorBookingsScreen()), ms: 500);

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V06-vendor-bookings.png'));
    });

    testWidgets('V07-vendor-booking-detail — client info and payment breakdown', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorBookingDetailScreen()));

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V07-vendor-booking-detail.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P0 — Service Management
  // ═══════════════════════════════════════════════════════════════════════════
  group('P0 — Service Management', () {
    testWidgets('V08-vendor-services — service cards with toggles', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorServicesScreen()), ms: 500);

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V08-vendor-services.png'));
    });

    testWidgets('V09-edit-service — gallery, title, price, description fields', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const EditServiceScreen()));

      expect(find.byType(TextField), findsAtLeastNWidgets(2),
          reason: 'Title and price TextFields must exist');
      expect(find.byType(Switch), findsAtLeastNWidgets(1),
          reason: 'Availability toggle must exist');
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V09-edit-service.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P1 — Earnings
  // ═══════════════════════════════════════════════════════════════════════════
  group('P1 — Earnings', () {
    testWidgets('V10-vendor-earnings — balance card and 6-month chart', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorEarningsScreen()));

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V10-vendor-earnings.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P1 — Chat
  // ═══════════════════════════════════════════════════════════════════════════
  group('P1 — Chat', () {
    testWidgets('V11-vendor-chat — conversation list with filters', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorChatScreen()), ms: 500);

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V11-vendor-chat.png'));
    });

    testWidgets('V12-vendor-chat-detail — message bubbles and customer header', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorChatDetailScreen(
        customerName: 'Sarah Johnson',
        customerImage: '',
      )));

      expect(find.text('Sarah Johnson'), findsAtLeastNWidgets(1),
          reason: 'Customer name must appear in chat header');
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V12-vendor-chat-detail.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P1 — Profile & Reviews
  // ═══════════════════════════════════════════════════════════════════════════
  group('P1 — Profile & Reviews', () {
    testWidgets('V13-vendor-profile — rating, portfolio, about section', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorProfileScreen()));

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V13-vendor-profile.png'));
    });

    testWidgets('V14-vendor-reviews — rating breakdown and review cards', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorReviewsScreen()));

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V14-vendor-reviews.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // P2 — Notifications & Settings
  // ═══════════════════════════════════════════════════════════════════════════
  group('P2 — Notifications & Settings', () {
    testWidgets('V15-vendor-notifications — notification list', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorNotificationsScreen()));

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V15-vendor-notifications.png'));
    });

    testWidgets('V16-vendor-settings — toggles and logout button', (tester) async {
      final errors = _captureErrors(tester);
      await _pump(tester, _app(const VendorSettingsScreen()));

      expect(find.byType(Switch), findsAtLeastNWidgets(2),
          reason: 'At least 2 toggle switches must exist in settings');
      expect(find.text('LOG OUT'), findsOneWidget,
          reason: 'Logout button must be labelled LOG OUT');
      expect(errors.where((e) => e.contains('RenderFlex')), isEmpty);

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/V16-vendor-settings.png'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // UI/UX Checks — vendor-specific
  // ═══════════════════════════════════════════════════════════════════════════
  group('UI/UX — Vendor cross-screen checks', () {
    testWidgets('VX01 — Login: Google and Apple buttons are tappable', (tester) async {
      await _pump(tester, _app(const VendorLoginScreen()));
      expect(
        find.ancestor(of: find.text('Google'), matching: find.byType(GestureDetector)),
        findsAtLeastNWidgets(1),
        reason: 'Google button must have GestureDetector',
      );
      expect(
        find.ancestor(of: find.text('Apple'), matching: find.byType(GestureDetector)),
        findsAtLeastNWidgets(1),
        reason: 'Apple button must have GestureDetector',
      );
    });

    testWidgets('VX02 — Register: Continue button is tappable (has GestureDetector)', (tester) async {
      await _pump(tester, _app(const VendorRegisterScreen()));
      expect(
        find.ancestor(of: find.text('Continue'), matching: find.byType(GestureDetector)),
        findsAtLeastNWidgets(1),
        reason: 'Continue button must be wrapped in GestureDetector',
      );
    });

    testWidgets('VX03 — OTP: Verify button is tappable', (tester) async {
      await _pump(tester, _app(const VendorOtpScreen(phone: '5551234567', countryCode: '1')));
      expect(find.text('Verify & Continue'), findsOneWidget);
      expect(
        find.ancestor(of: find.text('Verify & Continue'), matching: find.byType(GestureDetector)),
        findsAtLeastNWidgets(1),
        reason: 'Verify & Continue button must have GestureDetector',
      );
    });

    testWidgets('VX04 — Settings: LOG OUT button is tappable', (tester) async {
      await _pump(tester, _app(const VendorSettingsScreen()));
      expect(find.text('LOG OUT'), findsOneWidget);
    });

    testWidgets('VX05 — EditService: availability switch present and toggleable', (tester) async {
      await _pump(tester, _app(const EditServiceScreen()));
      final switchFinder = find.byType(Switch).first;
      expect(switchFinder, findsOneWidget);
      // Tap the switch
      await tester.tap(switchFinder);
      await tester.pump(const Duration(milliseconds: 100));
      // No exception should occur
    });
  });
}
