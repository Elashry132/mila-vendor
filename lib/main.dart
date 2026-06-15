import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/features/auth/view/vendor_login_screen.dart';
import 'package:mila_vendor/features/dashboard/view/vendor_dashboard_screen.dart';
import 'package:mila_vendor/services/api_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ApiService.init();
  runApp(const MilaVendorApp());
}

class MilaVendorApp extends StatelessWidget {
  const MilaVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mila Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: ApiService.isLoggedIn
          ? const VendorDashboardScreen()
          : const VendorLoginScreen(),
    );
  }
}
