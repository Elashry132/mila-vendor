import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/features/auth/view/vendor_otp_screen.dart';
import 'package:mila_vendor/services/api_service.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  static const List<String> _categories = [
    'Decoration',
    'Catering',
    'Photography',
    'Lighting',
    'Music',
    'Venue',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || location.isEmpty || _selectedCategory == null) {
      setState(() => _errorMessage = 'Please fill in all fields and select a category.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    final response = await ApiService.post('vendor/register/initiate', {
      'business_name': name,
      'category': _selectedCategory,
      'email': email,
      'phone': phone,
      'location': location,
    });

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response['status'] == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VendorOtpScreen(phone: phone, countryCode: '1'),
        ),
      );
    } else {
      setState(() => _errorMessage = response['message'] ?? 'Registration failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 96, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                Row(children: [
                  Container(width: 64, height: 6, decoration: BoxDecoration(
                    color: AppColors.primary, borderRadius: BorderRadius.circular(9999),
                  )),
                  const SizedBox(width: 8),
                  Container(width: 64, height: 6, decoration: BoxDecoration(
                    color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(9999),
                  )),
                  const SizedBox(width: 8),
                  Container(width: 64, height: 6, decoration: BoxDecoration(
                    color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(9999),
                  )),
                ]),
                const SizedBox(height: 32),
                // Header
                Text('Register your\nbusiness', style: GoogleFonts.plusJakartaSans(
                  fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFF323233),
                  letterSpacing: -0.9, height: 1.11,
                )),
                const SizedBox(height: 12),
                Text(
                  'Join our network of elite vendors. Provide your basic details to start your application.',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.625),
                ),
                const SizedBox(height: 32),
                // Form
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
                  ),
                  child: Column(
                    children: [
                      if (_errorMessage != null) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                          child: Container(
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
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildFormField('Business Name', 'e.g. Royal Decorators', _nameController),
                      const SizedBox(height: 24),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 24),
                      _buildFormField('Business Email', 'name@company.com', _emailController,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 24),
                      _buildFormField('Phone Number', '+1 (555) 000-0000', _phoneController,
                          keyboardType: TextInputType.phone),
                      const SizedBox(height: 24),
                      _buildFormField('Location', 'City, Country', _locationController, hasLocationIcon: true),
                      const SizedBox(height: 40),
                      // Continue button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          onTap: _isLoading ? null : _handleContinue,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
                              borderRadius: BorderRadius.circular(48),
                              boxShadow: [
                                BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 12)),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(width: 24, height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text('Continue', style: GoogleFonts.inter(
                                      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white,
                                    )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Terms
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.625),
                            children: [
                              const TextSpan(text: 'By clicking Continue, you agree to our '),
                              TextSpan(text: 'Terms of Service', style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary,
                              )),
                              const TextSpan(text: ' and '),
                              TextSpan(text: 'Privacy Policy', style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary,
                              )),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Info cards
                _buildInfoCard(Icons.shield_outlined, 'Secure', 'Your data is encrypted and handled with care.'),
                const SizedBox(height: 24),
                _buildInfoCard(Icons.bolt_rounded, 'Fast Track', 'Get verified and start selling in under 24 hours.'),
                const SizedBox(height: 24),
                _buildInfoCard(Icons.headset_mic_outlined, 'Support', 'Dedicated onboarding team available 24/7.'),
                const SizedBox(height: 32),
                // Footer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 33),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.divider.withValues(alpha: 0.1))),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                          children: [
                            const TextSpan(text: 'Already a vendor? '),
                            TextSpan(text: 'Sign In', style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Header
          Positioned(
            top: 0, left: 0, right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: AppColors.background.withValues(alpha: 0.8),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Vendor Portal', style: GoogleFonts.plusJakartaSans(
                            fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: -0.5,
                          )),
                          Text('Step 1 of 3', style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, bool hasLocationIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
          )),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(32),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(fontSize: 16, color: AppColors.textTertiary.withValues(alpha: 0.6)),
                    contentPadding: EdgeInsets.fromLTRB(20, 18, hasLocationIcon ? 48 : 20, 18),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF323233)),
                ),
              ),
              if (hasLocationIcon)
                Positioned(
                  right: 16, top: 0, bottom: 0,
                  child: Icon(Icons.my_location_rounded, size: 20, color: AppColors.textTertiary),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category', style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
          )),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            hint: Text('Select Category', style: GoogleFonts.inter(fontSize: 16, color: AppColors.textTertiary.withValues(alpha: 0.6))),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE8E3E0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF323233)),
            dropdownColor: const Color(0xFFE8E3E0),
            icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: AppColors.textSecondary),
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) => setState(() => _selectedCategory = val),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E3E0).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.plusJakartaSans(
            fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
          )),
          const SizedBox(height: 4),
          Text(desc, style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
          )),
        ],
      ),
    );
  }
}
