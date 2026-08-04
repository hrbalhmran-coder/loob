import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
//  STORAGE SERVICE
// ============================================================
class StorageService {
  static SharedPreferences? _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance => _prefs!;
}

// ============================================================
//  MODELS
// ============================================================
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
  String get formattedDeadline {
    final diff = deadline.difference(DateTime.now());
    if (diff.inDays > 0) return "${diff.inDays} يوم متبقي";
    if (diff.inHours > 0) return "${diff.inHours} ساعة متبقية";
    return "تنتهي قريباً";
  }
}

enum SubmissionStatus { pending, approved, rejected, paid }

class Submission {
  String id;
  String campaignId;
  String url;
  String caption;
  DateTime submittedAt;
  SubmissionStatus status;
  double? earnings;
  int? views;

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'campaignId': campaignId,
        'url': url,
        'caption': caption,
        'submittedAt': submittedAt.toIso8601String(),
        'status': status.index,
        'earnings': earnings,
        'views': views,
      };

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
        id: json['id'],
        campaignId: json['campaignId'],
        url: json['url'],
        caption: json['caption'],
        submittedAt: DateTime.parse(json['submittedAt']),
        status: SubmissionStatus.values[json['status']],
        earnings: json['earnings'],
        views: json['views'],
      );
}

class User {
  String id;
  String name;
  String email;
  String phone;
  String avatar;
  String bio;
  String country;
  String language;
  double balance;
  int totalSubmissions;
  int approvedSubmissions;
  double totalEarnings;
  bool isCreator;
  bool pushNotifications;
  bool emailNotifications;
  bool marketingEmails;
  String? paypalEmail;
  bool twoFactorEnabled;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    required this.avatar,
    this.bio = '',
    this.country = 'السعودية',
    this.language = 'العربية',
    this.balance = 0.0,
    this.totalSubmissions = 0,
    this.approvedSubmissions = 0,
    this.totalEarnings = 0.0,
    this.isCreator = false,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.marketingEmails = false,
    this.paypalEmail,
    this.twoFactorEnabled = false,
  });
}

class PaymentMethod {
  final String id;
  final String type;
  final String name;
  final String number;
  final bool isDefault;
  final String? expiryDate;
  final String? bankName;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    required this.number,
    this.isDefault = false,
    this.expiryDate,
    this.bankName,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;
  final String type;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    this.type = 'system',
  });
}

class ActivityLog {
  final String id;
  final String title;
  final String description;
  final DateTime time;
  final String type;

  ActivityLog({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}

// ============================================================
//  MOCK DATA
// ============================================================
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
      description:
          "شاركنا مقاطع ملهمة من بودكاست ريادة الأعمال العربي. نبحث عن محتوى أصيل يلامس قلوب المتابعين.",
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
      description:
          "انضم لتحدي تداول العملات الرقمية! أنشئ محتوى تعليمي وممتع عن عالم الكريبتو.",
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
      description:
          "تعلم أسرار المبيعات من خبير الإغلاق العالمي. أنشئ محتوى يحفز على التعلم والتطور.",
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
      description:
          "شاركنا أفضل لحظات دورة التسويق الرقمي. نبحث عن محتوى احترافي ومفيد.",
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

  static final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: "pm1",
      type: "card",
      name: "Visa",
      number: "**** **** **** 4582",
      isDefault: true,
      expiryDate: "09/27",
    ),
    PaymentMethod(
      id: "pm2",
      type: "bank",
      name: "الراجحي",
      number: "SA03 8000 0000 6080 1016 7519",
      bankName: "مصرف الراجحي",
    ),
    PaymentMethod(
      id: "pm3",
      type: "paypal",
      name: "PayPal",
      number: "mohamed.creator@email.com",
    ),
  ];
}

// ============================================================
//  APP CONTROLLER
// ============================================================
class AppController extends ChangeNotifier {
  static final AppController _instance = AppController._internal();
  factory AppController() => _instance;
  AppController._internal();

  User? _user;
  List<Submission> _submissions = [];
  List<AppNotification> _notifications = [];
  List<ActivityLog> _activityLogs = [];
  bool _isLoggedIn = false;
  bool _isLoading = true;

  User? get user => _user;
  List<Submission> get submissions => _submissions;
  List<AppNotification> get notifications => _notifications;
  List<ActivityLog> get activityLogs => _activityLogs;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await StorageService.init();
    await _loadUser();
    await _loadSubmissions();
    await _loadNotifications();
    await _loadActivityLogs();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUser() async {
    final p = StorageService.instance;
    final email = p.getString('user_email');
    if (email != null && email.isNotEmpty) {
      _user = User(
        id: p.getString('user_id') ?? 'user1',
        name: p.getString('user_name') ?? 'مستخدم',
        email: email,
        phone: p.getString('user_phone') ?? '',
        avatar: p.getString('user_avatar') ?? '👤',
        bio: p.getString('user_bio') ?? '',
        country: p.getString('user_country') ?? 'السعودية',
        language: p.getString('user_language') ?? 'العربية',
        balance: p.getDouble('user_balance') ?? 125.50,
        totalSubmissions: p.getInt('user_total_submissions') ?? 0,
        approvedSubmissions: p.getInt('user_approved_submissions') ?? 0,
        totalEarnings: p.getDouble('user_total_earnings') ?? 0.0,
        isCreator: p.getBool('user_is_creator') ?? false,
        pushNotifications: p.getBool('push_notifications') ?? true,
        emailNotifications: p.getBool('email_notifications') ?? true,
        marketingEmails: p.getBool('marketing_emails') ?? false,
        paypalEmail: p.getString('user_paypal_email'),
        twoFactorEnabled: p.getBool('two_factor_enabled') ?? false,
      );
      _isLoggedIn = true;
    }
  }

