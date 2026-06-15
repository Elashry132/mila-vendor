import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/services/api_service.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  bool _isLoading = true;
  String _totalBookings = '--';
  String _totalBookingsSubtitle = '';
  String _todayBookings = '--';
  String _todayBookingsSubtitle = '';
  String _monthlyRevenue = '--';
  String _revenueSubtitle = '';

  @override
  void initState() {
    super.initState();
    _fetchEarnings();
  }

  Future<void> _fetchEarnings() async {
    final response = await ApiService.get('vendor/earnings');
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (response['status'] != false) {
        final data = response['data'] ?? response;
        _totalBookings = '${data['total_bookings'] ?? 0}';
        _totalBookingsSubtitle = data['bookings_subtitle'] ?? '+12% from last month';
        _todayBookings = '${data['today_bookings'] ?? 0}';
        _todayBookingsSubtitle = data['today_subtitle'] ?? 'No bookings today';
        _monthlyRevenue = '\$${data['monthly_revenue'] ?? 0}';
        _revenueSubtitle = data['revenue_subtitle'] ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
              // Quick stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isLoading ? _buildLoadingStats() : _buildQuickStats(),
                ),
              ),
              // Revenue chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  child: _buildRevenueChart(),
                ),
              ),
              // Activity log
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: _buildActivityLog(),
                ),
              ),
              // Quick actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  child: _buildQuickActions(),
                ),
              ),
              // Vendor tip
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: _buildVendorTip(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 130)),
            ],
          ),
          _buildHeader(),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildLoadingStats() {
    return Column(
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0EE),
            borderRadius: BorderRadius.circular(48),
          ),
          child: const Center(
            child: SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildHeader() {
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
                        // Vendor avatar
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/images/vendor_profile.png', fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text('RD', style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                                )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Royal Decorators', style: GoogleFonts.plusJakartaSans(
                          fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF18181B),
                          letterSpacing: -0.45,
                        )),
                      ],
                    ),
                    // Notification bell with dot
                    Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.primary),
                        ),
                        Positioned(
                          right: 8, top: 8,
                          child: Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFBA1A1A),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      children: [
        // Total Bookings
        _buildStatCard(
          label: 'Total Bookings',
          labelColor: AppColors.primary,
          value: _totalBookings,
          subtitle: _totalBookingsSubtitle.isNotEmpty ? _totalBookingsSubtitle : '+12% from last month',
          bgColor: const Color(0xFFF5F0EE),
        ),
        const SizedBox(height: 16),
        // Today's Bookings
        _buildStatCard(
          label: "Today's Bookings",
          labelColor: const Color(0xFF4E5F3E),
          value: _todayBookings,
          subtitle: _todayBookingsSubtitle.isNotEmpty ? _todayBookingsSubtitle : 'Next booking in 2 hours',
          bgColor: Colors.white,
          hasShadow: true,
        ),
        const SizedBox(height: 16),
        // Monthly Revenue (gradient)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.splashGradient,
            borderRadius: BorderRadius.circular(48),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: 0.8,
                child: Text('Monthly Revenue', style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary,
                )),
              ),
              const SizedBox(height: 24),
              Text(_monthlyRevenue, style: GoogleFonts.plusJakartaSans(
                fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFF323233),
              )),
              const SizedBox(height: 4),
              Opacity(
                opacity: 0.7,
                child: Text(
                  _revenueSubtitle.isNotEmpty ? _revenueSubtitle : 'Payout on Oct 1st',
                  style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required Color labelColor,
    required String value,
    required String subtitle,
    required Color bgColor,
    bool hasShadow = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(48),
        boxShadow: hasShadow ? [
          BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 12)),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: labelColor,
          )),
          const SizedBox(height: 24),
          Text(value, style: GoogleFonts.plusJakartaSans(
            fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFF323233),
          )),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
          )),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    final bars = [0.44, 0.66, 0.49, 0.93, 0.60, 0.77, 0.55];
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final highlightIndex = 3; // Thursday

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revenue Trend', style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Last 7 Days', style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
                )),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Chart bars
          SizedBox(
            height: 176,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      height: 176 * bars[i],
                      decoration: BoxDecoration(
                        color: i == highlightIndex
                            ? AppColors.primary
                            : const Color(0xFFE8E3E0),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // Day labels
          Row(
            children: days.map((d) => Expanded(
              child: Text(d, textAlign: TextAlign.center, style: GoogleFonts.inter(
                fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textTertiary,
                letterSpacing: -0.5,
              )),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLog() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activity Log', style: GoogleFonts.plusJakartaSans(
            fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
          )),
          const SizedBox(height: 16),
          // Booking alert
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 12, offset: Offset(0, 4))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF4E5F3E)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Booking Alert', style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
                      )),
                      Text('John Doe booked "Full Room Decor" for Saturday, 10 AM.',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.33),
                      ),
                      const SizedBox(height: 8),
                      Text('2 MINUTES AGO', style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary,
                      )),
                    ],
                  ),
                ),
                Text('REVIEW', style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.6,
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Message notification
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8E3E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Message from Sarah', style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
                      )),
                      Text('"Is the gold theme available for my wedding date?"',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, height: 1.33),
                      ),
                      const SizedBox(height: 8),
                      Text('1 HOUR AGO', style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: GoogleFonts.plusJakartaSans(
            fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
          )),
          const SizedBox(height: 24),
          // Add Service button (gradient)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Service', style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
                )),
                const SizedBox(width: 8),
                const Icon(Icons.add_circle_outline_rounded, size: 20, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Manage Orders button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFE8E3E0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Manage Orders', style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
                )),
                const SizedBox(width: 8),
                const Icon(Icons.list_alt_rounded, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorTip() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vendor Tip', style: GoogleFonts.plusJakartaSans(
            fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a portfolio photo to increase your conversion rate by up to 25%.',
                  style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary, height: 1.43,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Upload Now', style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary,
                  decoration: TextDecoration.underline,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'HOME', 'active': true},
      {'icon': Icons.calendar_today_rounded, 'label': 'BOOKINGS', 'active': false},
      {'icon': Icons.design_services_rounded, 'label': 'SERVICES', 'active': false},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'CHAT', 'active': false},
      {'icon': Icons.person_outline_rounded, 'label': 'PROFILE', 'active': false},
    ];

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(48),
                topRight: Radius.circular(48),
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, -8)),
              ],
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: isActive ? BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(9999),
                      ) : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item['icon'] as IconData, size: 20, color: color),
                          const SizedBox(height: 4),
                          Text(
                            item['label'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 11, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.55,
                            ),
                          ),
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
