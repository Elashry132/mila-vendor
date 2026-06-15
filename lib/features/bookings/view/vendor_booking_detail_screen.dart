import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorBookingDetailScreen extends StatelessWidget {
  const VendorBookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 96, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent, borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text('CONFIRMED', style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF4E5F3E), letterSpacing: 0.55,
                  )),
                ),
                const SizedBox(height: 16),
                Text('Floral Arrangement\nWedding Pack', style: GoogleFonts.plusJakartaSans(
                  fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF323233), letterSpacing: -0.7, height: 1.2,
                )),
                const SizedBox(height: 32),
                // Client info card
                _buildSectionCard('Client Information', [
                  _buildInfoRow(Icons.person_outline_rounded, 'CLIENT', 'Sarah Jenkins'),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.email_outlined, 'EMAIL', 'sarah.j@email.com'),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.phone_outlined, 'PHONE', '+971 50 987 6543'),
                ]),
                const SizedBox(height: 24),
                // Schedule card
                _buildSectionCard('Schedule Details', [
                  _buildInfoRow(Icons.calendar_today_rounded, 'DATE', 'Saturday, October 24, 2024'),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.access_time_rounded, 'TIME', '2:00 PM — 6:00 PM'),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.location_on_outlined, 'VENUE', 'The Grand Ballroom, Dubai Marina'),
                ]),
                const SizedBox(height: 24),
                // Service details
                _buildSectionCard('Service Details', [
                  _buildDetailRow('Service Package', 'Premium Wedding Florals'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0x1AB2B2B1)),
                  ),
                  _buildDetailRow('Guest Count', '150 guests'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0x1AB2B2B1)),
                  ),
                  _buildDetailRow('Special Requests', 'White peonies + gold accents'),
                ]),
                const SizedBox(height: 24),
                // Payment
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(48),
                    boxShadow: [BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 12))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PAYMENT SUMMARY', style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
                      )),
                      const SizedBox(height: 20),
                      _buildDetailRow('Service Fee', '\$2,450.00'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Platform Fee', '-\$122.50'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, color: Color(0x1AB2B2B1)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Earnings', style: GoogleFonts.inter(
                            fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
                          )),
                          Text('\$2,327.50', style: GoogleFonts.plusJakartaSans(
                            fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.6,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Notes
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CLIENT NOTES', style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
                      )),
                      const SizedBox(height: 12),
                      Text(
                        '"Please enter through the garden gate. The venue coordinator is Maria — she\'ll show you to the setup area. We\'d love extra greenery near the entrance arch."',
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.625, fontStyle: FontStyle.italic),
                      ),
                    ],
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
                  color: AppColors.surface.withValues(alpha: 0.7),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
                            ),
                            const SizedBox(width: 16),
                            Text('Booking Details', style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF323233), letterSpacing: -0.45,
                            )),
                          ]),
                          const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom actions
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white.withValues(alpha: 0.85),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Chat button
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight, shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: AppColors.primaryDark),
                        ),
                        const SizedBox(width: 12),
                        // Mark complete
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 25, offset: const Offset(0, 20), spreadRadius: -5)],
                            ),
                            child: Center(child: Text('Mark as Complete', style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFFFFF7F6),
                            ))),
                          ),
                        ),
                      ],
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

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
          )),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(
                fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5,
              )),
              Text(value, style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary))),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF323233))),
      ],
    );
  }
}