  Future<void> register(String name, String email, String password) async {
    final p = StorageService.instance;
    final id = 'user_${DateTime.now().millisecondsSinceEpoch}';
    await p.setString('user_id', id);
    await p.setString('user_name', name);
    await p.setString('user_email', email);
    await p.setString('user_password', password);
    await p.setString(
        'user_avatar', name.isNotEmpty ? name[0].toUpperCase() : '👤');
    await p.setDouble('user_balance', 0.0);
    await p.setInt('user_total_submissions', 0);
    await p.setInt('user_approved_submissions', 0);
    await p.setDouble('user_total_earnings', 0.0);

    await _loadUser();
    _addNotification(
      'أهلاً بك في Loob!',
      'تم إنشاء حسابك بنجاح. ابدأ باستكشاف الحملات وتحقيق الأرباح.',
      'system',
    );
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final p = StorageService.instance;
    final savedEmail = p.getString('user_email');
    final savedPassword = p.getString('user_password');
    if (savedEmail == email && savedPassword == password) {
      await _loadUser();
      _isLoggedIn = true;
      _addNotification(
        'تم تسجيل الدخول',
        'مرحباً بعودتك ${_user!.name}!',
        'system',
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final p = StorageService.instance;
    await p.setBool('is_logged_in', false);
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    final p = StorageService.instance;
    await p.clear();
    _user = null;
    _isLoggedIn = false;
    _submissions = [];
    _notifications = [];
    _activityLogs = [];
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? paypalEmail,
  }) async {
    if (_user == null) return;
    final p = StorageService.instance;
    if (name != null) {
      _user!.name = name;
      await p.setString('user_name', name);
    }
    if (email != null) {
      _user!.email = email;
      await p.setString('user_email', email);
    }
    if (phone != null) {
      _user!.phone = phone;
      await p.setString('user_phone', phone);
    }
    if (bio != null) {
      _user!.bio = bio;
      await p.setString('user_bio', bio);
    }
    if (paypalEmail != null) {
      _user!.paypalEmail = paypalEmail;
      await p.setString('user_paypal_email', paypalEmail);
    }
    notifyListeners();
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final p = StorageService.instance;
    final saved = p.getString('user_password');
    if (saved != currentPassword)
      throw Exception('كلمة المرور الحالية غير صحيحة');
    await p.setString('user_password', newPassword);
  }

  Future<void> updateSettings({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? marketingEmails,
    bool? twoFactorEnabled,
    String? language,
    String? country,
  }) async {
    if (_user == null) return;
    final p = StorageService.instance;
    if (pushNotifications != null) {
      _user!.pushNotifications = pushNotifications;
      await p.setBool('push_notifications', pushNotifications);
    }
    if (emailNotifications != null) {
      _user!.emailNotifications = emailNotifications;
      await p.setBool('email_notifications', emailNotifications);
    }
    if (marketingEmails != null) {
      _user!.marketingEmails = marketingEmails;
      await p.setBool('marketing_emails', marketingEmails);
    }
    if (twoFactorEnabled != null) {
      _user!.twoFactorEnabled = twoFactorEnabled;
      await p.setBool('two_factor_enabled', twoFactorEnabled);
    }
    if (language != null) {
      _user!.language = language;
      await p.setString('user_language', language);
    }
    if (country != null) {
      _user!.country = country;
      await p.setString('user_country', country);
    }
    notifyListeners();
  }

  Future<void> addSubmission(Submission submission) async {
    _submissions.insert(0, submission);
    await _saveSubmissions();
    if (_user != null) {
      _user!.totalSubmissions++;
      await StorageService.instance
          .setInt('user_total_submissions', _user!.totalSubmissions);
    }
    final campaign =
        MockData.campaigns.firstWhere((c) => c.id == submission.campaignId);
    _addNotification(
      'تم استلام مقطعك!',
      'تم استلام مقطعك في حملة "${campaign.title}" وهو قيد المراجعة.',
      'submission',
    );
    _addActivityLog(
      'تقديم جديد',
      'قدمت مقطعاً في حملة "${campaign.title}"',
      'submission',
    );
    notifyListeners();
  }

  Future<void> _saveSubmissions() async {
    final p = StorageService.instance;
    final list = _submissions.map((s) => jsonEncode(s.toJson())).toList();
    await p.setStringList('submissions', list);
  }

  Future<void> _loadSubmissions() async {
    final p = StorageService.instance;
    final list = p.getStringList('submissions') ?? [];
    _submissions = list.map((s) => Submission.fromJson(jsonDecode(s))).toList();
  }

  Future<void> approveSubmission(String submissionId, double earnings) async {
    final sub = _submissions.firstWhere((s) => s.id == submissionId);
    sub.status = SubmissionStatus.approved;
    sub.earnings = earnings;
    await _saveSubmissions();
    if (_user != null) {
      _user!.approvedSubmissions++;
      _user!.totalEarnings += earnings;
      _user!.balance += earnings;
      final p = StorageService.instance;
      await p.setInt('user_approved_submissions', _user!.approvedSubmissions);
      await p.setDouble('user_total_earnings', _user!.totalEarnings);
      await p.setDouble('user_balance', _user!.balance);
    }
    _addNotification(
      'تمت الموافقة على مقطعك!',
      'تمت مراجعة مقطعك وتمت الموافقة عليه. أرباحك: \$${earnings.toStringAsFixed(2)}',
      'submission',
    );
    _addActivityLog(
      'موافقة على تقديم',
      'تمت الموافقة على مقطعك بأرباح \$${earnings.toStringAsFixed(2)}',
      'payment',
    );
    notifyListeners();
  }

  Future<void> withdraw(double amount, String methodId) async {
    if (_user == null || _user!.balance < amount)
      throw Exception('رصيد غير كافٍ');
    _user!.balance -= amount;
    await StorageService.instance.setDouble('user_balance', _user!.balance);
    _addNotification(
      'تم إرسال طلب السحب',
      'تم إرسال طلب سحب بمبلغ \$${amount.toStringAsFixed(2)} وسيتم المعالجة خلال 3-5 أيام.',
      'payment',
    );
    _addActivityLog(
      'طلب سحب',
      'طلبت سحب \$${amount.toStringAsFixed(2)}',
      'payment',
    );
    notifyListeners();
  }

  void _addNotification(String title, String body, String type) {
    _notifications.insert(
        0,
        AppNotification(
          id: 'n${_notifications.length + DateTime.now().millisecondsSinceEpoch}',
          title: title,
          body: body,
          time: DateTime.now(),
          type: type,
        ));
    _saveNotifications();
  }

  Future<void> _saveNotifications() async {
    final p = StorageService.instance;
    final list = _notifications
        .map((n) => jsonEncode({
              'id': n.id,
              'title': n.title,
              'body': n.body,
              'time': n.time.toIso8601String(),
              'isRead': n.isRead,
              'type': n.type,
            }))
        .toList();
    await p.setStringList('notifications', list);
  }

  Future<void> _loadNotifications() async {
    final p = StorageService.instance;
    final list = p.getStringList('notifications') ?? [];
    if (list.isNotEmpty) {
      _notifications = list.map((s) {
        final j = jsonDecode(s);
        return AppNotification(
          id: j['id'],
          title: j['title'],
          body: j['body'],
          time: DateTime.parse(j['time']),
          isRead: j['isRead'],
          type: j['type'],
        );
      }).toList();
    } else {
      _notifications = [
        AppNotification(
          id: "n1",
          title: "تمت الموافقة على مقطعك!",
          body:
              "تمت مراجعة مقطعك في حملة 'بودكاست ريادة الأعمال العربي' وتمت الموافقة عليه. أرباحك: \$45.00",
          time: DateTime.now().subtract(const Duration(minutes: 15)),
          type: "submission",
        ),
        AppNotification(
          id: "n2",
          title: "تم إيداع الأرباح",
          body: "تم إيداع مبلغ \$120.00 في رصيدك من حملة 'أسرار المبيعات'",
          time: DateTime.now().subtract(const Duration(hours: 2)),
          type: "payment",
        ),
        AppNotification(
          id: "n3",
          title: "حملة جديدة متاحة!",
          body: "انضم الآن لحملة 'دورة التسويق الرقمي المتقدم' مع محمد العريفي",
          time: DateTime.now().subtract(const Duration(hours: 5)),
          type: "campaign",
        ),
      ];
    }
  }

  Future<void> markAllNotificationsRead() async {
    for (final n in _notifications) n.isRead = true;
    await _saveNotifications();
    notifyListeners();
  }

  Future<void> clearNotifications() async {
    _notifications = [];
    await _saveNotifications();
    notifyListeners();
  }

  void _addActivityLog(String title, String description, String type) {
    _activityLogs.insert(
        0,
        ActivityLog(
          id: 'log${_activityLogs.length + DateTime.now().millisecondsSinceEpoch}',
          title: title,
          description: description,
          time: DateTime.now(),
          type: type,
        ));
    _saveActivityLogs();
  }

  Future<void> _saveActivityLogs() async {
    final p = StorageService.instance;
    final list = _activityLogs
        .map((a) => jsonEncode({
              'id': a.id,
              'title': a.title,
              'description': a.description,
              'time': a.time.toIso8601String(),
              'type': a.type,
            }))
        .toList();
    await p.setStringList('activity_logs', list);
  }

  Future<void> _loadActivityLogs() async {
    final p = StorageService.instance;
    final list = p.getStringList('activity_logs') ?? [];
    _activityLogs = list.map((s) {
      final j = jsonDecode(s);
      return ActivityLog(
        id: j['id'],
        title: j['title'],
        description: j['description'],
        time: DateTime.parse(j['time']),
        type: j['type'],
      );
    }).toList();
  }
}

// ============================================================
//  APP PROVIDER (FIXED - supports listen parameter)
// ============================================================
class AppProvider extends InheritedNotifier<AppController> {
  const AppProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AppController of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<AppProvider>()!
          .notifier!;
    } else {
      final widget = context
          .getElementForInheritedWidgetOfExactType<AppProvider>()
          ?.widget as AppProvider?;
      return widget!.notifier!;
    }
  }
}

