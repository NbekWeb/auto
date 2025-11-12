import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../services/api.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final Map<int, bool> _expandedItems = {};
  List<FAQQuestion> _faqItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFAQs();
  }

  Future<void> _fetchFAQs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.request(
        url: 'auth/faq/',
        method: 'GET',
        open: true, // Public endpoint, no auth required
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['faqs'] != null) {
          final List<dynamic> faqsList = data['faqs'];
          setState(() {
            _faqItems = faqsList.map((faq) {
              return FAQQuestion(
                id: faq['id'] as int,
                question: faq['question'] as String,
                answer: faq['answer'] as String,
                order: faq['order'] as int? ?? 0,
              );
            }).toList();
            // Sort by order
            _faqItems.sort((a, b) => a.order.compareTo(b.order));
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Не удалось загрузить FAQ';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Ошибка при загрузке данных';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка подключения: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _toggleItem(int index) {
    setState(() {
      _expandedItems[index] = !(_expandedItems[index] ?? false);
    });
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
          'FAQ',
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Manrope',
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFFF771C),
                ),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14,
                          fontFamily: 'Manrope',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchFAQs,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF771C),
                        ),
                        child: const Text(
                          'Повторить',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _faqItems.isEmpty
                  ? Center(
                      child: Text(
                        'FAQ пока нет',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _faqItems.length,
                      itemBuilder: (context, index) {
                        final question = _faqItems[index];
                        final isExpanded = _expandedItems[index] ?? false;

                        return _FAQQuestionItem(
                          question: question.question,
                          answer: question.answer,
                          isExpanded: isExpanded,
                          onTap: () => _toggleItem(index),
                          isDark: isDark,
                        );
                      },
                    ),
    );
  }

}

class FAQQuestion {
  final int id;
  final String question;
  final String answer;
  final int order;

  FAQQuestion({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
  });
}

class _FAQQuestionItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool isDark;

  const _FAQQuestionItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF252F37) : const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isExpanded
                          ? const Color(0xFFFF771C)
                          : (isDark ? AppColors.darkText : AppColors.lightText),
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: isExpanded ? 0.125 : 0.0, // 45 degrees = 0.125 turns
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: isExpanded
                        ? const Color(0xFFFF771C)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                answer,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontFamily: 'Manrope',
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 1,
                        color: const Color(0xFFFF771C),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

