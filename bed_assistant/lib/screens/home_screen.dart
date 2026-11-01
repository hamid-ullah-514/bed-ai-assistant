import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/assistant_provider.dart';
import 'ask_question_screen.dart';
import 'my_books_screen.dart';
import 'search_in_books_screen.dart';
import 'question_history_screen.dart';
import 'settings_screen.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  final _quickQuestionController = TextEditingController();

  @override
  void dispose() {
    _quickQuestionController.dispose();
    super.dispose();
  }

  void _onQuickAsk() {
    final text = _quickQuestionController.text.trim();
    if (text.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LoadingScreen(question: text),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AskQuestionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    // Pages for Bottom Navigation (Home, Books, History, Profile/Settings)
    final pages = [
      _buildHomeContent(context, provider),
      const MyBooksScreen(),
      const QuestionHistoryScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: pages[_selectedNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (idx) => setState(() => _selectedNavIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, AssistantProvider provider) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.primaryDarkNavy),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'B.Ed AI Book Assistant',
          style: TextStyle(
            color: AppColors.primaryDarkNavy,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primaryDarkNavy),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchInBooksScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.lightMintBackground),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'B.Ed AI Book Assistant',
                    style: TextStyle(
                      color: AppColors.primaryDarkNavy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Exclusively Grounded in 6 PDF Books',
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: AppColors.primaryMintGreen),
              title: const Text('My Books'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _selectedNavIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: AppColors.primaryMintGreen),
              title: const Text('Question History'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _selectedNavIndex = 2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.primaryMintGreen),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _selectedNavIndex = 3);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Card: Ask Anything From Your 6 Books (Matching Screen 3)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.lightMintBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ask Anything',
                    style: TextStyle(
                      color: AppColors.primaryDarkNavy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'From Your 6 Books',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.lightBorder),
                          ),
                          child: TextField(
                            controller: _quickQuestionController,
                            decoration: const InputDecoration(
                              hintText: 'Type your question here...',
                              hintStyle: TextStyle(fontSize: 12.5, color: AppColors.secondaryText),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            onSubmitted: (_) => _onQuickAsk(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryMintGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _onQuickAsk,
                        child: const Text('Ask', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 4 Grid Action Cards (Matching Screen 3)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _buildGridCard(
                  icon: Icons.menu_book_rounded,
                  title: 'My Books',
                  subtitle: '6 PDF Books',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MyBooksScreen()),
                    );
                  },
                ),
                _buildGridCard(
                  icon: Icons.history_rounded,
                  title: 'Question History',
                  subtitle: 'View Previous',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QuestionHistoryScreen()),
                    );
                  },
                ),
                _buildGridCard(
                  icon: Icons.search_rounded,
                  title: 'Browse Books',
                  subtitle: 'Read / Search',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchInBooksScreen()),
                    );
                  },
                ),
                _buildGridCard(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  subtitle: 'App Settings',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Quick Ask Prompts / Practice Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.primaryMintGreen, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          color: AppColors.primaryDarkNavy,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildPromptRow('تعلیم کے مقاصد کیا ہیں؟'),
                  const Divider(height: 16),
                  _buildPromptRow('بچوں کی نفسیات پر مختصر لکھیں۔'),
                  const Divider(height: 16),
                  _buildPromptRow('What are the principles of lesson planning?'),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptRow(String question) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LoadingScreen(question: question),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 13,
                ),
                textDirection: question.contains(RegExp(r'[\u0600-\u06FF]'))
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.lightMintBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryMintGreen, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryDarkNavy,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
