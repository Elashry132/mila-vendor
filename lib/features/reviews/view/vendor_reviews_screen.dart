import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorReviewsScreen extends StatelessWidget {
  const VendorReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSummary(),
              )),
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _buildBreakdown(),
              )),
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                child: _buildFilterRow(),
              )),
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                child: _buildReviewCards(),
              )),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildHeader(context),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: AppColors.background.withValues(alpha: 0.8),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Text('Reviews', style: GoogleFonts.plusJakartaSans(
                          fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF323233), letterSpacing: -0.45,
                        )),
                      ]),
                      const Icon(Icons.more_vert_rounded, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        children: [
          Text('AVERAGE RATING', style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 1,
          )),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('4.9', style: GoogleFonts.plusJakartaSans(
                fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.primary,
              )),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('/ 5', style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
                )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (_) => const Icon(Icons.star_rounded, size: 20, color: Color(0xFFF5C518))),
          ),
          const SizedBox(height: 8),
          Text('Based on 120 reviews', style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
          )),
        ],
      ),
    );
  }

  Widget _buildBreakdown() {
    final data = [
      {'stars': 5, 'count': 102, 'fill': 0.85},
      {'stars': 4, 'count': 14, 'fill': 0.12},
      {'stars': 3, 'count': 4, 'fill': 0.03},
      {'stars': 2, 'count': 0, 'fill': 0.0},
      {'stars': 1, 'count': 0, 'fill': 0.0},
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        children: data.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(width: 16, child: Text('${d['stars']}', style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
              ))),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(9999),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (d['fill'] as double),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary, borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(width: 32, child: Text('${d['count']}', textAlign: TextAlign.right, style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
              ))),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Recent Feedback', style: GoogleFonts.plusJakartaSans(
          fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text('Most Recent', style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
              )),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCards() {
    return Column(
      children: [
        _buildReviewCard(
          image: 'assets/images/reviewer_sarah.png', name: 'Sarah Jenkins', date: 'May 12, 2024', stars: 5,
          text: 'The stage setup was absolutely magical. Every detail was handled with such professionalism. The lighting transitioned perfectly during the reception. Highly recommend for any high-end wedding!',
          reply: 'Thank you so much Sarah! It was an absolute pleasure working on your special day. We\'re thrilled you loved the lighting!',
        ),
        const SizedBox(height: 24),
        _buildReviewCard(
          image: 'assets/images/reviewer_michael.png', name: 'Michael Rossi', date: 'April 28, 2024', stars: 4,
          text: 'Great experience overall. The audio quality for the corporate keynote was crystal clear. Just a slight delay in the initial load-in, but the team recovered quickly and professionally.',
          reply: 'Thanks Michael. We appreciate the feedback on the load-in; we\'ve already adjusted our logistics buffer for the Convention Center to ensure we\'re always ahead of schedule.',
        ),
        const SizedBox(height: 24),
        _buildReviewCard(
          image: 'assets/images/reviewer_elena.png', name: 'Elena Rodriguez', date: 'April 15, 2024', stars: 5,
          text: 'Exceeded expectations. The floral arrangements were fresh and vibrant for the entire 3-day exhibition. Not a single petal out of place!',
          hasWriteReply: true,
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String image, required String name, required String date, required int stars,
    required String text, String? reply, bool hasWriteReply = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(48),
        boxShadow: [BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), spreadRadius: 2)],
                  ),
                  child: ClipOval(child: Image.asset(image, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                  )),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                  )),
                  Text(date, style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
                  )),
                ]),
              ]),
              Row(children: List.generate(5, (i) => Icon(
                Icons.star_rounded, size: 12,
                color: i < stars ? const Color(0xFFF5C518) : const Color(0xFFE8E3E0),
              ))),
            ],
          ),
          const SizedBox(height: 16),
          // Review text
          Text(text, style: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.625,
          )),
          // Reply or write reply
          if (reply != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0EE),
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: AppColors.primary.withValues(alpha: 0.2), width: 4)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.reply_rounded, size: 9, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('YOUR REPLY', style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.6,
                  )),
                ]),
                const SizedBox(height: 4),
                Text(reply, style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.43,
                )),
              ]),
            ),
          ],
          if (hasWriteReply) ...[
            const SizedBox(height: 16),
            Row(children: [
              Icon(Icons.edit_rounded, size: 12, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('WRITE A REPLY', style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.2,
              )),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'DASHBOARD', 'active': false},
      {'icon': Icons.receipt_long_rounded, 'label': 'ORDERS', 'active': false},
      {'icon': Icons.star_rounded, 'label': 'REVIEWS', 'active': true},
      {'icon': Icons.person_outline_rounded, 'label': 'PROFILE', 'active': false},
    ];
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: AppColors.background.withValues(alpha: 0.85),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: items.map((item) {
                    final isActive = item['active'] as bool;
                    final color = isActive ? Colors.white : AppColors.textSecondary;
                    return Expanded(child: Center(child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: isActive ? BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ) : null,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(item['icon'] as IconData, size: 20, color: color),
                        const SizedBox(height: 4),
                        Text(item['label'] as String, style: GoogleFonts.inter(
                          fontSize: 10, fontWeight: FontWeight.w500, color: color, letterSpacing: 0.5,
                        )),
                      ]),
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
