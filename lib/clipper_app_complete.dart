import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

// ==================== Theme & Constants ====================
class AppColors {
  static const Color background = Color(0xFF0F0F1A);
  static const Color card = Color(0xFF161B2C);
  static const Color accent = Color(0xFF00FFCC);
  static const Color accentDark = Color(0xFF00CCAA);
  static const Color surface = Color(0xFF1F263F);
  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white38;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}

// ==================== Models ====================
class Campaign {
  final String id;
  final String title;
  final String creator;
  final String creatorAvatar;
  final double cpm;
  final double remainingBudget;
  final double totalBudget;
  final String targetTag;
  final String description;
  final List<String> rules;
  final String category;
  final DateTime deadline;
  final int views;
  final double rating;

  Campaign({
    required this.id,
    required this.title,
    required this.creator,
    required this.creatorAvatar,
    required this.cpm,
    required this.remainingBudget,
    required this.totalBudget,
    required this.targetTag,
    required this.description,
    required this.rules,
    required this.category,
    required this.deadline,
    this.views = 0,
    this.rating = 0.0,
  });

  double get progress => remainingBudget / totalBudget;
  bool get isActive => remainingBudget > 0;
  String get formattedDeadline => 
    "${_deadlineFormat(deadline)}";

  String _deadlineFormat(DateTime date) {
    final diff = date.difference(DateTime.now());
    if (diff.inDays > 0) return "${diff.inDays} يوم متبقي";
    if (diff.inHours > 0) return "${diff.inHours} ساعة متبقية";
    return "تنتهي قريباً";
  }
}

class Submission {
  final String id;
  final String campaignId;
  final String url;
  final String caption;
  final DateTime submittedAt;
  final SubmissionStatus status;
  final double? earnings;
  final int? views;

  Submission({
    required this.id,
    required this.campaignId,
    required this.url,
    required this.caption,
    required this.submittedAt,
    this.status = SubmissionStatus.pending,
    this.earnings,
    this.views,
  });
}

enum SubmissionStatus {
  pending,
  approved,
  rejected,
  paid,
}

class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final double balance;
  final int totalSubmissions;
  final int approvedSubmissions;
  final double totalEarnings;
  final bool isCreator;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.balance = 0.0,
    this.totalSubmissions = 0,
    this.approvedSubmissions = 0,
    this.totalEarnings = 0.0,
    this.isCreator = false,
  });
}

// ==================== Mock Data ====================
class MockData {
  static final List<Campaign> campaigns = [
    Campaign(
      id: "1",
      title: "بودكاست ريادة الأعمال العربي",
      creator: "أحمد الشقيري",
      creatorAvatar: "AS",
      cpm: 2.0,
      remainingBudget: 450.0,
      totalBudget: 500.0,
      targetTag: "#خواطر",
      description: "شاركنا مقاطع ملهمة من بودكاست ريادة الأعمال العربي. نبحث عن محتوى أصيل يلامس قلوب المتابعين.",
      rules: [
        "المدة الأدنى للمقطع هي 15 ثانية على الأقل.",
        "ممنوع استخدام أصوات الذكاء الاصطناعي تماماً.",
        "يجب كتابة الترجمة النصية يدوياً وبألوان واضحة (أبيض، أصفر).",
        "يجب وضع التاغ المطلوب في وصف الفيديو ليتم فحصه واعتماده.",
        "الجودة يجب أن تكون 1080p على الأقل.",
      ],
      category: "بودكاست",
      deadline: DateTime.now().add(const Duration(days: 15)),
      views: 12500,
      rating: 4.8,
    ),
    Campaign(
      id: "2",
      title: "تحدي تداول العملات الرقمية",
      creator: "منصة Ouinex",
      creatorAvatar: "OX",
      cpm: 3.0,
      remainingBudget: 3993.0,
      totalBudget: 4000.0,
      targetTag: "#ouinex",
      description: "انضم لتحدي تداول العملات الرقمية! أنشئ محتوى تعليمي وممتع عن عالم الكريبتو.",
      rules: [
        "المدة الأدنى للمقطع هي 15 ثانية على الأقل.",
        "ممنوع استخدام أصوات الذكاء الاصطناعي تماماً.",
        "يجب كتابة الترجمة النصية يدوياً وبألوان واضحة (أبيض، أصفر).",
        "يجب وضع التاغ المطلوب في وصف الفيديو ليتم فحصه واعتماده.",
        "يمنع تقديم نصائح استثمارية مضللة.",
      ],
      category: "تداول",
      deadline: DateTime.now().add(const Duration(days: 30)),
      views: 8900,
      rating: 4.5,
    ),
    Campaign(
      id: "3",
      title: "أسرار المبيعات والإغلاق العالي",
      creator: "Joel Elster",
      creatorAvatar: "JE",
      cpm: 1.5,
      remainingBudget: 2452.0,
      totalBudget: 2500.0,
      targetTag: "@joelelster",
      description: "تعلم أسرار المبيعات من خبير الإغلاق العالمي. أنشئ محتوى يحفز على التعلم والتطور.",
      rules: [
        "المدة الأدنى للمقطع هي 15 ثانية على الأقل.",
        "ممنوع استخدام أصوات الذكاء الاصطناعي تماماً.",
        "يجب كتابة الترجمة النصية يدوياً وبألوان واضحة (أبيض، أصفر).",
        "يجب وضع التاغ المطلوب في وصف الفيديو ليتم فحصه واعتماده.",
        "التركيز على قيمة المحتوى وليس على التسويق المباشر.",
      ],
      category: "تطوير ذاتي",
      deadline: DateTime.now().add(const Duration(days: 7)),
      views: 5600,
      rating: 4.9,
    ),
    Campaign(
      id: "4",
      title: "دورة التسويق الرقمي المتقدم",
      creator: "محمد العريفي",
      creatorAvatar: "MA",
      cpm: 2.5,
      remainingBudget: 1800.0,
      totalBudget: 3000.0,
      targetTag: "#تسويق_رقمي",
      description: "شاركنا أفضل لحظات دورة التسويق الرقمي. نبحث عن محتوى احترافي ومفيد.",
      rules: [
        "المدة الأدنى للمقطع هي 20 ثانية على الأقل.",
        "ممنوع استخدام أصوات الذكاء الاصطناعي تماماً.",
        "يجب كتابة الترجمة النصية يدوياً.",
        "يجب وضع التاغ المطلوب في وصف الفيديو.",
      ],
      category: "تسويق",
      deadline: DateTime.now().add(const Duration(days: 20)),
      views: 3200,
      rating: 4.3,
    ),
  ];

