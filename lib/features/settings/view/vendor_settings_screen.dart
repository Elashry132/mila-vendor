import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorSettingsScreen extends StatefulWidget {
  const VendorSettingsScreen({super.key});

  @override
  State<VendorSettingsScreen> createState() => _VendorSettingsScreenState();
}

class _VendorSettingsScreenState extends State<VendorSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _autoAccept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Account section
                _buildSection('Account', [
                  _buildSettingsTile(Icons.person_outline_rounded, 'Personal Information'),
                  _buildSettingsTile(Icons.lock_outline_rounded, 'Change Password'),
                  _buildSettingsTile(Icons.payment_rounded, 'Payout Settings'),
                  _buildSettingsTile(Icons.account_balance_outlined, 'Bank Details'),
                ]),
                const SizedBox(height: 32),
                // Preferences
                _buildSection('Preferences', [
                  _buildToggleTile(Icons.notifications_none_rounded, 'Push Notifications',
                    'Booking alerts and messages', _pushNotifications, (v) => setState(() => _pushNotifications = v)),
                  _buildToggleTile(Icons.email_outlined, 'Email Notifications',
                    'Weekly reports and updates', _emailNotifications, (v) => setState(() => _emailNotifications = v)),
                  _buildToggleTile(Icons.flash_on_rounded, 'Auto-Accept Bookings',
                    'Automatically accept new requests', _autoAccept, (v) => setState(() => _autoAccept = v)),
                ]),
                const SizedBox(height: 32),
                // Business
                _buildSection('Business', [
                  _buildSettingsTile(Icons.schedule_rounded, 'Availability Hours'),
                  _buildSettingsTile(Icons.map_outlined, 'Service Area'),
                  _buildSettingsTile(Icons.description_outlined, 'Terms & Policies'),
                ]),
                const SizedBox(height: 32),
                // Support
                _buildSection('Support', [
                  _buildSettingsTile(Icons.help_outline_rounded, 'Help Center'),
                  _buildSettingsTile(Icons.article_outlined, 'Terms of Service'),
                ]),
                const SizedBox(height: 16),
                // Logout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAA371C).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(children: [
                    const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFAA371C)),
                    const SizedBox(width: 16),
                    Text('LOG OUT', style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFAA371C), letterSpacing: 1.4,
                    )),
                  ]),
                ),
                const SizedBox(height: 32),
                // Version
                Center(child: Text('Mila Vendor v1.0.0', style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textTertiary,
                ))),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.7),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Text('Settings', style: GoogleFonts.plusJakartaSans(
                  fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF323233), letterSpacing: -0.45,
                )),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.plusJakartaSans(
          fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
        )),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(32),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.3), shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Text(label, style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF323233),
            )),
          ]),
          const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(32),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.3), shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF323233))),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
          ],
        )),
        Switch.adaptive(
          value: value, onChanged: onChanged,
          activeThumbColor: Colors.white, activeTrackColor: AppColors.primary,
        ),
      ]),
    );
  }
}
