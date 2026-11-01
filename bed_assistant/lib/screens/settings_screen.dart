import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/assistant_provider.dart';
import '../services/storage_service.dart';
import 'notification_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _serverUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    final u = await StorageService.getBaseUrl();
    setState(() => _serverUrlController.text = u);
  }

  void _showServerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Backend Server URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _serverUrlController,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                hintText: 'http://192.168.1.35:8000',
              ),
            ),
            const SizedBox(height: 12),
            const Text('Quick Select:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ActionChip(
                  label: const Text('☁️ Cloud Server (Vercel)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    _serverUrlController.text = 'https://bed-ai-assistant.vercel.app';
                  },
                ),
                ActionChip(
                  label: const Text('Wi-Fi PC (192.168.1.35)', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    _serverUrlController.text = 'http://192.168.1.35:8000';
                  },
                ),
                ActionChip(
                  label: const Text('Localhost', style: TextStyle(fontSize: 11)),
                  onPressed: () {
                    _serverUrlController.text = 'http://127.0.0.1:8000';
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await StorageService.setBaseUrl(_serverUrlController.text.trim());
              if (mounted) {
                context.read<AssistantProvider>().checkConnection();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Server URL updated')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          _buildSettingItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English / اردو',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Both English and Urdu are fully supported.')),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Light / Dark / System',
            onTap: () {
              context.read<AssistantProvider>().toggleDarkMode();
            },
          ),
          _buildSettingItem(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Enable notifications',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.delete_outline,
            title: 'Clear Cache',
            subtitle: 'Free up space',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully.')),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.dns_outlined,
            title: 'Server Connection',
            subtitle: _serverUrlController.text.isNotEmpty ? _serverUrlController.text : 'http://192.168.1.35:8000',
            onTap: _showServerDialog,
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'About App',
            subtitle: 'Version 1.0.0 (B.Ed AI Book Assistant)',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'B.Ed AI Book Assistant',
                applicationVersion: '1.0.0',
                children: const [
                  Text('Exclusively grounded in 6 official B.Ed textbooks.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.softBlue,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryDarkNavy, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryDarkNavy,
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12.5,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText),
        onTap: onTap,
      ),
    );
  }
}