  static final List<Submission> submissions = [
    Submission(
      id: "sub1",
      campaignId: "1",
      url: "https://tiktok.com/@user/video/123",
      caption: "مقطع ملهم من بودكاست ريادة الأعمال #خواطر",
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: SubmissionStatus.approved,
      earnings: 45.0,
      views: 15000,
    ),
    Submission(
      id: "sub2",
      campaignId: "2",
      url: "https://instagram.com/reel/456",
      caption: "تحدي الكريبتو مع Ouinex #ouinex",
      submittedAt: DateTime.now().subtract(const Duration(days: 5)),
      status: SubmissionStatus.pending,
    ),
  ];

  static final User currentUser = User(
    id: "user1",
    name: "محمد المبدع",
    email: "creator@example.com",
    avatar: "MM",
    balance: 125.50,
    totalSubmissions: 12,
    approvedSubmissions: 8,
    totalEarnings: 450.0,
  );
}

// ==================== Main App ====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clipper - منصة المحتوى العربي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthScreen(),
    );
  }
}

// ==================== Auth Screen ====================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("يرجى ملء جميع الحقول المطلوبة");
      return;
    }
    if (!isLogin && _nameController.text.isEmpty) {
      _showError("يرجى إدخال اسم المستخدم");
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, AppColors.accentDark],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.play_circle_fill,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Clipper",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "منصة المحتوى العربي",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 48),

              // Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLogin = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isLogin ? AppColors.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "تسجيل الدخول",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isLogin ? Colors.white : AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLogin = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isLogin ? AppColors.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "إنشاء حساب",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !isLogin ? Colors.white : AppColors.textMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form
              if (!isLogin)
                _buildTextField(
                  controller: _nameController,
                  hint: "الاسم الكامل",
                  icon: Icons.person,
                ),
              if (!isLogin) const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                hint: "البريد الإلكتروني",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                hint: "كلمة المرور",
                icon: Icons.lock,
                obscureText: _obscurePassword,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAuth,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : Text(
                          isLogin ? "تسجيل الدخول" : "إنشاء حساب",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              if (isLogin)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(color: AppColors.accent),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.card,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.textMuted),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1),
        ),
      ),
    );
  }
}

// ==================== Main Navigation ====================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ExploreCampaignsScreen(),
    const SubmissionsScreen(),
    const EarningsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textMuted,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: "استكشاف",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: "تقديماتي",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: "الأرباح",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "حسابي",
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Explore Campaigns Screen ====================
class ExploreCampaignsScreen extends StatefulWidget {
  const ExploreCampaignsScreen({super.key});

