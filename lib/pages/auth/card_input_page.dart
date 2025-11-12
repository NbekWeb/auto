import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';
import '../../components/toast_service.dart';

class CardInputPage extends StatefulWidget {
  const CardInputPage({super.key});

  @override
  State<CardInputPage> createState() => _CardInputPageState();
}

class _CardInputPageState extends State<CardInputPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final FocusNode _cardNumberFocus = FocusNode();
  final FocusNode _expiryFocus = FocusNode();
  final FocusNode _cvvFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_onCardNumberChanged);
    _expiryController.addListener(_onExpiryChanged);
    _cvvController.addListener(_onCvvChanged);
  }

  void _formatCardNumber() {
    String text = _cardNumberController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.length > 16) {
      text = text.substring(0, 16);
    }
    
    String formatted = '';
    for (int i = 0; i < text.length; i += 4) {
      if (i + 4 <= text.length) {
        formatted += text.substring(i, i + 4) + ' ';
      } else {
        formatted += text.substring(i);
      }
    }
    
    if (formatted.endsWith(' ')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    
    if (_cardNumberController.text != formatted) {
      _cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _formatExpiry() {
    String currentText = _expiryController.text;
    String digitsOnly = currentText.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }
    
    String formatted = '';
    // Only add slash when we have 3 or more digits
    if (digitsOnly.length >= 3) {
      formatted = digitsOnly.substring(0, 2) + '/' + digitsOnly.substring(2);
    } else {
      formatted = digitsOnly;
    }
    
    if (currentText != formatted) {
      _expiryController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _onCardNumberChanged() {
    _formatCardNumber();
    setState(() {});
  }

  void _onExpiryChanged() {
    _formatExpiry();
    setState(() {});
  }

  void _onCvvChanged() {
    setState(() {});
  }


  bool _isFormComplete() {
    String cardNumber = _cardNumberController.text.replaceAll(' ', '');
    String expiry = _expiryController.text;
    String cvv = _cvvController.text;
    
    
    
    bool cardValid = cardNumber.length == 16;
    bool expiryValid = expiry.length == 5;
    bool cvvValid = cvv.length == 3;
    
  
    
    bool isValid = cardValid && expiryValid && cvvValid;
    
    return isValid;
  }

  void _handleComplete() {
 
    if (_isFormComplete()) {
      
      // Show success message at the top using overlay
      ToastService.showSuccess(context, message: 'Карта успешно добавлена!');
      
      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        // Navigator.pop(context);
      });
    } else {
      print('Form is not complete - button should not be enabled');
    }
  }

  void _handleFillLater() {
    Navigator.pop(context);
  }


  @override
  void dispose() {
    _cardNumberController.removeListener(_onCardNumberChanged);
    _expiryController.removeListener(_onExpiryChanged);
    _cvvController.removeListener(_onCvvChanged);
    
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardNumberFocus.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Данные мастера',
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Main title
              Center(
                child: Text(
                  'Добавьте карту для работы с заказами',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Center(
                child: Text(
                  'Для доступа к заказам нужно зарезервировать 1000 ₽. При взятии заказа спишется 200 ₽, а затем откроется чат и контакты клиента.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Card number field
              Text(
                'Номер карты',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4F5B63),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _cardNumberController,
                  focusNode: _cardNumberFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
                  ],
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: '1234 1234 1234 1234',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Expiry and CVV row
              Row(
                children: [
                  // Expiry field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Срок действия',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF4F5B63),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _expiryController,
                            focusNode: _expiryFocus,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'ММ/ГГ',
                              hintStyle: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // CVV field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CVV/CVC',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF4F5B63),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _cvvController,
                            focusNode: _cvvFocus,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: '3-значный код',
                              hintStyle: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Complete button
              Builder(
                builder: (context) {
                  bool isComplete = _isFormComplete();
                  return Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isComplete
                          ? const LinearGradient(
                              colors: [Color(0xFFF67824), Color(0xFFF6A523)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isComplete
                          ? null
                          : (isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isComplete
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
                        onTap: isComplete ? _handleComplete : null,
                        child: Center(
                          child: Text(
                            'Завершить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isComplete
                                  ? Colors.white
                                  : (isDark ? const Color(0xFF818B93) : AppColors.lightTextSecondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Fill later option
              GestureDetector(
                onTap: _handleFillLater,
                child: Center(
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
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
