import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/answer.dart';
import '../providers/assistant_provider.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/islamic_evidence_widget.dart';
import 'pdf_viewer_screen.dart';

class ChatMessageItem {
  final String id;
  final String sender; // 'user' or 'ai'
  final String text;
  final AnswerResponse? answer;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessageItem({
    required this.id,
    required this.sender,
    required this.text,
    this.answer,
    required this.timestamp,
    this.isLoading = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessageItem> _messages = [];
  bool _isSending = false;

  // Language choice: 'urdu' or 'english'
  String _selectedLanguage = 'urdu';

  final List<String> _suggestedPrompts = [
    'استاد کی خصوصیات اور تدریسی کردار کیا ہے؟ (8601)',
    'What are formative and summative assessments? (8602)',
    'نصاب سازی کے بنیادی عناصر اور مراحل بیان کریں (8603)',
    'تعلیمی تحقیق کے طریقے اور ڈیٹا کلیکشن (8604)',
    'Theories of Educational Leadership and Management (8605)',
    'تعلیم اور معاشرتی ترقی میں اسکول کا کردار (8606)',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssistantProvider>(context, listen: false);
      provider.checkConnection();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend([String? presetText]) async {
    final query = presetText ?? _textController.text.trim();
    if (query.isEmpty || _isSending) return;

    _textController.clear();
    FocusScope.of(context).unfocus();

    final userMsgId = DateTime.now().millisecondsSinceEpoch.toString();
    final aiMsgId = '${userMsgId}_ai';

    setState(() {
      _isSending = true;
      _messages.add(ChatMessageItem(
        id: userMsgId,
        sender: 'user',
        text: query,
        timestamp: DateTime.now(),
      ));
      _messages.add(ChatMessageItem(
        id: aiMsgId,
        sender: 'ai',
        text: '',
        isLoading: true,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();

    final provider = Provider.of<AssistantProvider>(context, listen: false);
    final success = await provider.ask(query, language: _selectedLanguage);

    setState(() {
      _isSending = false;
      final aiIdx = _messages.indexWhere((m) => m.id == aiMsgId);
      if (aiIdx != -1) {
        if (success && provider.currentAnswer != null) {
          _messages[aiIdx] = ChatMessageItem(
            id: aiMsgId,
            sender: 'ai',
            text: provider.currentAnswer!.message,
            answer: provider.currentAnswer,
            timestamp: DateTime.now(),
            isLoading: false,
          );
        } else {
          final err = provider.currentError ?? 'جواب حاصل نہیں ہو سکا۔ برائے مہربانی دوبارہ کوشش کریں۔';
          _messages[aiIdx] = ChatMessageItem(
            id: aiMsgId,
            sender: 'ai',
            text: err,
            timestamp: DateTime.now(),
            isLoading: false,
          );
        }
      }
    });
    _scrollToBottom();
  }

  void _copyAnswerToClipboard(String question, AnswerResponse answer) {
    final fullText = answer.toFormattedPlainText(question: question);
    Clipboard.setData(ClipboardData(text: fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'پورا امتحانی جواب (تمام 20 ہیڈنگز اور کتابی حوالوں سمیت) کاپی ہو گیا!',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryMintGreen,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareAnswer(String question, AnswerResponse answer) {
    final fullText = answer.toFormattedPlainText(question: question);
    Share.share(
      fullText,
      subject: 'B.Ed AI Study Answer: $question',
    );
  }

  void _showChangeIpDialog() async {
    final currentUrl = await StorageService.getBaseUrl();
    final controller = TextEditingController(text: currentUrl);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.wifi, color: AppColors.primaryMintGreen),
            SizedBox(width: 8),
            Text('کمپیوٹر سرور آئی پی', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اپنے کمپیوٹر کا وائی فائی آئی پی درج کریں:',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Server URL',
                hintText: 'http://192.168.1.38:8000',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.link, size: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('منسوخ', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMintGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final newUrl = controller.text.trim();
              if (newUrl.isNotEmpty) {
                await StorageService.setBaseUrl(newUrl);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
                if (mounted) {
                  final provider = Provider.of<AssistantProvider>(context, listen: false);
                  await provider.checkConnection();
                }
              }
            },
            child: const Text('محفوظ کریں', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssistantProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        title: Row(
          children: [
            const AppLogo(size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'B.Ed AI Assistant',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkNavy,
                    ),
                  ),
                  InkWell(
                    onTap: _showChangeIpDialog,
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.isServerOnline ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            provider.isServerOnline
                                ? '6 کتب منسلک (1,534 صفحات)'
                                : 'سرور آف لائن (آئی پی چیک کریں)',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: provider.isServerOnline
                                  ? AppColors.primaryMintGreen
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi_tethering, color: AppColors.primaryDarkNavy, size: 20),
            tooltip: 'سرور آئی پی',
            onPressed: _showChangeIpDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined, color: AppColors.primaryMintGreen, size: 20),
            tooltip: 'نیا چیٹ (+ New Chat)',
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
          ),
        ],
      ),
      drawer: _buildDrawer(provider),
      body: SafeArea(
        child: Column(
          children: [
            // Connection alert if offline
            if (!provider.isServerOnline)
              Container(
                color: Colors.amber.shade50,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'کمپیوٹر سے رابطہ نہیں ہے۔ PC پر run_backend.bat چلائیں۔',
                        style: TextStyle(fontSize: 11, color: Colors.brown),
                      ),
                    ),
                    TextButton(
                      onPressed: _showChangeIpDialog,
                      child: const Text('آئی پی سیٹ کریں', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ),

            // Messages Stream
            Expanded(
              child: _messages.isEmpty
                  ? _buildWelcomeScreen()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        if (msg.sender == 'user') {
                          return _buildUserBubble(msg);
                        } else {
                          return _buildAiBubble(msg);
                        }
                      },
                    ),
            ),

            // Language Selector Bar (Urdu vs English)
            _buildLanguageSelectorBar(),

            // Bottom Chat Input Bar (ChatGPT style)
            _buildBottomInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelectorBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.lightBorder, width: 0.6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.translate, size: 15, color: AppColors.primaryMintGreen),
          const SizedBox(width: 6),
          const Text(
            'جواب کی زبان:',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDarkNavy,
            ),
          ),
          const Spacer(),
          // Urdu Pill
          InkWell(
            onTap: () {
              setState(() {
                _selectedLanguage = 'urdu';
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _selectedLanguage == 'urdu'
                    ? AppColors.primaryMintGreen
                    : AppColors.mainBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedLanguage == 'urdu'
                      ? AppColors.primaryMintGreen
                      : AppColors.lightBorder,
                ),
              ),
              child: Text(
                'اردو (Urdu)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _selectedLanguage == 'urdu' ? Colors.white : AppColors.primaryText,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // English Pill
          InkWell(
            onTap: () {
              setState(() {
                _selectedLanguage = 'english';
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _selectedLanguage == 'english'
                    ? AppColors.primaryMintGreen
                    : AppColors.mainBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedLanguage == 'english'
                      ? AppColors.primaryMintGreen
                      : AppColors.lightBorder,
                ),
              ),
              child: Text(
                'English',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _selectedLanguage == 'english' ? Colors.white : AppColors.primaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(size: 64),
            const SizedBox(height: 12),
            const Text(
              'B.Ed AI Study Assistant',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDarkNavy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'علامہ اقبال اوپن یونیورسٹی کی 6 کتب سے 20 امتحانی ہیڈنگز\n(8601, 8602, 8603, 8604, 8605, 8606)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'فوری امتحانی سوالات:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarkNavy,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ..._suggestedPrompts.map((prompt) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 6),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      side: const BorderSide(color: AppColors.lightBorder),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    onPressed: () => _handleSend(prompt),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back_ios, size: 12, color: AppColors.primaryMintGreen),
                        Flexible(
                          child: Text(
                            prompt,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildUserBubble(ChatMessageItem msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.primaryDarkNavy,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          msg.text,
          style: const TextStyle(
            fontSize: 13.5,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildAiBubble(ChatMessageItem msg) {
    if (msg.isLoading) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMintGreen),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'چھ بی ایڈ کتب میں تحقیق کی جا رہی ہے...',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkNavy,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '20 امتحانی ہیڈنگز اور کتابوں کے صفحات کی تیاری...',
                    style: TextStyle(fontSize: 10.5, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final answer = msg.answer;
    if (answer == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4F4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      );
    }

    // Straight, sequential academic answer format
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar with Quick Copy & Share
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.lightMintBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, color: AppColors.primaryMintGreen, size: 18),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'امتحانی جواب (20 ہیڈنگز مع کتب و صفحات)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryMintGreen,
                    ),
                  ),
                ),
                // COPY BUTTON
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMintGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.copy, size: 13),
                  label: const Text('کاپی کریں', style: TextStyle(fontSize: 11)),
                  onPressed: () => _copyAnswerToClipboard(msg.text, answer),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.share, size: 17, color: AppColors.primaryDarkNavy),
                  tooltip: 'شیئر کریں',
                  onPressed: () => _shareAnswer(msg.text, answer),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Introduction
                if (answer.introduction.isNotEmpty) ...[
                  const Text(
                    'تعارف (Introduction):',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkNavy,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    answer.introduction,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.primaryText,
                      height: 1.55,
                    ),
                  ),
                  const Divider(height: 20, thickness: 0.7),
                ],

                // 20 Headings
                if (answer.headings.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تفصیلی امتحانی عنوانات:',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDarkNavy,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.softBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${answer.headings.length} عنوانات (مکمل)',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDarkNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Sequential headings straight down
                  ...answer.headings.map((h) => _buildHeadingBlock(h)),
                  const Divider(height: 20, thickness: 0.7),
                ],

                // Islamic Evidence
                if (answer.islamicEvidence != null &&
                    (answer.islamicEvidence!.quran.isNotEmpty ||
                        answer.islamicEvidence!.hadith.isNotEmpty)) ...[
                  IslamicEvidenceWidget(evidence: answer.islamicEvidence!),
                  const Divider(height: 20, thickness: 0.7),
                ],

                // Conclusion
                if (answer.conclusion.isNotEmpty) ...[
                  const Text(
                    'حاصل کلام (Conclusion):',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkNavy,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    answer.conclusion,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.primaryText,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Full-width Bottom Copy Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDarkNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.content_copy, size: 16),
                    label: const Text(
                      '📋 پورا جواب ٹیکسٹ میں کاپی کریں (Copy Full Answer)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _copyAnswerToClipboard(msg.text, answer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingBlock(HeadingItem h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mainBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBorder, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number & Heading Title
          Text(
            '${h.headingNumber}. ${h.headingTitle}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDarkNavy,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 5),
          // Explanation
          Text(
            h.explanation,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryText,
              height: 1.5,
            ),
          ),
          // Source Reference Pill (Single concise line)
          if (h.sourceReference != null) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: () {
                final ref = h.sourceReference!;
                final bNum = int.tryParse(ref.bookNumber.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfViewerScreen(
                      bookNumber: bNum,
                      bookTitle: ref.bookTitle,
                      initialPage: ref.pdfPage,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book, size: 12, color: AppColors.primaryMintGreen),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '${h.sourceReference!.bookNumber}: ${h.sourceReference!.bookTitle} | باب: ${h.sourceReference!.chapter} | صفحہ: ${h.sourceReference!.pdfPage} (پی ڈی ایف کھولیں ↗)',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDarkNavy,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.lightBorder, width: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 110),
              decoration: BoxDecoration(
                color: AppColors.mainBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: TextField(
                controller: _textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: _selectedLanguage == 'urdu'
                      ? 'اپنا سوال لکھیں (جواب اردو میں ملے گا)...'
                      : 'Ask your question (Answer in English)...',
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryMintGreen,
            ),
            child: IconButton(
              icon: _isSending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              onPressed: _isSending ? null : () => _handleSend(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AssistantProvider provider) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.primaryDarkNavy,
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLogo(size: 42),
                  SizedBox(height: 10),
                  Text(
                    'B.Ed AI Book Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '6 Books • 1,534 Pages Indexed',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.add, color: AppColors.primaryMintGreen, size: 20),
              title: const Text('نیا چیٹ شروع کریں (+ New Chat)', style: TextStyle(fontSize: 13)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                });
              },
            ),
            const Divider(height: 1),
            ListTile(
              dense: true,
              leading: const Icon(Icons.wifi, color: AppColors.primaryDarkNavy, size: 20),
              title: const Text('کمپیوٹر سرور کا آئی پی سیٹ کریں', style: TextStyle(fontSize: 13)),
              subtitle: Text(
                provider.isServerOnline ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  fontSize: 10.5,
                  color: provider.isServerOnline ? Colors.green : Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showChangeIpDialog();
              },
            ),
            const Divider(height: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'سابقہ پوچھے گئے سوالات (History):',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ),
            Expanded(
              child: provider.history.isEmpty
                  ? const Center(
                      child: Text(
                        'ابھی تک کوئی سوال محفوظ نہیں۔',
                        style: TextStyle(fontSize: 11.5, color: AppColors.secondaryText),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.history.length,
                      itemBuilder: (ctx, idx) {
                        final item = provider.history[idx];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.chat_bubble_outline, size: 16),
                          title: Text(
                            item.question,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            item.timestamp,
                            style: const TextStyle(fontSize: 9.5),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _handleSend(item.question);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
