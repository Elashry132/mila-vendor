import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class VendorNotificationsScreen extends StatelessWidget {
  const VendorNotificationsScreen({super.key});

  static const _notifications = [
    {
      'title': 'New Booking Request',
      'desc': 'Sarah Jenkins requested "Premium Stage Decoration" for Oct 24.',
      'time': '2 minutes ago',
      'icon': Icons.calendar_today_rounded,
      'iconBg': AppColors.accent,
      'iconColor': Color(0xFF4E5F3E),
      'unread': true,
    },
    {
      'title': 'Payment Received',
      'desc': 'You received \$2,450.00 for "Modern Penthouse Project".',
      'time': '1 hour ago',
      'icon': Icons.payments_outlined,
      'iconBg': AppColors.primaryLight,
      'iconColor': AppColors.primaryDark,
      'unread': true,
    },
    {
      'title': 'New Review',
      'desc': 'Michael Rossi left a 4-star review on "Corporate Keynote Setup".',
      'time': '3 hours ago',
      'icon': Icons.star_rounded,
      'iconBg': Color(0xFFFFF3CD),
      'iconColor': Color(0xFFB8860B),
      'unread': false,
    },
    {
      'title': 'Message from Elena',
      'desc': '"Can we add two more chairs to the outdoor setup?"',
      'time': 'Yesterday',
      'icon': Icons.chat_bubble_outline_rounded,
      'iconBg': Color(0xFFE8E3E0),
      'iconColor': AppColors.textSecondary,
      'unread': false,
    },
    {
      'title': 'Booking Completed',
      'desc': 'Your booking with Liam Watson has been marked as complete.',
      'time': '2 days ago',
      'icon': Icons.check_circle_outline_rounded,
      'iconBg': AppColors.accent,
      'iconColor': Color(0xFF4E5F3E),
      'unread': false,
    },
    {
      'title': 'Profile View Milestone',
      'desc': 'Your profile has been viewed 500+ times this month!',
      'time': '3 days ago',
      'icon': Icons.trending_up_rounded,
      'iconBg': Color(0xFFF5F0EE),
      'iconColor': AppColors.primary,
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildNotificationCard(_notifications[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipRect(
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
                    Text('Notifications', style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF323233), letterSpacing: -0.45,
                    )),
                  ]),
                  Text('Mark all read', style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    final isUnread = n['unread'] as bool;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : const Color(0xFFF5F0EE),
        borderRadius: BorderRadius.circular(48),
        boxShadow: isUnread ? [
          BoxShadow(color: const Color(0xFF1C1B1B).withValues(alpha: 0.04), blurRadius: 24, offset: const Offset(0, 12)),
        ] : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: n['iconBg'] as Color, shape: BoxShape.circle,
            ),
            child: Icon(n['icon'] as IconData, size: 20, color: n['iconColor'] as Color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(n['title'] as String, style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                      color: const Color(0xFF323233),
                    ))),
                    if (isUnread)
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 6)],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(n['desc'] as String, style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary, height: 1.4,
                ), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(n['time'] as String, style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: isUnread ? AppColors.primary : AppColors.textTertiary,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
