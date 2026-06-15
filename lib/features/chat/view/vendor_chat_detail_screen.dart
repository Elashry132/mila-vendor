import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorChatDetailScreen extends StatelessWidget {
  final String customerName;
  final String customerImage;

  const VendorChatDetailScreen({
    super.key,
    required this.customerName,
    required this.customerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                _buildDateIndicator('Today'),
                const SizedBox(height: 32),
                _buildCustomerMessage(
                  'What time will you arrive tomorrow for the stage setup?',
                  '14:02 PM',
                ),
                const SizedBox(height: 24),
                _buildVendorMessage(
                  'Hi Sarah! We will be there at 9:00 AM sharp with the full team.',
                  '14:05 PM',
                ),
                const SizedBox(height: 24),
                _buildCustomerMessage(
                  'Perfect, thank you! I have the gate code for you: 1234.',
                  '14:06 PM',
                ),
                const SizedBox(height: 24),
                _buildScheduledEventCard(),
                const SizedBox(height: 120),
              ],
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            border: const Border(bottom: BorderSide(color: Color(0xFFF4F4F5))),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Avatar with border
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), spreadRadius: 2),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset('assets/images/chat_sarah_avatar.png', fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customerName, style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF323233), letterSpacing: -0.45,
                          )),
                          Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4E5F3E), shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('Online', style: GoogleFonts.inter(
                                fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF4E5F3E),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.phone_outlined, size: 18, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.more_vert_rounded, size: 16, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateIndicator(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E3E0),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(text.toUpperCase(), style: GoogleFonts.inter(
          fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1,
        )),
      ),
    );
  }

  Widget _buildCustomerMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.fromLTRB(20, 12, 25, 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
          ),
          child: Text(text, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF323233), height: 1.625,
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 4),
          child: Text(time, style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
          )),
        ),
      ],
    );
  }

  Widget _buildVendorMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.fromLTRB(20, 12, 31, 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.8, -0.8), end: Alignment(0.8, 0.8),
              colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
            ],
          ),
          child: Text(text, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white, height: 1.625,
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4, top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(time, style: GoogleFonts.inter(
                fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
              )),
              const SizedBox(width: 4),
              SvgPicture.asset('assets/icons/double_check.svg', width: 13, height: 7),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledEventCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.event_rounded, size: 18, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SCHEDULED EVENT', style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.6,
                  )),
                  Text('Stage Setup &\nLighting', style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF323233), height: 1.43,
                  )),
                ],
              ),
            ],
          ),
          Text('VIEW\nORDER', textAlign: TextAlign.center, style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, height: 1.33,
          )),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(48), topRight: Radius.circular(48)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(48), topRight: Radius.circular(48)),
            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 24, offset: Offset(0, -4))],
          ),
          child: Row(
            children: [
              // Attach button
              const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.add_circle_outline_rounded, size: 20, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              // Input field
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E3E0),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Type your message...', style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w400,
                          color: AppColors.textTertiary.withValues(alpha: 0.6),
                        )),
                      ),
                      const Icon(Icons.image_outlined, size: 15, color: AppColors.textTertiary),
                      const SizedBox(width: 12),
                      const Icon(Icons.attach_file_rounded, size: 13, color: AppColors.textTertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Send button
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
                  ],
                ),
                child: const Icon(Icons.send_rounded, size: 19, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