  @override
  State<ExploreCampaignsScreen> createState() => _ExploreCampaignsScreenState();
}

class _ExploreCampaignsScreenState extends State<ExploreCampaignsScreen> {
  String _searchQuery = "";
  String _selectedCategory = "الكل";
  final List<String> _categories = ["الكل", "بودكاست", "تداول", "تطوير ذاتي", "تسويق"];

  List<Campaign> get _filteredCampaigns {
    return MockData.campaigns.where((campaign) {
      final matchesSearch = campaign.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          campaign.creator.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "الكل" || campaign.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("استكشف الحملات"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.card,
                hintText: "ابحث عن حملة أو منشئ...",
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = category),
                    backgroundColor: AppColors.card,
                    selectedColor: AppColors.accent.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.accent : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.accent : Colors.transparent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Campaigns List
          Expanded(
            child: _filteredCampaigns.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
                        SizedBox(height: 16),
                        Text(
                          "لا توجد حملات مطابقة",
                          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCampaigns.length,
                    itemBuilder: (context, index) {
                      return CampaignCard(campaign: _filteredCampaigns[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CampaignCard extends StatelessWidget {
  final Campaign campaign;

  const CampaignCard({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.3),
                        AppColors.accentDark.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      campaign.creatorAvatar,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        campaign.creator,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: Text(
                    "\$${campaign.cpm.toStringAsFixed(1)} CPM",
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStat(Icons.visibility, "${campaign.views}", "مشاهدة"),
                const SizedBox(width: 16),
                _buildStat(Icons.star, "${campaign.rating}", "تقييم"),
                const SizedBox(width: 16),
                _buildStat(Icons.access_time, campaign.formattedDeadline, "متبقي"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Budget Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الميزانية: \$${campaign.remainingBudget.toStringAsFixed(0)} / \$${campaign.totalBudget.toStringAsFixed(0)}",
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    Text(
                      "${(campaign.progress * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: campaign.progress,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CampaignDetailsScreen(campaign: campaign),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "عرض الشروط والتفاصيل",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}

// ==================== Campaign Details Screen ====================
class CampaignDetailsScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailsScreen({super.key, required this.campaign});

  @override
  State<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToRules = false;

  @override
  void dispose() {
    _urlController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.host.contains('tiktok') || uri.host.contains('instagram'));
  }

  void _submitClip() async {
    if (_urlController.text.isEmpty || _captionController.text.isEmpty) {
      _showSnackBar("⚠️ برجاء ملء حقل الرابط وحقل الوصف", AppColors.warning);
      return;
    }

    if (!_isValidUrl(_urlController.text)) {
      _showSnackBar("⚠️ الرابط غير صالح. يجب أن يكون رابط TikTok أو Instagram", AppColors.error);
      return;
    }

    if (!_agreedToRules) {
      _showSnackBar("⚠️ يجب الموافقة على الشروط أولاً", AppColors.warning);
      return;
    }

    if (!_captionController.text.contains(widget.campaign.targetTag)) {
      _showSnackBar("⚠️ يجب إضافة التاغ ${widget.campaign.targetTag} في الوصف", AppColors.warning);
      return;
    }

    setState(() => _isLoading = true);

    // محاكاة الإرسال
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    _showSnackBar("🚀 تم إرسال المقطع بنجاح! سيتم مراجعته خلال 24 ساعة", AppColors.success);

    _urlController.clear();
    _captionController.clear();
    setState(() => _agreedToRules = false);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("تفاصيل الحملة"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent.withOpacity(0.3),
                              AppColors.accentDark.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            widget.campaign.creatorAvatar,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.campaign.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "بواسطة: ${widget.campaign.creator}",
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.campaign.description,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tag, color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "التاغ المطلوب: ${widget.campaign.targetTag}",
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Rules Section
            const Text(
              "القوانين والشروط الأساسية",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: widget.campaign.rules.map((rule) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.check, size: 14, color: AppColors.accent),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            rule,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Section
            const Text(
              "تقديم المقطع",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _urlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      hintText: "صق رابط مقطع الـ Reels أو TikTok هنا",
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.link, color: AppColors.textMuted),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _captionController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      hintText: "اكتب أو صق الوصف (Caption) الذي استخدمته في الفيديو كاملاً",
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.description, color: AppColors.textMuted),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Agreement Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToRules,
                        onChanged: (value) => setState(() => _agreedToRules = value ?? false),
                        activeColor: AppColors.accent,
                        checkColor: Colors.black,
                      ),
                      const Expanded(
                        child: Text(
                          "أقر بأنني قرأت جميع الشروط ووافقت عليها",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        disabledBackgroundColor: AppColors.accent.withOpacity(0.3),
                      ),
                      onPressed: _isLoading ? null : _submitClip,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                            )
                          : const Text(
                              "تأكيد تقديم وإرسال المقطع",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ==================== Submissions Screen ====================
class SubmissionsScreen extends StatelessWidget {
  const SubmissionsScreen({super.key});

  Color _getStatusColor(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.pending:
        return AppColors.warning;
      case SubmissionStatus.approved:
        return AppColors.success;
      case SubmissionStatus.rejected:
        return AppColors.error;
      case SubmissionStatus.paid:
        return AppColors.accent;
    }
  }

  String _getStatusText(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.pending:
        return "قيد المراجعة";
      case SubmissionStatus.approved:
        return "تمت الموافقة";
      case SubmissionStatus.rejected:
        return "مرفوض";
      case SubmissionStatus.paid:
        return "تم الدفع";
    }
  }

  IconData _getStatusIcon(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.pending:
        return Icons.hourglass_empty;
      case SubmissionStatus.approved:
        return Icons.check_circle;
      case SubmissionStatus.rejected:
        return Icons.cancel;
      case SubmissionStatus.paid:
        return Icons.paid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تقديماتي"),
      ),
      body: MockData.submissions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: AppColors.textMuted),
                  SizedBox(height: 16),
                  Text(
                    "لم تقم بأي تقديمات بعد",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "استكشف الحملات وابدأ بإنشاء محتوى",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.submissions.length,
              itemBuilder: (context, index) {
                final submission = MockData.submissions[index];
                final campaign = MockData.campaigns.firstWhere(
                  (c) => c.id == submission.campaignId,
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              campaign.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(submission.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getStatusColor(submission.status).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStatusIcon(submission.status),
                                  size: 14,
                                  color: _getStatusColor(submission.status),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getStatusText(submission.status),
                                  style: TextStyle(
                                    color: _getStatusColor(submission.status),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        submission.caption,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.link, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              submission.url,
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (submission.earnings != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "الأرباح",
                                style: TextStyle(color: AppColors.success, fontSize: 14),
                              ),
                              Text(
                                "\$${submission.earnings!.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        "تم التقديم: ${_formatDate(submission.submittedAt)}",
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return "منذ ${diff.inDays} يوم";
    if (diff.inHours > 0) return "منذ ${diff.inHours} ساعة";
    if (diff.inMinutes > 0) return "منذ ${diff.inMinutes} دقيقة";
    return "الآن";
  }
}

// ==================== Earnings Screen ====================
class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("الأرباح"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "الرصيد الحالي",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${user.balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "سحب الأرباح",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Grid
            const Text(
              "إحصائياتك",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "إجمالي الأرباح",
                    "\$${user.totalEarnings.toStringAsFixed(0)}",
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "التقديمات",
                    "${user.totalSubmissions}",
                    Icons.assignment,
                    AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "المعتمدة",
                    "${user.approvedSubmissions}",
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "نسبة النجاح",
                    "${user.totalSubmissions > 0 ? ((user.approvedSubmissions / user.totalSubmissions) * 100).toStringAsFixed(0) : 0}%",
                    Icons.percent,
                    AppColors.warning,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Earnings
            const Text(
              "آخر الأرباح",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...MockData.submissions.where((s) => s.earnings != null).map((submission) {
              final campaign = MockData.campaigns.firstWhere((c) => c.id == submission.campaignId);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.paid, color: AppColors.success),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campaign.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(submission.submittedAt),
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "+\$${submission.earnings!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return "منذ ${diff.inDays} يوم";
    if (diff.inHours > 0) return "منذ ${diff.inHours} ساعة";
    return "منذ قليل";
  }
}

// ==================== Profile Screen ====================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("حسابي"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withOpacity(0.3),
                          AppColors.accentDark.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        user.avatar,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileStat("التقديمات", "${user.totalSubmissions}"),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                      _buildProfileStat("المعتمدة", "${user.approvedSubmissions}"),
                      Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                      _buildProfileStat("الأرباح", "\$${user.totalEarnings.toStringAsFixed(0)}"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Items
            _buildMenuItem(
              icon: Icons.account_circle,
              title: "تعديل الملف الشخصي",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.payment,
              title: "طرق الدفع",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.notifications,
              title: "الإشعارات",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.help,
              title: "المساعدة والدعم",
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: "عن التطبيق",
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  foregroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                },
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 16),
        onTap: onTap,
      ),
    );
  }
}
