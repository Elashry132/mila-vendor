import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorEarningsScreen extends StatelessWidget {
  const VendorEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
              // Balance hero card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildBalanceCard(),
                ),
              ),
              // Revenue insights
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  child: _buildRevenueInsights(),
                ),
              ),
              // Transactions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  child: _buildTransactions(),
                ),
              ),
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
            color: AppColors.surface.withValues(alpha: 0.7),
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
                            color: const Color(0xFFE8E3E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/images/vendor_earnings.png', fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(child: Text('EA', style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                              ))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Executive Architect', style: GoogleFonts.plusJakartaSans(
                          fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF18181B), letterSpacing: -0.45,
                        )),
                      ],
                    ),
                    const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.8, -0.8), end: Alignment(0.8, 0.8),
          colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)],
        ),
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 32, offset: const Offset(0, 12)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -64, right: -64,
            child: Container(
              width: 256, height: 256,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                child: const SizedBox(),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AVAILABLE BALANCE', style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7), letterSpacing: 0.275,
              )),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(children: [
                  TextSpan(text: '\$14,820', style: GoogleFonts.plusJakartaSans(
                    fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white,
                  )),
                  TextSpan(text: '.50', style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white.withValues(alpha: 0.6),
                  )),
                ]),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('Withdraw', style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary,
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(Icons.add_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueInsights() {
    final bars = [
      {'h': 96.0, 'label': 'JAN', 'active': false},
      {'h': 128.0, 'label': 'FEB', 'active': false},
      {'h': 160.0, 'label': 'MAR', 'active': true},
      {'h': 112.0, 'label': 'APR', 'active': false},
      {'h': 144.0, 'label': 'MAY', 'active': false},
      {'h': 64.0, 'label': 'JUN', 'active': false},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Insights', style: GoogleFonts.plusJakartaSans(
                    fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                  )),
                  const SizedBox(height: 4),
                  Text('Monthly performance trend', style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
                  )),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('+12.4% vs LY', style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary,
                )),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Chart
          SizedBox(
            height: 192,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: bars.map((bar) {
                final isActive = bar['active'] as bool;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 32,
                      height: bar['h'] as double,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8), topRight: Radius.circular(8),
                        ),
                        boxShadow: isActive ? [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
                        ] : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bar['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions', style: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
            )),
            Text('View All', style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary,
            )),
          ],
        ),
        const SizedBox(height: 16),
        _buildTransactionItem(
          title: 'Modern Penthouse\nProject',
          subtitle: 'Oct 24, 2023 \u2022 Service Fee',
          amount: '+\$2,450',
          status: 'COMPLETED',
          statusColor: AppColors.accent,
          statusTextColor: const Color(0xFF4E5F3E),
          iconColor: AppColors.accent,
        ),
        const SizedBox(height: 12),
        _buildTransactionItem(
          title: 'Blueprint\nConsultation',
          subtitle: 'Oct 22, 2023 \u2022 Consultation',
          amount: '+\$420',
          status: 'PROCESSING',
          statusColor: AppColors.primaryLight,
          statusTextColor: AppColors.primaryDark,
          iconColor: AppColors.primaryLight.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 12),
        _buildTransactionItem(
          title: 'Industrial Hub Design',
          subtitle: 'Oct 20, 2023 \u2022 Milestone 2',
          amount: '+\$8,900',
          status: 'COMPLETED',
          statusColor: AppColors.accent,
          statusTextColor: const Color(0xFF4E5F3E),
          iconColor: AppColors.accent,
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String title, required String subtitle, required String amount,
    required String status, required Color statusColor, required Color statusTextColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    status == 'PROCESSING' ? Icons.architecture_rounded : Icons.check_rounded,
                    size: 16, color: statusTextColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF323233), height: 1.5,
                      )),
                      const SizedBox(height: 2),
                      Text(subtitle, style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: GoogleFonts.inter(
                fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(status, style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w700, color: statusTextColor, letterSpacing: 0.5,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'HOME', 'active': false},
      {'icon': Icons.calendar_today_rounded, 'label': 'BOOKINGS', 'active': false},
      {'icon': Icons.design_services_rounded, 'label': 'SERVICES', 'active': true},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'CHAT', 'active': false},
      {'icon': Icons.person_outline_rounded, 'label': 'PROFILE', 'active': false},
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
