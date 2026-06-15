import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
              // Profile header
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildProfileHeader(),
              )),
              // About
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: _buildAboutSection(),
              )),
              // Contact
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildContactSection(),
              )),
              // Portfolio
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: _buildPortfolioSection(),
              )),
              // Reviews
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: _buildReviewsSection(),
              )),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildAppBar(),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
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
                    Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset('assets/images/vendor_biz_profile.png', fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(child: Text('RD', style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
                              ))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Business Profile', style: GoogleFonts.plusJakartaSans(
                          fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233), letterSpacing: -0.5,
                        )),
                      ],
                    ),
                    const Icon(Icons.settings_outlined, size: 20, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Logo with verified badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 112, height: 112,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E3E0),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset('assets/images/royal_logo.png', fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(child: Text('RD', style: GoogleFonts.plusJakartaSans(
                    fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary,
                  ))),
                ),
              ),
            ),
            Positioned(
              bottom: -8, right: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E5F3E),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 4), spreadRadius: -2)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('VERIFIED', style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Name
        Text('Royal Decorators', style: GoogleFonts.plusJakartaSans(
          fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF323233), letterSpacing: -0.75,
        )),
        const SizedBox(height: 8),
        // Location + Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text('Dubai, UAE', style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
            )),
            const SizedBox(width: 16),
            const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF5C518)),
            const SizedBox(width: 4),
            Text('4.9/5', style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
            )),
            const SizedBox(width: 4),
            Text('(120 reviews)', style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
            )),
          ],
        ),
        const SizedBox(height: 16),
        // Buttons
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
              const SizedBox(width: 8),
              Text('Edit Profile', style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.share_rounded, size: 14, color: Color(0xFF323233)),
              const SizedBox(width: 8),
              Text('Share Profile', style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About the Business', style: GoogleFonts.plusJakartaSans(
          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary,
        )),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
          ),
          child: Text(
            'Royal Decorators provides premium event styling and bespoke floral services for high-profile weddings and corporate gala events across the UAE. We specialize in transforming ordinary spaces into extraordinary experiences with architectural precision and artistic flair.',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.625),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Info', style: GoogleFonts.plusJakartaSans(
          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary,
        )),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
          ),
          child: Column(
            children: [
              _buildContactRow(Icons.email_outlined, 'EMAIL', 'contact@royaldecor.ae'),
              const SizedBox(height: 16),
              _buildContactRow(Icons.phone_outlined, 'PHONE', '+971 50 123 4567'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Column(
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
      ],
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Portfolio', style: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
            )),
            Row(
              children: [
                Text('View All', style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                )),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Large image
        ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: SizedBox(
            height: 342, width: double.infinity,
            child: Image.asset('assets/images/portfolio_1.png', fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Two smaller images
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: SizedBox(
                  height: 163,
                  child: Image.asset('assets/images/portfolio_2.png', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: SizedBox(
                  height: 163,
                  child: Image.asset('assets/images/portfolio_3.png', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Wide image
        ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: SizedBox(
            height: 192, width: double.infinity,
            child: Image.asset('assets/images/portfolio_4.png', fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Client Feedback', style: GoogleFonts.plusJakartaSans(
          fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
        )),
        const SizedBox(height: 24),
        _buildReviewCard(
          initials: 'SA', bgColor: AppColors.accent.withValues(alpha: 0.3),
          textColor: const Color(0xFF4E5F3E),
          name: 'Sarah Ahmed', time: '2 weeks ago', stars: 5,
          text: '"Absolutely breathtaking decor for our corporate gala. The attention to detail was beyond anything we expected. Highly recommended!"',
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          initials: 'JM', bgColor: AppColors.primaryLight.withValues(alpha: 0.3),
          textColor: AppColors.primary,
          name: 'John Miller', time: '1 month ago', stars: 4,
          text: '"Very professional team. They captured our wedding theme perfectly. We are so happy with the results."',
        ),
        const SizedBox(height: 24),
        // Read all button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(32),
          ),
          child: Center(child: Text('Read All 120 Reviews', style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
          ))),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String initials, required Color bgColor, required Color textColor,
    required String name, required String time, required int stars, required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                    child: Center(child: Text(initials, style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w700, color: textColor,
                    ))),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                      )),
                      Text(time, style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
                      )),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  Icons.star_rounded, size: 12,
                  color: i < stars ? const Color(0xFFF5C518) : const Color(0xFFE8E3E0),
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.43,
          )),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'HOME', 'active': false},
      {'icon': Icons.calendar_today_rounded, 'label': 'BOOKINGS', 'active': false},
      {'icon': Icons.design_services_rounded, 'label': 'SERVICES', 'active': false},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'CHAT', 'active': false},
      {'icon': Icons.person_rounded, 'label': 'PROFILE', 'active': true},
    ];

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(48), topRight: Radius.circular(48)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(48), topRight: Radius.circular(48)),
              boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, -8))],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                child: Row(
                  children: items.map((item) {
                    final isActive = item['active'] as bool;
                    final color = isActive ? AppColors.primary : const Color(0xFFA1A1AA);
                    return Expanded(child: Center(child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: isActive ? BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(9999),
                      ) : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item['icon'] as IconData, size: 20, color: color),
                          const SizedBox(height: 4),
                          Text(item['label'] as String, style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.55,
                          )),
                        ],
                      ),
                    )));
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
