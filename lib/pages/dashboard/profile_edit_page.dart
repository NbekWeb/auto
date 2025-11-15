import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../colors.dart';
import '../../services/user_service.dart';
import '../../components/toast_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  Uint8List? _avatarBytes;
  String? _avatarUrl;
  bool _isLoading = false;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });

    final result = await UserService.getUserProfile();
    
    if (result['success'] == true && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;
      // API response structure: {success: true, user: {...}}
      final userData = data['user'] ?? data;
      
      setState(() {
        _firstNameController.text = userData['first_name']?.toString() ?? '';
        _lastNameController.text = userData['last_name']?.toString() ?? '';
        _addressController.text = userData['address']?.toString() ?? '';
        _phoneController.text = userData['phone_number']?.toString() ?? '';
        _avatarUrl = userData['avatar']?.toString();
        _isLoadingProfile = false;
      });
    } else {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _avatarBytes = bytes;
          _avatarUrl = null; // Clear URL when new image is selected
        });
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError(context, message: 'Ошибка при выборе изображения');
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_firstNameController.text.trim().isEmpty && 
        _lastNameController.text.trim().isEmpty) {
      ToastService.showError(context, message: 'Пожалуйста, укажите имя или фамилию');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await UserService.updateUserProfile(
      firstName: _firstNameController.text.trim().isNotEmpty 
          ? _firstNameController.text.trim() 
          : null,
      lastName: _lastNameController.text.trim().isNotEmpty 
          ? _lastNameController.text.trim() 
          : null,
      address: _addressController.text.trim().isNotEmpty 
          ? _addressController.text.trim() 
          : null,
      phoneNumber: _phoneController.text.trim().isNotEmpty 
          ? _phoneController.text.trim() 
          : null,
      avatarBytes: _avatarBytes,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      if (mounted) {
        ToastService.showSuccess(
          context,
          message: result['message'] ?? 'Профиль успешно обновлен',
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } else {
      if (mounted) {
        ToastService.showError(
          context,
          message: result['message'] ?? 'Не удалось обновить профиль',
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Редактирование профиля',
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Manrope',
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoadingProfile
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.orange,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Profile Picture
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark 
                                ? AppColors.cardDark 
                                : AppColors.cardLight,
                            image: _avatarBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(_avatarBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : _avatarUrl != null && _avatarUrl!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(_avatarUrl!),
                                        fit: BoxFit.cover,
                                        onError: (_, __) {},
                                      )
                                    : const DecorationImage(
                                        image: AssetImage('assets/images/user.png'),
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF771C),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // First Name Field
                  _buildTextField(
                    label: 'Имя',
                    controller: _firstNameController,
                    placeholder: 'Укажите имя',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  // Last Name Field
                  _buildTextField(
                    label: 'Фамилия',
                    controller: _lastNameController,
                    placeholder: 'Укажите фамилию',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  // Address Field
                  _buildTextField(
                    label: 'Местоположение',
                    controller: _addressController,
                    placeholder: 'Укажите город',
                    isDark: isDark,
                    hasDropdown: true,
                  ),
                  const SizedBox(height: 20),
                  // Phone Number Field
                  _buildTextField(
                    label: 'Номер телефона',
                    controller: _phoneController,
                    placeholder: '+9 999 999 99 99',
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        disabledBackgroundColor: AppColors.orange.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Сохранить',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Manrope',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isDark,
    bool hasDropdown = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: 'Manrope',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontFamily: 'Manrope',
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
              fontFamily: 'Manrope',
            ),
            filled: true,
            fillColor: isDark 
                ? AppColors.cardDark 
                : AppColors.cardLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: hasDropdown
                ? Icon(
                    Icons.arrow_drop_down,
                    color: isDark 
                        ? AppColors.darkTextSecondary 
                        : AppColors.lightTextSecondary,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

