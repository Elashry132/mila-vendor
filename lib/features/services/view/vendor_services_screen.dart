import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/services/api_service.dart';

class VendorServicesScreen extends StatefulWidget {
  const VendorServicesScreen({super.key});

  @override
  State<VendorServicesScreen> createState() => _VendorServicesScreenState();
}

class _VendorServicesScreenState extends State<VendorServicesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final response = await ApiService.get('vendor/services');
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (response['status'] == false) {
        _errorMessage = response['message'] ?? 'Failed to load services';
      } else {
        final data = response['data'] ?? response['services'] ?? [];
        _services = List<Map<String, dynamic>>.from(data is List ? data : []);
      }
    });
  }

  Future<void> _toggleServiceStatus(int serviceId, bool currentlyActive) async {
    final response = await ApiService.patch('vendor/services/$serviceId', {
      'is_active': !currentlyActive,
    });
    if (!mounted) return;
    if (response['status'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to update service')),
      );
    } else {
      _fetchServices();
    }
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
              // Header section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildHeaderSection(),
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
                          onTap: _fetchServices,
                          child: Text('Tap to retry', style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                          )),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Service cards
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _buildServiceCard(_services[index]),
                      ),
                      childCount: _services.length,
                    ),
                  ),
                ),
                // Performance card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: _buildPerformanceCard(),
                  ),
                ),
                // Strategy section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: _buildStrategySection(),
                  ),
                ),
              ],
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
                            color: AppColors.primary, shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset('assets/images/vendor_arch.png', fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(child: Text('EA', style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
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

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Services', style: GoogleFonts.plusJakartaSans(
              fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF323233), letterSpacing: -0.6,
            )),
            const SizedBox(height: 4),
            Text('Manage your active catalog and\nofferings.', style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.43,
            )),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.add_rounded, size: 14, color: Colors.white),
              const SizedBox(width: 8),
              Text('Add\nService', textAlign: TextAlign.center, style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, height: 1.43,
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final isActive = service['is_active'] == true || service['active'] == true;
    final name = service['name'] ?? 'Service';
    final price = service['price'] != null ? '\$${service['price']}' : (service['price_formatted'] ?? '');
    final unit = service['unit'] ?? service['price_unit'] ?? '/ event';
    final image = service['image'] ?? service['image_url'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: SizedBox(
              width: 128, height: 128,
              child: image.toString().startsWith('http')
                  ? Image.network(image.toString(), fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant))
                  : Image.asset(
                      image.toString().isNotEmpty ? image.toString() : 'assets/images/svc_stage.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                    ),
            ),
          ),
          const SizedBox(width: 20),
          // Info
          Expanded(
            child: SizedBox(
              height: 128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(name.toString(), style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF323233), height: 1.25,
                            )),
                          ),
                          Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 15, color: AppColors.textSecondary),
                              const SizedBox(width: 12),
                              Icon(Icons.delete_outline_rounded, size: 15, color: AppColors.textSecondary),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: price.toString(),
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          TextSpan(
                            text: ' $unit',
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  // Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isActive ? 'ACTIVE' : 'INACTIVE',
                        style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: isActive ? const Color(0xFF4E5F3E) : AppColors.textTertiary,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Switch.adaptive(
                        value: isActive,
                        onChanged: (val) {
                          final id = service['id'];
                          if (id != null) {
                            _toggleServiceStatus(id, isActive);
                          }
                        },
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF4E5F3E),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFE8E3E0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('assets/icons/chart_trend.svg', width: 36, height: 28),
              Text('MONTHLY PERFORMANCE', style: GoogleFonts.inter(
                fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 2,
              )),
            ],
          ),
          const SizedBox(height: 16),
          Text('Total Service Revenue', style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
          )),
          const SizedBox(height: 4),
          Text('\$14,250.00', style: GoogleFonts.plusJakartaSans(
            fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF323233),
          )),
          const SizedBox(height: 12),
          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(9999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary, borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('+12% from last month', style: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
          )),
        ],
      ),
    );
  }

  Widget _buildStrategySection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -72, right: -80,
            child: Container(
              width: 256, height: 256,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vendor Strategy', style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary,
              )),
              const SizedBox(height: 8),
              Text(
                'Your "Premium Stage Decoration" is currently your most viewed service but has a 15% lower conversion rate than average. Consider updating its gallery images.',
                style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.625,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildMetric('AVG. ORDER VALUE', '\$740'),
                  Container(width: 1, height: 40, color: AppColors.divider.withValues(alpha: 0.3), margin: const EdgeInsets.symmetric(horizontal: 16)),
                  _buildMetric('CLIENT RETENTION', '82%'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.6,
          child: Text(label, style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1,
          )),
        ),
        Text(value, style: GoogleFonts.plusJakartaSans(
          fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
        )),
      ],
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
