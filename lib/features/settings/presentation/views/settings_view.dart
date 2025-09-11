import 'package:new_azkar_app/core/constants/app_colors.dart';
import 'package:new_azkar_app/core/constants/layout_constants.dart';
import 'package:new_azkar_app/core/constants/shadows.dart';
import 'package:new_azkar_app/core/constants/text_styles.dart';
import 'package:new_azkar_app/core/services/isar_services.dart';
import 'package:new_azkar_app/core/services/settings_service.dart';
import 'package:new_azkar_app/core/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView>
    with TickerProviderStateMixin {
  final IsarServices _isarServices = IsarServices();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (settings.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.fourthColor,
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings,
                  size: 40,
                  color: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'جاري تحميل الإعدادات...',
                style: TextStyles.medium.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.fourthColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(LayoutConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('الصوت والوسائط'),
              _buildSwitchTile(
                icon: Icons.volume_up,
                title: 'تشغيل الصوت تلقائياً',
                subtitle: 'تشغيل الصوت عند فتح الأذكار',
                value: settings.autoPlayAudio,
                onChanged: (value) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .setAutoPlayAudio(value);
                },
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('المظهر والخط'),
              _buildSliderTile(
                icon: Icons.text_fields,
                title: 'حجم الخط',
                subtitle: '${settings.fontSize.round()}',
                value: settings.fontSize,
                min: 22.0,
                max: 30.0,
                onChanged: (value) async {
                  await ref.read(settingsProvider.notifier).setFontSize(value);
                },
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('إدارة البيانات'),
              _buildActionTile(
                icon: Icons.update,
                title: 'تحديث بيانات الأذكار',
                subtitle: 'إعادة تهيئة بيانات التطبيق',
                onTap: _showUpdateDataDialog,
                color: AppColors.warring,
              ),
              const SizedBox(height: 16),

              _buildSectionTitle('حول التطبيق'),
              _buildInfoTile(
                icon: Icons.info_outline,
                title: 'إصدار التطبيق',
                subtitle: '1.0.0',
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.share,
                title: 'مشاركة التطبيق',
                subtitle: 'شارك التطبيق لتنفع غيرك',
                color: AppColors.primaryColor,
                onTap: onShare,
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.description_outlined,
                title: 'سياسة الخصوصية',
                subtitle: 'اقرأ سياسة الخصوصية',
                onTap: () {
                  // Navigate to privacy policy
                },
                color: AppColors.secondaryColor,
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.help_outline,
                title: 'المساعدة والدعم',
                subtitle: 'كيفية استخدام التطبيق',
                onTap: () {
                  // Navigate to help
                },
                color: AppColors.thirdColor,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: AppColors.gold,
      elevation: 0,
      title: Text(
        'الإعدادات',
        style: TextStyles.bold.copyWith(color: AppColors.gold, fontSize: 22),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryColor,
            AppColors.secondaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: CShadow.LG,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.settings, color: AppColors.gold, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إعدادات التطبيق',
                  style: TextStyles.bold.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'خصص تجربتك في التطبيق',
                  style: TextStyles.medium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyles.mediumBold.copyWith(
          color: AppColors.secondaryColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CShadow.MD,
        border: Border.all(color: AppColors.secondaryColor.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.secondaryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.mediumBold.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyles.regular.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.secondaryColor,
                  activeTrackColor: AppColors.secondaryColor.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CShadow.MD,
        border: Border.all(color: AppColors.secondaryColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.secondaryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.mediumBold.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyles.regular.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.secondaryColor,
                inactiveTrackColor: AppColors.secondaryColor.withOpacity(0.2),
                thumbColor: AppColors.secondaryColor,
                overlayColor: AppColors.secondaryColor.withOpacity(0.1),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
                divisions: ((max - min) / 1).round(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'صغير',
                  style: TextStyles.regular.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'كبير',
                  style: TextStyles.regular.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final tileColor = color ?? AppColors.secondaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CShadow.MD,
        border: Border.all(color: tileColor.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: tileColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: tileColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.mediumBold.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyles.regular.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.secondaryColor.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? color,
  }) {
    final tileColor = color ?? AppColors.secondaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CShadow.MD,
        border: Border.all(color: tileColor.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: tileColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: tileColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.mediumBold.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyles.regular.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.secondaryColor.withOpacity(0.6),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.warring.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.warning_amber,
                  color: AppColors.warring,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'تحديث البيانات',
                style: TextStyles.mediumBold.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          content: Text(
            'سيتم حذف جميع البيانات الحالية وإعادة إدخالها من جديد. هل أنت متأكد؟',
            style: TextStyles.regular.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: TextStyles.medium.copyWith(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updatenew_azkar_appData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warring,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'تحديث',
                style: TextStyles.medium.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void onShare() {
    String message =
        '\n\n ✨ حمل تطبيق عمل اليوم والليلة الآن من متجر التطبيقات ✨\n تطبيق رائع يحتوي جميع اعمال وأدعية المسلم في يومه وليلته, ايضاً يمكنك قراءة القرآن وتتبع أوقات الأذان. وأينما كنت يمكنك تحديد اتجاه القبلة. فقط حمله الآن!.\n'
        'https://play.google.com/store/apps/details?id=com.Letterspd.amal_alyoum';

    SharePlus.instance.share(ShareParams(text: message));
  }

  Future<void> _updatenew_azkar_appData() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري تحديث البيانات...',
                    style: TextStyles.medium.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      await _isarServices.updateAzkarData();
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Text(
                  'تم تحديث, رجاءا اعد تشغيل التطبيق.',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'حدث خطأ أثناء تحديث البيانات',
                style: TextStyles.medium.copyWith(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
