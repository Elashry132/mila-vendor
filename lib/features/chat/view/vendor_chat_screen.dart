import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';
import 'package:mila_vendor/services/api_service.dart';

class VendorChatScreen extends StatefulWidget {
  const VendorChatScreen({super.key});

  @override
  State<VendorChatScreen> createState() => _VendorChatScreenState();
}

class _VendorChatScreenState extends State<VendorChatScreen> {
  int _selectedFilter = 0;
  final _filters = ['All Messages', 'Unread', 'Archived'];

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _chats = [];

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    final response = await ApiService.get('chats');
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (response['status'] == false) {
        _errorMessage = response['message'] ?? 'Failed to load chats';
      } else {
        final data = response['data'] ?? response['chats'] ?? [];
        _chats = List<Map<String, dynamic>>.from(data is List ? data : []);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: SizedBox(
                          width: 32, height: 32,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textTertiary),
                                  const SizedBox(height: 16),
                                  Text(_errorMessage!, textAlign: TextAlign.center, style: GoogleFonts.inter(
                                    fontSize: 14, color: AppColors.textSecondary,
                                  )),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: _fetchChats,
                                    child: Text('Tap to retry', style: GoogleFonts.inter(
                                      fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _chats.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textTertiary),
                                    const SizedBox(height: 16),
                                    Text('No conversations yet', style: GoogleFonts.inter(
                                      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
                                    )),
                                  ],
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
                                children: [
                                  _buildSearchBar(),
                                  const SizedBox(height: 32),
                                  _buildFilterChips(),
                                  const SizedBox(height: 32),
                                  ..._chats.map((c) => Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: _buildChatEntry(c),
                                  )),
                                ],
                              ),
              ),
            ],
          ),
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
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10), spreadRadius: -3),
                ],
              ),
              child: const Icon(Icons.edit_rounded, size: 20, color: Colors.white),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.8),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E3E0),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: ClipOval(
                          child: Image.asset('assets/images/vendor_chat_profile.png', fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Messages', style: GoogleFonts.plusJakartaSans(
                        fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF323233), letterSpacing: -0.45,
                      )),
                    ],
                  ),
                  const Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
                ],
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
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search_rounded, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Search conversations...', style: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: List.generate(_filters.length, (i) {
        final isSelected = _selectedFilter == i;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF5F0EE),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(_filters[i], style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              )),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChatEntry(Map<String, dynamic> chat) {
    final isUnread = chat['unread'] == true || chat['is_unread'] == true;
    final isOnline = chat['online'] == true || chat['is_online'] == true;
    final name = chat['name'] ?? chat['user']?['name'] ?? 'User';
    final message = chat['message'] ?? chat['last_message'] ?? '';
    final time = chat['time'] ?? chat['last_message_at'] ?? '';
    final image = chat['image'] ?? chat['avatar'] ?? chat['user']?['avatar'] ?? '';

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
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: isUnread ? 1.0 : 0.8,
                child: ClipOval(
                  child: SizedBox(
                    width: 56, height: 56,
                    child: image.toString().startsWith('http')
                        ? Image.network(image.toString(), fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant))
                        : Image.asset(
                            image.toString().isNotEmpty ? image.toString() : 'assets/images/chat_sarah.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                          ),
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4E5F3E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(name.toString(), style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                        color: isUnread ? const Color(0xFF323233) : AppColors.textSecondary,
                      )),
                    ),
                    Text(time.toString(), style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                      color: isUnread ? AppColors.primary : AppColors.textTertiary,
                      letterSpacing: 0.55,
                    )),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(message.toString(), style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                        color: isUnread ? const Color(0xFF323233) : AppColors.textSecondary,
                      ), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    if (isUnread)
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 8),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'HOME', 'active': false},
      {'icon': Icons.calendar_today_rounded, 'label': 'BOOKINGS', 'active': false},
      {'icon': Icons.design_services_rounded, 'label': 'SERVICES', 'active': false},
      {'icon': Icons.chat_bubble_rounded, 'label': 'CHAT', 'active': true},
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
              boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 24, offset: Offset(0, -12))],
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            fontSize: 10, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.5,
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
