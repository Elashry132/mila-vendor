import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mila_vendor/core/theme/app_colors.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _titleController = TextEditingController(text: 'Premium Stage Decoration');
  final _priceController = TextEditingController(text: '500');
  final _descController = TextEditingController(
    text: 'Transform your venue into a dreamscape with our Premium Stage Decoration package. Includes high-end floral arrangements, custom backdrops, ambient LED lighting, and bespoke furniture placement. Our team handles complete setup and teardown.',
  );
  int _selectedCategory = 0;
  bool _isAvailable = true;
  final _categories = ['Decoration', 'Catering', 'Photography', 'Lighting'];
  final _images = ['assets/images/edit_svc_1.png', 'assets/images/edit_svc_2.png', 'assets/images/edit_svc_3.png'];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

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
                _buildGallery(),
                const SizedBox(height: 32),
                _buildTextField('SERVICE TITLE', _titleController),
                const SizedBox(height: 24),
                _buildCategoryPicker(),
                const SizedBox(height: 24),
                _buildPricingCard(),
                const SizedBox(height: 24),
                _buildDescriptionField(),
                const SizedBox(height: 24),
                _buildAvailabilityToggle(),
                const SizedBox(height: 32),
                _buildDeleteButton(),
              ],
            ),
          ),
          _buildHeader(),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
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
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Text('Edit Service', style: GoogleFonts.plusJakartaSans(
                          fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF323233), letterSpacing: -0.45,
                        )),
                      ],
                    ),
                    Text('Save', style: GoogleFonts.plusJakartaSans(
                      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary, letterSpacing: -0.45,
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GALLERY', style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.4,
              )),
              Text('3 / 10 Images', style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiary,
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add photo placeholder
              Container(
                width: 128, height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E3E0),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.divider, width: 2, style: BorderStyle.none),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: 28, color: AppColors.textSecondary),
                    const SizedBox(height: 8),
                    Text('ADD PHOTO', style: GoogleFonts.inter(
                      fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: -0.5,
                    )),
                  ],
                ),
              ),
              ..._images.map((img) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: SizedBox(
                    width: 128, height: 160,
                    child: Image.asset(img, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(label, style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
          )),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(32),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF323233)),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text('CATEGORY', style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
          )),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: List.generate(_categories.length, (i) {
            final isSelected = _selectedCategory == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : const Color(0xFFF5F0EE),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: isSelected ? [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 4), spreadRadius: -2),
                  ] : null,
                ),
                child: Text(_categories[i], style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                )),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 22, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('PRICING STRUCTURE', style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 1.4,
              )),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text('BASE PRICE', style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1,
                      )),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text('\$', style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textSecondary,
                            )),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                border: InputBorder.none,
                              ),
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF323233)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text('UNIT', style: GoogleFonts.inter(
                        fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1,
                      )),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('per event', style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF323233),
                          )),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text('DETAILED DESCRIPTION', style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2,
          )),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3E0), borderRadius: BorderRadius.circular(32),
          ),
          child: TextField(
            controller: _descController,
            maxLines: 6,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF323233), height: 1.625),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0EE), borderRadius: BorderRadius.circular(48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.accent, shape: BoxShape.circle,
                ),
                child: const Icon(Icons.visibility_rounded, size: 22, color: Color(0xFF4E5F3E)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service Availability', style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF323233),
                  )),
                  Text('Visible to potential clients', style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
                  )),
                ],
              ),
            ],
          ),
          Switch.adaptive(
            value: _isAvailable,
            onChanged: (v) => setState(() => _isAvailable = v),
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF4E5F3E),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFBA1A1A).withValues(alpha: 0.1), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.delete_outline_rounded, size: 15, color: Color(0xFFBA1A1A)),
          const SizedBox(width: 8),
          Text('Delete Service', style: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFFBA1A1A),
          )),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 32, left: 16, right: 16,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7B5556), Color(0xFF6E4A4A)]),
            borderRadius: BorderRadius.circular(48),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, 12)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
              const SizedBox(width: 12),
              Text('Save Changes', style: GoogleFonts.plusJakartaSans(
                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
