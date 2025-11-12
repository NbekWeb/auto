import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../colors.dart';
import 'card_input_page.dart';

class MasterSetupPage extends StatefulWidget {
  const MasterSetupPage({super.key});

  @override
  State<MasterSetupPage> createState() => _MasterSetupPageState();
}

class _MasterSetupPageState extends State<MasterSetupPage> {
  String? _selectedCity;
  final List<String> _selectedServices = [];
  final TextEditingController _cityController = TextEditingController();

  final List<Map<String, dynamic>> _cities = [
    {'id': 'moscow', 'name': 'Москва'},
    {'id': 'spb', 'name': 'Санкт-Петербург'},
    {'id': 'kazan', 'name': 'Казань'},
    {'id': 'ekaterinburg', 'name': 'Екатеринбург'},
    {'id': 'novosibirsk', 'name': 'Новосибирск'},
    {'id': 'other', 'name': 'Другой город'},
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'id': 'electronics',
      'name': 'Диагностика электроники',
      'icon': 'dio',
      'isSvg': true,
    },
    {
      'id': 'service',
      'name': 'Сервис и ТО',
      'icon': 'service',
      'isSvg': true,
    },
    {
      'id': 'tire',
      'name': 'Шиномонтаж',
      'icon': 'shino',
      'isSvg': true,
    },
    {
      'id': 'towing',
      'name': 'Буксировка',
      'icon': 'buka',
      'isSvg': true,
    },
    {
      'id': 'wash',
      'name': 'Автомойка',
      'icon': 'moyka',
      'isSvg': true,
    },
    {
      'id': 'roadside',
      'name': 'Помощь на дороге',
      'icon': 'help',
      'isSvg': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (!mounted) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
              children: [
                const SizedBox(height: 20),

                // Header title
                Center(
                  child: Text(
                    'Данные мастера',
                    style: TextStyle(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Main title
                Center(
                  child: Text(
                    'Укажите город и услуги',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  'Это поможет вам получать подходящие заказы в нужном городе',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 40),

                // City section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ваше местоположенcsa ие',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // City selection field
                GestureDetector(
                  onTap: _showCityModal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4F5B63),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedCity != null 
                                  ? _cities.firstWhere((city) => city['id'] == _selectedCity)['name']
                                  : 'Укажите город',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedCity != null 
                                    ? (isDark ? AppColors.darkText : AppColors.lightText)
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Services section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Какие сервисы вы предоставляете?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Services grid
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: MediaQuery.of(context).size.width < 400 ? 1.4 : 1.2,
                    ),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      final isSelected = _selectedServices.contains(service['id']);

                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              if (isSelected) {
                                _selectedServices.remove(service['id']);
                              } else {
                                _selectedServices.add(service['id']);
                              }
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF8635)
                                : const Color(0xFF252F37),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFF8635)
                                  : Colors.transparent,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                offset: const Offset(6, 6),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.04),
                                offset: const Offset(-6, -6),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: SvgPicture.asset(
                                  'assets/icons/${service['icon']}.svg',
                                  width: 36,
                                  height: 36,
                                  colorFilter: service['icon'] == 'help'
                                      ? ColorFilter.mode(
                                          isSelected
                                              ? const Color(0xFFF4F4F4)
                                              : const Color(0xFFF74242), // Red color for help icon
                                          BlendMode.srcIn,
                                        )
                                      : ColorFilter.mode(
                                          isSelected
                                              ? const Color(0xFFF4F4F4)
                                              : const Color(0xFFFF771C),
                                          BlendMode.srcIn,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Flexible(
                                child: Text(
                                  service['name'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width < 400 ? 10 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFF4F4F4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Next button
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: _isFormComplete()
                        ? const LinearGradient(
                            colors: [Color(0xFFF67824), Color(0xFFF6A523)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _isFormComplete()
                        ? null
                        : (isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _isFormComplete()
                        ? [
                            BoxShadow(
                              color: const Color(0xFFF68324).withOpacity(0.2),
                              offset: const Offset(0, 0),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: const Color(0xFF6F6F6F).withOpacity(0.24),
                              offset: const Offset(0, 0),
                              blurRadius: 24,
                              spreadRadius: 0,
                            ),
                          ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _isFormComplete() ? _handleNext : null,
                      child: Center(
                        child: Text(
                          'Далее',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isFormComplete()
                                ? Colors.white
                                : (isDark ? const Color(0xFF818B93) : AppColors.lightTextSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Fill later option
                GestureDetector(
                  onTap: _handleFillLater,
                  child: Text(
                    'Заполнить данные позже',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF9FA7AD),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                      height: 1.3,
                      letterSpacing: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  bool _isFormComplete() {
    return _selectedCity != null && _selectedServices.isNotEmpty;
  }

  void _handleNext() {
    if (_isFormComplete()) {
      print('Master setup completed');
      print('City: $_selectedCity');
      print('Services: $_selectedServices');
      // Navigate to card input page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CardInputPage(),
        ),
      );
    }
  }

  void _handleFillLater() {
    print('User chose to fill data later');
    // Navigate to next page without master setup
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextPage()));
  }

  void _showCityModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Выберите город',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ),
            
            // City list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  final city = _cities[index];
                  final isSelected = _selectedCity == city['id'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCity = city['id'];
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFFFF8635) 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFFFF8635) 
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              city['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected 
                                    ? Colors.white 
                                    : (isDark ? AppColors.darkText : AppColors.lightText),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
