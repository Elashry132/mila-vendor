import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorForgotPasswordScreen extends StatefulWidget {
  const VendorForgotPasswordScreen({super.key});

  @override
  State<VendorForgotPasswordScreen> createState() => _VendorForgotPasswordScreenState();
}

class _VendorForgotPasswordScreenState extends State<VendorForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _emailSent ? _buildSuccess() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text('Forgot Password?', style: GoogleFonts.plusJakartaSans(
          fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF323233), letterSpacing: -0.75,
        )),
        const SizedBox(height: 12),
        Text('Enter your business email and we\'ll send you a link to reset your password.',
          style: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 40),
        Text('BUSINESS EMAIL', style: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
        )),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(32)),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'vendor@company.com',
              hintStyle: GoogleFonts.inter(fontSize: 16, color: AppColors.textTertiary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
            ),
            style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF323233)),
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () => setState(() => _emailSent = true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
              borderRadius: BorderRadius.circular(9999),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 25, offset: const Offset(0, 20), spreadRadius: -5)],
            ),
            child: Center(child: Text('Send Reset Link', style: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFFFFF7F6),
            ))),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 96, height: 96,
          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_outlined, size: 48, color: Color(0xFF4E5F3E)),
        ),
        const SizedBox(height: 32),
        Text('Check Your Email', style: GoogleFonts.plusJakartaSans(
          fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF323233), letterSpacing: -0.75,
        )),
        const SizedBox(height: 12),
        Text('We\'ve sent a password reset link to\n${_emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Center(child: Text('Back to Login', style: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFFFFF7F6),
            ))),
          ),
        ),
      ],
    );
  }
}
