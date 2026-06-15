import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/features/dashboard/view/vendor_dashboard_screen.dart';
import 'package:mila_vendor/services/api_service.dart';

class VendorOtpScreen extends StatefulWidget {
  final String phone;
  final String countryCode;

  const VendorOtpScreen({super.key, required this.phone, required this.countryCode});

  @override
  State<VendorOtpScreen> createState() => _VendorOtpScreenState();
}

class _VendorOtpScreenState extends State<VendorOtpScreen> {
  String _otpText = '';
  int _resendSeconds = 60;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _handleResend() async {
    if (_resendSeconds > 0) return;
    await ApiService.post('whatsapp/resend-otp', {
      'phone': widget.phone,
      'country_code': widget.countryCode,
    });
    _startTimer();
  }

  Future<void> _handleVerify() async {
    final otp = _otpText.trim();
    if (otp.length < 6) {
      setState(() => _errorMessage = 'Please enter the 6-digit code.');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = null; });

    final response = await ApiService.post('vendor/register/verify-otp', {
      'phone': widget.phone,
      'country_code': widget.countryCode,
      'otp': otp,
    });

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response['status'] == true) {
      final token = response['token'] ?? response['data']?['token'] ?? response['access_token'];
      if (token != null) await ApiService.saveToken(token.toString());
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
          (_) => false,
        );
      }
    } else {
      setState(() => _errorMessage = response['message'] ?? 'Invalid code. Please try again.');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text('Verify Your Number', style: GoogleFonts.plusJakartaSans(
                fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF323233), letterSpacing: -0.75,
              )),
              const SizedBox(height: 12),
              Text(
                'We sent a 6-digit code via WhatsApp to\n+${widget.countryCode} ${widget.phone}',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 48),
              PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(16),
                  fieldHeight: 56, fieldWidth: 48,
                  activeFillColor: Colors.white,
                  inactiveFillColor: const Color(0xFFF5F0EE),
                  selectedFillColor: Colors.white,
                  activeColor: AppColors.primary,
                  inactiveColor: const Color(0xFFE8E3E0),
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
                textStyle: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF323233)),
                onChanged: (v) { _otpText = v; if (_errorMessage != null) setState(() => _errorMessage = null); },
                onCompleted: (v) { _otpText = v; _handleVerify(); },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(_errorMessage!, style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFFBA1A1A),
                )),
              ],
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _isLoading ? null : _handleVerify,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 25, offset: const Offset(0, 20), spreadRadius: -5)],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('Verify & Continue', style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFFFFF7F6),
                          )),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _resendSeconds > 0 ? null : _handleResend,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                    children: [
                      const TextSpan(text: "Didn't receive the code? "),
                      TextSpan(
                        text: _resendSeconds > 0 ? 'Resend in ${_resendSeconds}s' : 'Resend',
                        style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: _resendSeconds > 0 ? AppColors.textTertiary : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