// ============================================================
//  THEME & COLORS
// ============================================================
class AppColors {
  static const Color background = Color(0xFF0F0F1A);
  static const Color card = Color(0xFF161B2C);
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFF4E5C2);
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
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
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
        fillColor: AppColors.card.withOpacity(0.8),
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

// ============================================================
//  BACKGROUND WIDGETS
// ============================================================
class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.08,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.accentLight],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Loob',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.03),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.03),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// ============================================================
//  MAIN APP
// ============================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  final controller = AppController();
  await controller.initialize();
  runApp(AppProvider(notifier: controller, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppProvider.of(context);
    return MaterialApp(
      title: 'Loob - منصة المحتوى العربي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
            );
          }
          return controller.isLoggedIn
              ? const MainNavigationScreen()
              : const AuthScreen();
        },
      ),
    );
  }
}

// ============================================================
//  AUTH SCREEN
// ============================================================
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
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError("يرجى ملء جميع الحقول المطلوبة");
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError("يرجى إدخال بريد إلكتروني صالح");
      return;
    }
    if (password.length < 6) {
      _showError("يجب أن تكون كلمة المرور 6 أحرف على الأقل");
      return;
    }

    if (!isLogin) {
      if (name.isEmpty) {
        _showError("يرجى إدخال اسم المستخدم");
        return;
      }
      if (password != confirm) {
        _showError("كلمتا المرور غير متطابقتين");
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final controller = AppProvider.of(context);
      if (isLogin) {
        final success = await controller.login(email, password);
        if (!success) {
          _showError("البريد الإلكتروني أو كلمة المرور غير صحيحة");
        }
      } else {
        await controller.register(name, email, password);
      }
    } catch (e) {
      _showError("حدث خطأ: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentLight],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'L',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Loob",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(
                        color: AppColors.accent.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "منصة المحتوى العربي",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 48),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card.withOpacity(0.8),
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
                              color: isLogin
                                  ? AppColors.surface.withOpacity(0.9)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "تسجيل الدخول",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isLogin
                                    ? Colors.white
                                    : AppColors.textMuted,
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
                              color: !isLogin
                                  ? AppColors.surface.withOpacity(0.9)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "إنشاء حساب",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isLogin
                                    ? Colors.white
                                    : AppColors.textMuted,
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
                if (!isLogin)
                  _buildTextField(
                    controller: _nameController,
                    hint: "الاسم الكامل",
                    prefix: "👤 ",
                  ),
                if (!isLogin) const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  hint: "البريد الإلكتروني",
                  prefix: "📧 ",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hint: "كلمة المرور",
                  prefix: "🔒 ",
                  obscureText: _obscurePassword,
                  suffix: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Text(
                      _obscurePassword ? "👁️" : "🙈",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                if (!isLogin) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hint: "تأكيد كلمة المرور",
                    prefix: "🔒 ",
                    obscureText: _obscureConfirm,
                    suffix: GestureDetector(
                      onTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Text(
                        _obscureConfirm ? "👁️" : "🙈",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoading ? null : _handleAuth,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black),
                          )
                        : Text(
                            isLogin ? "تسجيل الدخول" : "إنشاء حساب",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                if (isLogin)
                  TextButton(
                    onPressed: () {
                      _showForgotPasswordDialog();
                    },
                    child: const Text(
                      "نسيت كلمة المرور؟",
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('استعادة كلمة المرور',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: emailCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'أدخل بريدك الإلكتروني',
            hintStyle: TextStyle(color: AppColors.textMuted),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('📧 تم إرسال رابط استعادة كلمة المرور إلى بريدك'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String prefix,
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
        fillColor: AppColors.card.withOpacity(0.8),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(prefix, style: const TextStyle(fontSize: 20)),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 44, minHeight: 44),
        suffixIcon: suffix != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: suffix,
              )
            : null,
        suffixIconConstraints:
            const BoxConstraints(minWidth: 44, minHeight: 44),
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

// ============================================================
//  MAIN NAVIGATION
// ============================================================
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

  final List<String> _labels = ["استكشاف", "تقديماتي", "الأرباح", "حسابي"];
  final List<String> _icons = ["🧭", "📋", "💰", "👤"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card.withOpacity(0.95),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _icons[index],
                        style: TextStyle(
                          fontSize: 24,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _labels[index],
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textMuted,
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  EXPLORE CAMPAIGNS SCREEN
// ============================================================
class ExploreCampaignsScreen extends StatefulWidget {
  const ExploreCampaignsScreen({super.key});

  @override
  State<ExploreCampaignsScreen> createState() => _ExploreCampaignsScreenState();
}

class _ExploreCampaignsScreenState extends State<ExploreCampaignsScreen> {
  String _searchQuery = "";
  String _selectedCategory = "الكل";
  final List<String> _categories = [
    "الكل",
    "بودكاست",
    "تداول",
    "تطوير ذاتي",
    "تسويق"
  ];

  List<Campaign> get _filteredCampaigns {
    return MockData.campaigns.where((campaign) {
      final matchesSearch = campaign.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          campaign.creator.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "الكل" || campaign.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppProvider.of(context);
    final unreadCount = controller.notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("استكشف الحملات"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Text("🔔", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen()));
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.card.withOpacity(0.8),
                hintText: "🔍 ابحث عن حملة أو منشئ...",
                hintStyle: const TextStyle(color: AppColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
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
                    onSelected: (_) =>
                        setState(() => _selectedCategory = category),
                    backgroundColor: AppColors.card.withOpacity(0.8),
                    selectedColor: AppColors.accent.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                            isSelected ? AppColors.accent : Colors.transparent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _filteredCampaigns.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("🔍", style: TextStyle(fontSize: 64)),
                        SizedBox(height: 16),
                        Text(
                          "لا توجد حملات مطابقة",
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 16),
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
        color: AppColors.card.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentLight],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      campaign.creatorAvatar,
                      style: const TextStyle(
                        color: Colors.black,
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
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.accent.withOpacity(0.3)),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStat("👁️", "${campaign.views}", "مشاهدة"),
                const SizedBox(width: 16),
                _buildStat("⭐", "${campaign.rating}", "تقييم"),
                const SizedBox(width: 16),
                _buildStat("⏰", campaign.formattedDeadline, "متبقي"),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                    Text(
                      "${(campaign.progress * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: campaign.progress,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CampaignDetailsScreen(campaign: campaign),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "عرض الشروط والتفاصيل",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(width: 8),
                    Text("→", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String emoji, String value, String label) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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

// ============================================================
//  CAMPAIGN DETAILS SCREEN
// ============================================================
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
    return uri != null &&
        (uri.host.contains('tiktok') || uri.host.contains('instagram'));
  }

  void _submitClip() async {
    if (_urlController.text.isEmpty || _captionController.text.isEmpty) {
      _showSnackBar("⚠️ برجاء ملء حقل الرابط وحقل الوصف", AppColors.warning);
      return;
    }

    if (!_isValidUrl(_urlController.text)) {
      _showSnackBar("⚠️ الرابط غير صالح. يجب أن يكون رابط TikTok أو Instagram",
          AppColors.error);
      return;
    }

    if (!_agreedToRules) {
      _showSnackBar("⚠️ يجب الموافقة على الشروط أولاً", AppColors.warning);
      return;
    }

    if (!_captionController.text.contains(widget.campaign.targetTag)) {
      _showSnackBar("⚠️ يجب إضافة التاغ ${widget.campaign.targetTag} في الوصف",
          AppColors.warning);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    final controller = AppProvider.of(context);
    final submission = Submission(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      campaignId: widget.campaign.id,
      url: _urlController.text.trim(),
      caption: _captionController.text.trim(),
      submittedAt: DateTime.now(),
      status: SubmissionStatus.pending,
    );

    await controller.addSubmission(submission);

    if (mounted) {
      setState(() => _isLoading = false);
      _showSnackBar("🚀 تم إرسال المقطع بنجاح! سيتم مراجعته خلال 24 ساعة",
          AppColors.success);
      _urlController.clear();
      _captionController.clear();
      setState(() => _agreedToRules = false);
    }
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("تفاصيل الحملة"),
        leading: IconButton(
          icon: const Text("←",
              style: TextStyle(color: Colors.white, fontSize: 24)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.9),
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
                            gradient: const LinearGradient(
                              colors: [AppColors.accent, AppColors.accentLight],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              widget.campaign.creatorAvatar,
                              style: const TextStyle(
                                color: Colors.black,
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
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.campaign.description,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.accent.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text("🏷️", style: TextStyle(fontSize: 20)),
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
              const Text(
                "القوانين والشروط الأساسية",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.9),
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
                            child:
                                const Text("✅", style: TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              rule,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "تقديم المقطع",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background.withOpacity(0.5),
                        hintText: "🔗 صق رابط مقطع الـ Reels أو TikTok هنا",
                        hintStyle: const TextStyle(color: AppColors.textMuted),
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
                        fillColor: AppColors.background.withOpacity(0.5),
                        hintText:
                            "📝 اكتب أو صق الوصف (Caption) الذي استخدمته في الفيديو كاملاً",
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToRules,
                          onChanged: (value) =>
                              setState(() => _agreedToRules = value ?? false),
                          activeColor: AppColors.accent,
                          checkColor: Colors.black,
                        ),
                        const Expanded(
                          child: Text(
                            "أقر بأنني قرأت جميع الشروط ووافقت عليها",
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 13),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          disabledBackgroundColor:
                              AppColors.accent.withOpacity(0.3),
                        ),
                        onPressed: _isLoading ? null : _submitClip,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.black),
                              )
                            : const Text(
                                "تأكيد تقديم وإرسال المقطع",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
      ),
    );
  }
}

// ============================================================
//  SUBMISSIONS SCREEN
// ============================================================
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

  String _getStatusEmoji(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.pending:
        return "⏳";
      case SubmissionStatus.approved:
        return "✅";
      case SubmissionStatus.rejected:
        return "❌";
      case SubmissionStatus.paid:
        return "💵";
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return "منذ ${diff.inDays} يوم";
    if (diff.inHours > 0) return "منذ ${diff.inHours} ساعة";
    if (diff.inMinutes > 0) return "منذ ${diff.inMinutes} دقيقة";
    return "الآن";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final controller = AppProvider.of(context);
        final submissions = controller.submissions;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("تقديماتي"),
          ),
          body: submissions.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("📋", style: TextStyle(fontSize: 64)),
                      SizedBox(height: 16),
                      Text(
                        "لم تقم بأي تقديمات بعد",
                        style:
                            TextStyle(color: AppColors.textMuted, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "استكشف الحملات وابدأ بإنشاء محتوى",
                        style:
                            TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: submissions.length,
                  itemBuilder: (context, index) {
                    final submission = submissions[index];
                    final campaign = MockData.campaigns.firstWhere(
                      (c) => c.id == submission.campaignId,
                      orElse: () => MockData.campaigns[0],
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.05)),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(submission.status)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _getStatusColor(submission.status)
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _getStatusEmoji(submission.status),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getStatusText(submission.status),
                                      style: TextStyle(
                                        color:
                                            _getStatusColor(submission.status),
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
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text("🔗 ", style: TextStyle(fontSize: 14)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "الأرباح",
                                    style: TextStyle(
                                        color: AppColors.success, fontSize: 14),
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
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

// ============================================================
//  EARNINGS SCREEN
// ============================================================
class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return "منذ ${diff.inDays} يوم";
    if (diff.inHours > 0) return "منذ ${diff.inHours} ساعة";
    return "منذ قليل";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final controller = AppProvider.of(context);
        final user = controller.user!;
        final approvedSubs = controller.submissions
            .where((s) =>
                s.status == SubmissionStatus.approved ||
                s.status == SubmissionStatus.paid)
            .toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("الأرباح"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentLight],
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const WithdrawScreen()));
                              },
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
                const Text(
                  "إحصائياتك",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "إجمالي الأرباح",
                        "\$${user.totalEarnings.toStringAsFixed(0)}",
                        "📈",
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "التقديمات",
                        "${user.totalSubmissions}",
                        "📋",
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
                        "✅",
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        "نسبة النجاح",
                        "${user.totalSubmissions > 0 ? ((user.approvedSubmissions / user.totalSubmissions) * 100).toStringAsFixed(0) : 0}%",
                        "📊",
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "آخر الأرباح",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (approvedSubs.isEmpty)
                  const Center(
                    child: Text(
                      "لا توجد أرباح بعد",
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  )
                else
                  ...approvedSubs.map((submission) {
                    final campaign = MockData.campaigns.firstWhere(
                      (c) => c.id == submission.campaignId,
                      orElse: () => MockData.campaigns[0],
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card.withOpacity(0.9),
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
                            child: const Text("💰",
                                style: TextStyle(fontSize: 24)),
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
                                  style: const TextStyle(
                                      color: AppColors.textMuted, fontSize: 12),
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
      },
    );
  }

  Widget _buildStatCard(String title, String value, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
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
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  PROFILE SCREEN
// ============================================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final controller = AppProvider.of(context);
        final user = controller.user!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("حسابي"),
            actions: [
              IconButton(
                icon: const Text("⚙️", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.card.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.accentLight],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            user.avatar,
                            style: const TextStyle(
                              color: Colors.black,
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
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildProfileStat(
                              "التقديمات", "${user.totalSubmissions}"),
                          Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withOpacity(0.1)),
                          _buildProfileStat(
                              "المعتمدة", "${user.approvedSubmissions}"),
                          Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withOpacity(0.1)),
                          _buildProfileStat("الأرباح",
                              "\$${user.totalEarnings.toStringAsFixed(0)}"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildMenuItem(
                  emoji: "👤",
                  title: "تعديل الملف الشخصي",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EditProfileScreen()));
                  },
                ),
                _buildMenuItem(
                  emoji: "💳",
                  title: "طرق الدفع",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PaymentMethodsScreen()));
                  },
                ),
                _buildMenuItem(
                  emoji: "🔔",
                  title: "الإشعارات",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationsScreen()));
                  },
                ),
                _buildMenuItem(
                  emoji: "⚙️",
                  title: "الإعدادات",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()));
                  },
                ),
                _buildMenuItem(
                  emoji: "❓",
                  title: "المساعدة والدعم",
                  onTap: () {},
                ),
                _buildMenuItem(
                  emoji: "ℹ️",
                  title: "عن التطبيق",
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withOpacity(0.1),
                      foregroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await controller.logout();
                    },
                    child: const Text(
                      "تسجيل الخروج",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    required String emoji,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 24)),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        trailing: const Text("→",
            style: TextStyle(color: AppColors.textMuted, fontSize: 20)),
        onTap: onTap,
      ),
    );
  }
}

// ============================================================
//  NOTIFICATIONS SCREEN
// ============================================================
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'all';

  List<AppNotification> _getFilteredNotifications(AppController controller) {
    if (_filter == 'all') return controller.notifications;
    if (_filter == 'unread')
      return controller.notifications.where((n) => !n.isRead).toList();
    return controller.notifications.where((n) => n.type == _filter).toList();
  }

  String _getNotificationIcon(String type) {
    switch (type) {
      case 'submission':
        return '📋';
      case 'payment':
        return '💰';
      case 'campaign':
        return '🎯';
      case 'system':
        return '⚙️';
      default:
        return '📢';
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'submission':
        return AppColors.accent;
      case 'payment':
        return AppColors.success;
      case 'campaign':
        return AppColors.warning;
      case 'system':
        return AppColors.textSecondary;
      default:
        return AppColors.accent;
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return 'منذ ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعة';
    if (diff.inMinutes > 0) return 'منذ ${diff.inMinutes} دقيقة';
    return 'الآن';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final controller = AppProvider.of(context);
        final filtered = _getFilteredNotifications(controller);

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('الإشعارات'),
            actions: [
              TextButton(
                onPressed: () => controller.markAllNotificationsRead(),
                child: const Text('تحديد الكل مقروء',
                    style: TextStyle(color: AppColors.accent, fontSize: 12)),
              ),
              IconButton(
                icon: const Text('🗑️', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.card,
                      title: const Text('مسح الإشعارات',
                          style: TextStyle(color: Colors.white)),
                      content: const Text('هل أنت متأكد من مسح جميع الإشعارات؟',
                          style: TextStyle(color: AppColors.textSecondary)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('إلغاء',
                              style: TextStyle(color: AppColors.textMuted)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            controller.clearNotifications();
                            Navigator.pop(ctx);
                          },
                          child: const Text('مسح'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip('all', 'الكل'),
                    _buildFilterChip('unread', 'غير مقروء'),
                    _buildFilterChip('submission', 'تقديمات'),
                    _buildFilterChip('payment', 'مدفوعات'),
                    _buildFilterChip('campaign', 'حملات'),
                    _buildFilterChip('system', 'نظام'),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🔔', style: TextStyle(fontSize: 64)),
                            SizedBox(height: 16),
                            Text('لا توجد إشعارات',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final notif = filtered[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() => notif.isRead = true);
                              controller.markAllNotificationsRead();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.card.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                border: !notif.isRead
                                    ? Border.all(
                                        color:
                                            AppColors.accent.withOpacity(0.3),
                                        width: 1)
                                    : null,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getNotificationColor(notif.type)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                          _getNotificationIcon(notif.type),
                                          style: const TextStyle(fontSize: 24)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notif.title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: notif.isRead
                                                      ? FontWeight.normal
                                                      : FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            if (!notif.isRead)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.accent,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          notif.body,
                                          style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 13,
                                              height: 1.4),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _formatTime(notif.time),
                                          style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _filter = value),
        backgroundColor: AppColors.card.withOpacity(0.8),
        selectedColor: AppColors.accent.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isSelected ? AppColors.accent : Colors.transparent),
        ),
      ),
    );
  }
}

// ============================================================
//  EDIT PROFILE SCREEN
// ============================================================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _paypalController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = AppProvider.of(context, listen: false).user!;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _bioController = TextEditingController(text: user.bio);
    _paypalController = TextEditingController(text: user.paypalEmail ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _paypalController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      _showError('يرجى ملء الحقول المطلوبة');
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text)) {
      _showError('يرجى إدخال بريد إلكتروني صالح');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    await AppProvider.of(context, listen: false).updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      bio: _bioController.text.trim(),
      paypalEmail: _paypalController.text.trim().isEmpty
          ? null
          : _paypalController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم حفظ التغييرات بنجاح'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final user = AppProvider.of(context).user!;
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('تعديل الملف الشخصي'),
          ),
          body: AppBackground(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.accent, AppColors.accentLight],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              user.avatar,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text('تغيير الصورة',
                              style: TextStyle(
                                  color: AppColors.accent, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('المعلومات الأساسية'),
                  _buildTextField(
                      controller: _nameController,
                      label: 'الاسم الكامل *',
                      icon: '👤'),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني *',
                      icon: '📧',
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف',
                      icon: '📱',
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 24),
                  _buildSectionTitle('نبذة عنك'),
                  _buildTextField(
                      controller: _bioController,
                      label: 'السيرة الذاتية',
                      icon: '📝',
                      maxLines: 4),
                  const SizedBox(height: 24),
                  _buildSectionTitle('معلومات الدفع'),
                  _buildTextField(
                      controller: _paypalController,
                      label: 'بريد PayPal (للدفع)',
                      icon: '💳',
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _saveProfile,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black))
                          : const Text('حفظ التغييرات',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(title,
            style: const TextStyle(
                color: AppColors.accent,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.card.withOpacity(0.8),
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 44, minHeight: 44),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.accent, width: 1)),
      ),
    );
  }
}

