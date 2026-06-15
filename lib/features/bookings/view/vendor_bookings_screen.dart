import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/services/api_service.dart';

class VendorBookingsScreen extends StatefulWidget {
  const VendorBookingsScreen({super.key});

  @override
  State<VendorBookingsScreen> createState() => _VendorBookingsScreenState();
}

class _VendorBookingsScreenState extends State<VendorBookingsScreen> {
  int _selectedFilter = 0;
  final _filters = ['All Bookings', 'Pending', 'Accepted', 'Completed'];

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final response = await ApiService.get('vendor/bookings');
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (response['status'] == false) {
        _errorMessage = response['message'] ?? 'Failed to load bookings';
      } else {
        final data = response['data'] ?? response['bookings'] ?? [];
        _bookings = List<Map<String, dynamic>>.from(data is List ? data : []);
      }
    });
  }

  Future<void> _updateBookingStatus(int bookingId, String status) async {
    final response = await ApiService.patch('vendor/bookings/$bookingId', {'status': status});
    if (!mounted) return;
    if (response['status'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to update booking')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking ${status == 'accepted' ? 'accepted' : 'rejected'} successfully')),
      );
      _fetchBookings();
    }
  }

  List<Map<String, dynamic>> get _filteredBookings {
    if (_selectedFilter == 0) return _bookings;
    final statusFilter = _filters[_selectedFilter].toLowerCase();
    return _bookings.where((b) {
      final s = (b['status'] ?? '').toString().toLowerCase();
      return s == statusFilter;
    }).toList();
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
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSearchBar(),
                ),
              ),
              // Filter chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, left: 24),
                  child: _buildFilterChips(),
                ),
              ),
              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: _buildSectionHeader(),
                ),
              ),
              // Content
              if (_isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64),
                    child: Center(
                      child: SizedBox(
                        width: 32, height: 32,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      ),
                    ),
                  ),
                )
              else if (_errorMessage != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textTertiary),
                        const SizedBox(height: 16),
                        Text(_errorMessage!, textAlign: TextAlign.center, style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.textSecondary,
                        )),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _fetchBookings,
                          child: Text('Tap to retry', style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                          )),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_filteredBookings.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 48, color: AppColors.textTertiary),
                        const SizedBox(height: 16),
                        Text('No bookings found', style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
                        )),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final booking = _filteredBookings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildBookingCard(booking),
                        );
                      },
                      childCount: _filteredBookings.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),
          _buildHeader(),
          // FAB
          Positioned(
            bottom: 120, right: 24,
            child: Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(-1, -1), end: Alignment(1, 1),
                  colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 25, offset: const Offset(0, 20), spreadRadius: -5),
                ],
              ),
              child: const Icon(Icons.add_rounded, size: 24, color: Colors.white),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = (booking['status'] ?? 'pending').toString().toLowerCase();
    final name = booking['customer_name'] ?? booking['user']?['name'] ?? 'Customer';
    final service = booking['service_name'] ?? booking['service']?['name'] ?? 'Service';
    final date = booking['scheduled_at'] ?? booking['date'] ?? '';
    final id = booking['id'];
    final initials = name.toString().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

    if (status == 'pending') {
      return _buildPendingCard(
        id: id,
        initials: initials,
        bgColor: AppColors.primaryLight,
        textColor: AppColors.primaryDark,
        name: name.toString(),
        subtitle: booking['customer_type'] ?? 'Customer',
        service: service.toString(),
        date: date.toString(),
      );
    } else if (status == 'accepted') {
      return _buildAcceptedCardFromData(booking, name.toString(), service.toString(), date.toString());
    } else {
      return _buildCompletedCardFromData(booking, name.toString(), initials, service.toString(), date.toString());
    }
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
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/images/vendor_exec.png', fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text('EA', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                              ),
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

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE9E8E7),
        borderRadius: BorderRadius.circular(48),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search_rounded, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Search bookings, customers, or services...', style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textTertiary,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)])
                    : null,
                color: isSelected ? null : const Color(0xFFF5F0EE),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: isSelected ? [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 4), spreadRadius: -2),
                ] : null,
              ),
              child: Text(
                _filters[index],
                style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('QUEUE MANAGEMENT', style: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.2,
        )),
        const SizedBox(height: 4),
        Text('Active Requests', style: GoogleFonts.plusJakartaSans(
          fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF323233), letterSpacing: -0.75,
        )),
      ],
    );
  }

  Widget _buildPendingCard({
    required int? id,
    required String initials, required Color bgColor, required Color textColor,
    required String name, required String subtitle,
    required String service, required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                    child: Center(child: Text(initials, style: GoogleFonts.inter(
                      fontSize: 18, fontWeight: FontWeight.w700, color: textColor,
                    ))),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.plusJakartaSans(
                        fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                      )),
                      Text(subtitle, style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textTertiary,
                      )),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text('PENDING', style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryDark,
                  letterSpacing: 0.55,
                )),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Service info
          Row(
            children: [
              Icon(Icons.local_florist_rounded, size: 17, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(child: Text(service, style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF323233),
              ))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(date, style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
              )),
            ],
          ),
          const SizedBox(height: 32),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: id != null ? () => _updateBookingStatus(id, 'accepted') : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))],
                    ),
                    child: Center(child: Text('Accept Request', style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
                    ))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: id != null ? () => _updateBookingStatus(id, 'rejected') : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: const Color(0xFFBA1A1A).withValues(alpha: 0.2), width: 2),
                  ),
                  child: Text('Reject', style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFBA1A1A),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedCardFromData(Map<String, dynamic> booking, String name, String service, String date) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(name, style: GoogleFonts.plusJakartaSans(
                            fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                          )),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text('ACCEPTED', style: GoogleFonts.inter(
                            fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF4E5F3E), letterSpacing: 1,
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(service, style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
                    )),
                    Text('Scheduled for $date', style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.divider.withValues(alpha: 0.2)),
                  boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
                ),
                child: Text('View Details', style: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCardFromData(Map<String, dynamic> booking, String name, String initials, String service, String date) {
    return Opacity(
      opacity: 0.75,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0EE).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(48),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.1)),
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4E4E7), shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(initials, style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF52525B),
                      ))),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                        )),
                        Text(date, style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
                        )),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4E4E7),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text('COMPLETED', style: GoogleFonts.inter(
                    fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF52525B), letterSpacing: 1,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(service, style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
            )),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
              ),
              child: Center(child: Text('RE-OPEN TICKET', style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 1.2,
              ))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'HOME', 'active': false},
      {'icon': Icons.calendar_today_rounded, 'label': 'BOOKINGS', 'active': true},
      {'icon': Icons.design_services_rounded, 'label': 'SERVICES', 'active': false},
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
