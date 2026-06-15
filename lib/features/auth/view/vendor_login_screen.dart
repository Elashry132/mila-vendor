import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/features/auth/view/vendor_register_screen.dart';
import 'package:mila_vendor/features/auth/view/vendor_forgot_password_screen.dart';
import 'package:mila_vendor/features/dashboard/view/vendor_dashboard_screen.dart';
import 'package:mila_vendor/services/api_service.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null || !mounted) return;
      final auth = await googleUser.authentication;
      final response = await ApiService.post('auth/google', {
        'id_token': auth.idToken ?? '',
        'email': googleUser.email,
        'name': googleUser.displayName ?? '',
      });
      if (!mounted) return;
      if (response['status'] == true) {
        final token = response['token'] ?? response['data']?['token'] ?? response['access_token'];
        if (token != null) {
          await ApiService.saveToken(token.toString());
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
              (_) => false,
            );
          }
        }
      } else {
        setState(() => _errorMessage = response['message'] ?? 'Google sign-in failed');
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Google sign-in failed: $e');
    }
  }

  Future<void> _handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final response = await ApiService.post('auth/apple', {
        'identity_token': credential.identityToken ?? '',
        'email': credential.email ?? '',
        'given_name': credential.givenName ?? '',
        'family_name': credential.familyName ?? '',
      });
      if (!mounted) return;
      if (response['status'] == true) {
        final token = response['token'] ?? response['data']?['token'] ?? response['access_token'];
        if (token != null) {
          await ApiService.saveToken(token.toString());
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
              (_) => false,
            );
          }
        }
      } else {
        setState(() => _errorMessage = response['message'] ?? 'Apple sign-in failed');
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Apple sign-in failed: $e');
    }
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter email and password');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    final response = await ApiService.post('login', {
      'email': email,
      'password': password,
    });

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (response['status'] == false) {
      setState(() => _errorMessage = response['message'] ?? 'Login failed');
    } else {
      final token = response['token'] ?? response['data']?['token'] ?? response['access_token'];
      if (token != null) {
        await ApiService.saveToken(token.toString());
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
          (route) => false,
        );
      } else {
        setState(() => _errorMessage = 'Invalid response from server');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blurs
          Positioned(
            top: -72, right: -32,
            child: Container(
              width: 130, height: 289,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: const SizedBox(),
              ),
            ),
          ),
          Positioned(
            bottom: 14, left: -24,
            child: Container(
              width: 98, height: 217,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: const SizedBox(),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  children: [
                    // Branding
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/logo_sparkle.svg', width: 30, height: 27),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Mila Vendor', style: GoogleFonts.plusJakartaSans(
                      fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.75,
                    )),
                    const SizedBox(height: 4),
                    Text('The Vendor Command Center', style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
                    )),
                    const SizedBox(height: 40),
                    // Login card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(33),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(color: AppColors.divider.withValues(alpha: 0.15)),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 12)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back', style: GoogleFonts.plusJakartaSans(
                            fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                          )),
                          const SizedBox(height: 4),
                          Text('Please enter your credentials to access\nyour dashboard.', style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.43,
                          )),
                          const SizedBox(height: 32),
                          // Error message
                          if (_errorMessage != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBA1A1A).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(_errorMessage!, style: GoogleFonts.inter(
                                fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFFBA1A1A),
                              )),
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Email
                          _buildLabel('EMAIL OR PHONE'),
                          const SizedBox(height: 8),
                          _buildInput(_emailController, 'vendor@mila.com'),
                          const SizedBox(height: 24),
                          // Password
                          Row(
                            children: [
                              Expanded(child: _buildLabel('PASSWORD')),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const VendorForgotPasswordScreen()),
                                ),
                                child: Text('Forgot Password?', style: GoogleFonts.inter(
                                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary,
                                )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              _buildInput(_passwordController, '••••••••', obscure: _obscurePassword),
                              Positioned(
                                right: 16, top: 0, bottom: 0,
                                child: GestureDetector(
                                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                                  child: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    size: 18, color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Login button
                          GestureDetector(
                            onTap: _isLoading ? null : _handleLogin,
                            child: Container(
                              width: double.infinity, height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
                                ],
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24, height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : Text('Login to Dashboard', style: GoogleFonts.plusJakartaSans(
                                        fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white,
                                      )),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Divider
                          Row(children: [
                            Expanded(child: Container(height: 1, color: AppColors.divider.withValues(alpha: 0.2))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR CONTINUE WITH', style: GoogleFonts.inter(
                                fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
                              )),
                            ),
                            Expanded(child: Container(height: 1, color: AppColors.divider.withValues(alpha: 0.2))),
                          ]),
                          const SizedBox(height: 32),
                          // Social buttons
                          Row(children: [
                            Expanded(child: _buildSocialButton('Google', Icons.g_mobiledata_rounded, _handleGoogleSignIn)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildSocialButton('Apple', Icons.apple_rounded, _handleAppleSignIn)),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Apply link
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VendorRegisterScreen()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                          children: [
                            const TextSpan(text: 'New to the platform? '),
                            TextSpan(text: 'Apply for Vendor Account', style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.6,
    ));
  }

  Widget _buildInput(TextEditingController controller, String hint, {bool obscure = false}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(32),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF6B7280)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
        ),
        style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF323233)),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0EE),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF323233)),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
            )),
          ],
        ),
      ),
    );
  }
}