// ============================================================
//  PAYMENT METHODS SCREEN
// ============================================================
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  void _showAddPaymentDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إضافة طريقة دفع جديدة',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildPaymentOption('💳', 'بطاقة ائتمانية (Visa/Mastercard)', () {
                Navigator.pop(context);
                _showCardForm();
              }),
              _buildPaymentOption('🏦', 'حساب بنكي', () {
                Navigator.pop(context);
                _showBankForm();
              }),
              _buildPaymentOption('🅿️', 'PayPal', () {
                Navigator.pop(context);
                _showPaypalForm();
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Text('→',
          style: TextStyle(color: AppColors.textMuted, fontSize: 20)),
      onTap: onTap,
    );
  }

  void _showCardForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('إضافة بطاقة', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField('رقم البطاقة'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildDialogTextField('MM/YY')),
                const SizedBox(width: 12),
                Expanded(child: _buildDialogTextField('CVV')),
              ],
            ),
            const SizedBox(height: 12),
            _buildDialogTextField('الاسم على البطاقة'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('✅ تم إضافة البطاقة بنجاح'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showBankForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('إضافة حساب بنكي',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField('اسم البنك'),
            const SizedBox(height: 12),
            _buildDialogTextField('رقم IBAN'),
            const SizedBox(height: 12),
            _buildDialogTextField('اسم صاحب الحساب'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('✅ تم إضافة الحساب البنكي بنجاح'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showPaypalForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title:
            const Text('إضافة PayPal', style: TextStyle(color: Colors.white)),
        content: _buildDialogTextField('بريد PayPal'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('✅ تم ربط PayPal بنجاح'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background.withOpacity(0.5),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      ),
    );
  }

  String _getCardIcon(String type) {
    switch (type) {
      case 'visa':
        return '💳';
      case 'mastercard':
        return '💳';
      case 'bank':
        return '🏦';
      case 'paypal':
        return '🅿️';
      default:
        return '💳';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('طرق الدفع'),
      ),
      body: AppBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: MockData.paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = MockData.paymentMethods[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: method.isDefault
                          ? Border.all(
                              color: AppColors.accent.withOpacity(0.5),
                              width: 2)
                          : Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(_getCardIcon(method.type),
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  if (method.bankName != null)
                                    Text(method.bankName!,
                                        style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12)),
                                ],
                              ),
                            ),
                            if (method.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'افتراضي',
                                  style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          method.number,
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              letterSpacing: 2),
                        ),
                        if (method.expiryDate != null &&
                            method.expiryDate!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('تنتهي: ${method.expiryDate}',
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 12)),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('تعديل',
                                  style: TextStyle(
                                      color: AppColors.accent, fontSize: 13)),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('حذف',
                                  style: TextStyle(
                                      color: AppColors.error, fontSize: 13)),
                            ),
                            if (!method.isDefault)
                              TextButton(
                                onPressed: () {},
                                child: const Text('تعيين افتراضي',
                                    style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 13)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showAddPaymentDialog,
                  child: const Text('+ إضافة طريقة دفع',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  WITHDRAW SCREEN
// ============================================================
class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedMethodId;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _withdraw() async {
    if (_amountController.text.isEmpty || _selectedMethodId == null) {
      _showError('يرجى إدخال المبلغ واختيار طريقة الدفع');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('المبلغ غير صالح');
      return;
    }

    final controller = AppProvider.of(context, listen: false);
    if (amount > controller.user!.balance) {
      _showError('المبلغ يتجاوز الرصيد المتاح');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      await controller.withdraw(amount, _selectedMethodId!);
      if (mounted) {
        _showSuccess(
            '✅ تم إرسال طلب السحب بمبلغ \$${amount.toStringAsFixed(2)}. سيتم المعالجة خلال 3-5 أيام عمل.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final controller = AppProvider.of(context);
        final user = controller.user!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('سحب الأرباح'),
          ),
          body: AppBackground(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.accentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('الرصيد المتاح للسحب',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          '\$${user.balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('المبلغ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.card.withOpacity(0.8),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('\$',
                            style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 60, minHeight: 60),
                      hintText: '0.00',
                      hintStyle: const TextStyle(
                          color: AppColors.textMuted, fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.accent, width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _amountController.text =
                              user.balance.toStringAsFixed(2);
                        },
                        child: const Text('سحب الكل',
                            style: TextStyle(
                                color: AppColors.accent, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('طريقة الدفع',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...MockData.paymentMethods.map((method) {
                    final isSelected = _selectedMethodId == method.id ||
                        (_selectedMethodId == null && method.isDefault);
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedMethodId = method.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withOpacity(0.1)
                              : AppColors.card.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.white.withOpacity(0.05),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              method.type == 'bank'
                                  ? '🏦'
                                  : (method.type == 'paypal' ? '🅿️' : '💳'),
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(method.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Text(method.number,
                                      style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.black, size: 16),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _withdraw,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black))
                          : const Text('تأكيد السحب',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      '⚠️ قد تستغرق عملية السحب 3-5 أيام عمل',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
//  SETTINGS SCREEN (100% Interactive)
// ============================================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚧 قريباً! هذه الميزة قيد التطوير'),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('تغيير كلمة المرور',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPasswordField(
                  'كلمة المرور الحالية',
                  currentCtrl,
                  obscureCurrent,
                  () => setDialogState(() => obscureCurrent = !obscureCurrent)),
              const SizedBox(height: 12),
              _buildPasswordField('كلمة المرور الجديدة', newCtrl, obscureNew,
                  () => setDialogState(() => obscureNew = !obscureNew)),
              const SizedBox(height: 12),
              _buildPasswordField(
                  'تأكيد كلمة المرور',
                  confirmCtrl,
                  obscureConfirm,
                  () => setDialogState(() => obscureConfirm = !obscureConfirm)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black),
              onPressed: () async {
                if (newCtrl.text != confirmCtrl.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('كلمتا المرور الجديدتان غير متطابقتين'),
                        backgroundColor: AppColors.error),
                  );
                  return;
                }
                if (newCtrl.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('يجب أن تكون كلمة المرور 6 أحرف على الأقل'),
                        backgroundColor: AppColors.error),
                  );
                  return;
                }
                try {
                  await AppProvider.of(context, listen: false)
                      .changePassword(currentCtrl.text, newCtrl.text);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('✅ تم تغيير كلمة المرور بنجاح'),
                        backgroundColor: AppColors.success),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: AppColors.error),
                  );
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller,
      bool obscure, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background.withOpacity(0.5),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        suffixIcon: IconButton(
          icon: Text(obscure ? "👁️" : "🙈",
              style: const TextStyle(fontSize: 18)),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['العربية', 'English'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('اختر اللغة', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang, style: const TextStyle(color: Colors.white)),
              trailing: AppProvider.of(context).user!.language == lang
                  ? const Icon(Icons.check, color: AppColors.accent)
                  : null,
              onTap: () async {
                await AppProvider.of(context, listen: false)
                    .updateSettings(language: lang);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('✅ تم تغيير اللغة إلى $lang'),
                      backgroundColor: AppColors.success),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCountryDialog() {
    final countries = [
      'السعودية',
      'الإمارات',
      'مصر',
      'الكويت',
      'قطر',
      'البحرين',
      'عمان',
      'الأردن',
      'المغرب',
      'تونس'
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('اختر البلد', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: countries.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(countries[index],
                    style: const TextStyle(color: Colors.white)),
                trailing:
                    AppProvider.of(context).user!.country == countries[index]
                        ? const Icon(Icons.check, color: AppColors.accent)
                        : null,
                onTap: () async {
                  await AppProvider.of(context, listen: false)
                      .updateSettings(country: countries[index]);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('✅ تم تغيير البلد إلى ${countries[index]}'),
                        backgroundColor: AppColors.success),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showActivityLog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ActivityLogScreen()),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title:
            const Text('حذف الحساب', style: TextStyle(color: AppColors.error)),
        content: const Text(
          'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء وستفقد جميع بياناتك وأرباحك.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            onPressed: () async {
              await AppProvider.of(context, listen: false).deleteAccount();
              Navigator.pop(ctx);
            },
            child: const Text('حذف نهائي'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final controller = AppProvider.of(context);
        final user = controller.user!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('الإعدادات'),
          ),
          body: AppBackground(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('🔔', 'الإشعارات'),
                  _buildSwitchTile(
                    'إشعارات الدفع',
                    'تلقي إشعارات عند الموافقة على مقطع أو الدفع',
                    user.pushNotifications,
                    (value) =>
                        controller.updateSettings(pushNotifications: value),
                  ),
                  _buildSwitchTile(
                    'إشعارات البريد الإلكتروني',
                    'تلقي تحديثات عبر البريد الإلكتروني',
                    user.emailNotifications,
                    (value) =>
                        controller.updateSettings(emailNotifications: value),
                  ),
                  _buildSwitchTile(
                    'عروض وتحديثات',
                    'استلام عروض حصرية وأخبار المنصة',
                    user.marketingEmails,
                    (value) =>
                        controller.updateSettings(marketingEmails: value),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('🔒', 'الأمان والخصوصية'),
                  _buildArrowTile('تغيير كلمة المرور', () {
                    _showChangePasswordDialog();
                  }),
                  _buildSwitchTile(
                    'المصادقة الثنائية (2FA)',
                    'تفعيل التحقق بخطوتين لتأمين حسابك',
                    user.twoFactorEnabled,
                    (value) =>
                        controller.updateSettings(twoFactorEnabled: value),
                  ),
                  _buildArrowTile('سجل النشاط', () {
                    _showActivityLog();
                  }),
                  const SizedBox(height: 24),
                  _buildSectionTitle('🌍', 'التفضيلات'),
                  _buildArrowTile('اللغة: ${user.language}', () {
                    _showLanguageDialog();
                  }),
                  _buildArrowTile('البلد: ${user.country}', () {
                    _showCountryDialog();
                  }),
                  const SizedBox(height: 24),
                  _buildSectionTitle('ℹ️', 'عن التطبيق'),
                  _buildInfoTile('الإصدار', 'v2.0.0'),
                  _buildInfoTile('آخر تحديث', '31 يوليو 2026'),
                  _buildArrowTile('شروط الاستخدام', () {}),
                  _buildArrowTile('سياسة الخصوصية', () {}),
                  _buildArrowTile('تواصل مع الدعم', () {}),
                  const SizedBox(height: 24),
                  _buildSectionTitle('⚠️', 'إدارة الحساب'),
                  _buildDangerTile('حذف الحساب نهائياً', () {
                    _showDeleteAccountDialog();
                  }),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error.withOpacity(0.1),
                        foregroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        await controller.logout();
                      },
                      child: const Text('تسجيل الخروج',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
        activeTrackColor: AppColors.accent.withOpacity(0.3),
        inactiveThumbColor: AppColors.textMuted,
        inactiveTrackColor: AppColors.textMuted.withOpacity(0.2),
      ),
    );
  }

  Widget _buildArrowTile(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Text('→',
            style: TextStyle(color: AppColors.textMuted, fontSize: 20)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildDangerTile(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: AppColors.error)),
        trailing: const Text('→',
            style: TextStyle(color: AppColors.error, fontSize: 20)),
        onTap: onTap,
      ),
    );
  }
}

// ============================================================
//  ACTIVITY LOG SCREEN
// ============================================================
class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return 'منذ ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعة';
    if (diff.inMinutes > 0) return 'منذ ${diff.inMinutes} دقيقة';
    return 'الآن';
  }

  String _getLogIcon(String type) {
    switch (type) {
      case 'submission':
        return '📋';
      case 'payment':
        return '💰';
      case 'security':
        return '🔒';
      case 'settings':
        return '⚙️';
      default:
        return '📌';
    }
  }

  Color _getLogColor(String type) {
    switch (type) {
      case 'submission':
        return AppColors.accent;
      case 'payment':
        return AppColors.success;
      case 'security':
        return AppColors.warning;
      case 'settings':
        return AppColors.textSecondary;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppProvider.of(context),
      builder: (context, _) {
        final controller = AppProvider.of(context);
        final logs = controller.activityLogs;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('سجل النشاط'),
          ),
          body: AppBackground(
            child: logs.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📋', style: TextStyle(fontSize: 64)),
                        SizedBox(height: 16),
                        Text('لا يوجد سجل نشاط بعد',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.card.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _getLogColor(log.type).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Text(_getLogIcon(log.type),
                                      style: const TextStyle(fontSize: 20))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(log.title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(log.description,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Text(_formatTime(log.time),
                                      style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
