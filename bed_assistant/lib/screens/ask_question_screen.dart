import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'loading_screen.dart';

class AskQuestionScreen extends StatefulWidget {
  final String? initialQuestion;

  const AskQuestionScreen({super.key, this.initialQuestion});

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final _questionController = TextEditingController();
  bool _isUrdu = true;

  final List<String> _urduExamples = [
    'تعلیم کے مقاصد کیا ہیں؟',
    'بچوں کی نفسیات پر مختصر لکھیں۔',
    'تدریس کے طریق کون سے ہیں؟',
    'تشکیلی اور تکمیلی جائزے میں فرق بیان کریں۔',
    'تعلیم میں سائنسی طریقے کی اہمیت واضح کریں۔',
  ];

  final List<String> _englishExamples = [
    'What are the primary aims of education?',
    'Explain the principles of lesson planning.',
    'Compare formative and summative assessment.',
    'Discuss curriculum foundations and models.',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuestion != null) {
      _questionController.text = widget.initialQuestion!;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _submit() {
    final q = _questionController.text.trim();
    if (q.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoadingScreen(question: q),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Ask Question'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Language Toggle Pill
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isUrdu = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isUrdu ? AppColors.primaryMintGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'اردو',
                          style: TextStyle(
                            color: _isUrdu ? Colors.white : AppColors.secondaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isUrdu = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: !_isUrdu ? AppColors.primaryMintGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'English',
                          style: TextStyle(
                            color: !_isUrdu ? Colors.white : AppColors.secondaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Question Input Box
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: TextField(
                controller: _questionController,
                maxLines: 5,
                minLines: 4,
                textDirection: _isUrdu ? TextDirection.rtl : TextDirection.ltr,
                textAlign: _isUrdu ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  hintText: _isUrdu ? 'اپنا سوال یہاں لکھیں...' : 'Type your question here...',
                  hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
                  hintTextDirection: _isUrdu ? TextDirection.rtl : TextDirection.ltr,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Ask Question Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMintGreen,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submit,
              child: const Text('Ask Question', style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 28),

            // Example Questions
            const Text(
              'Example Questions',
              style: TextStyle(
                color: AppColors.primaryDarkNavy,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),

            ...(_isUrdu ? _urduExamples : _englishExamples).map(
              (eq) => InkWell(
                onTap: () {
                  _questionController.text = eq;
                  _submit();
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryMintGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          eq,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
