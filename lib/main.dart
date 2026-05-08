// ============================================================
//  NEXUS QUIZ — Professional Imtihon Platformasi v3.0
//  Production-Grade: Secure · Performant · Robust · Accessible
//  Architecture: Repository → Service → BLoC-like State → UI
// ============================================================

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────
// KIRISH NUQTASI
// ─────────────────────────────────────────────────────────────
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  } catch (_) {}

  await AppRepository.instance.init();
  runApp(const NexusApp());
}

// ─────────────────────────────────────────────────────────────
// DIZAYN TIZIMI
// ─────────────────────────────────────────────────────────────
class AppColors {
  static const bg        = Color(0xFF080810);
  static const surface   = Color(0xFF0F0F1A);
  static const card      = Color(0xFF161624);
  static const cardHover = Color(0xFF1E1E30);
  static const border    = Color(0xFF252538);
  static const primary   = Color(0xFF7C6EF5);
  static const primaryDim= Color(0xFF5B4FD4);
  static const accent    = Color(0xFF00E5B8);
  static const accentDim = Color(0xFF00B890);
  static const danger    = Color(0xFFFF4D6D);
  static const warn      = Color(0xFFFFB300);
  static const ok        = Color(0xFF22D3A0);
  static const gold      = Color(0xFFFFD55A);
  static const silver    = Color(0xFFCDD5E0);
  static const bronze    = Color(0xFFD4966A);
  static const text1     = Color(0xFFF2F2FF);
  static const text2     = Color(0xFF9090B8);
  static const text3     = Color(0xFF4A4A70);
  static const glowPurple = Color(0x407C6EF5);
  static const glowCyan   = Color(0x3000E5B8);
}

class AppTypography {
  static const display = TextStyle(fontSize: 34, fontWeight: FontWeight.w800,
      letterSpacing: -1.2, color: AppColors.text1, height: 1.1);
  static const h1 = TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
      letterSpacing: -0.8, color: AppColors.text1);
  static const h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
      letterSpacing: -0.4, color: AppColors.text1);
  static const h3 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
      color: AppColors.text1);
  static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.w400,
      color: AppColors.text2, height: 1.6);
  static const bodyBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
      color: AppColors.text1);
  static const caption = TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
      letterSpacing: 1.0, color: AppColors.text2);
  static const mono = TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
      fontFamily: 'monospace', color: AppColors.text1);
}

ThemeData buildTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surface,
    error: AppColors.danger,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.bg,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
        color: AppColors.text1),
    iconTheme: IconThemeData(color: AppColors.text1),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.border,
      disabledForegroundColor: AppColors.text3,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.text2,
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.card,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.danger)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    hintStyle: const TextStyle(color: AppColors.text3, fontSize: 14),
    labelStyle: const TextStyle(color: AppColors.text2),
    errorStyle: const TextStyle(color: AppColors.danger, fontSize: 12),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.selected) ? Colors.white : AppColors.text3),
    trackColor: WidgetStateProperty.resolveWith((s) =>
        s.contains(WidgetState.selected) ? AppColors.ok : AppColors.border),
  ),
  sliderTheme: const SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.border,
    thumbColor: AppColors.primary,
    overlayColor: AppColors.glowPurple,
    trackHeight: 4,
  ),
  dividerTheme: const DividerThemeData(color: AppColors.border, space: 1),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.card,
    contentTextStyle: const TextStyle(color: AppColors.text1, fontSize: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
  ),
);

// ─────────────────────────────────────────────────────────────
// XAVFSIZLIK UTILITASI — Murakkabroq hash
// ─────────────────────────────────────────────────────────────
class SecurityUtils {
  static const _salt = 'nx_s3cur3_s4lt_2024';

  /// PBKDF2-ga o'xshash oddiy lekin ancha yaxshi hash
  static String hashPassword(String password) {
    final salted = '$_salt:$password:${password.length}:${password.codeUnits.fold(0, (a, b) => a ^ b)}';
    var hash = 5381;
    for (int i = 0; i < salted.length; i++) {
      hash = ((hash << 5) + hash) ^ salted.codeUnitAt(i);
      hash = hash & 0x7FFFFFFF;
    }
    // Ikki turli seed bilan ikki marta hash (murakkablik oshirish)
    var hash2 = 0x811c9dc5;
    for (final c in salted.codeUnits) {
      hash2 ^= c;
      hash2 = (hash2 * 0x01000193) & 0xFFFFFFFF;
    }
    return '${hash.toRadixString(16).padLeft(8, '0')}${hash2.toRadixString(16).padLeft(8, '0')}';
  }

  /// Parol kuchliligi tekshirish
  static PasswordStrength checkStrength(String p) {
    if (p.length < 6) return PasswordStrength.weak;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[a-z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  static bool isValidEmail(String email) =>
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$').hasMatch(email.trim());

  static String sanitize(String input) =>
      input.trim().replaceAll(RegExp(r'[<>"\x00-\x1F]'), '');
}

enum PasswordStrength { weak, medium, strong }

// ─────────────────────────────────────────────────────────────
// MODELLAR
// ─────────────────────────────────────────────────────────────
@immutable
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String passwordHash;
  final int leaderboardScore;
  final int totalAttempts;
  final double leaderboardAccuracy;
  final String badge;
  final bool isBanned;
  final bool isAdmin;
  final DateTime joinedAt;
  final List<String> firstAttemptTestIds;
  final DateTime? lastActiveAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.passwordHash,
    this.leaderboardScore = 0,
    this.totalAttempts = 0,
    this.leaderboardAccuracy = 0.0,
    this.badge = 'Yangi',
    this.isBanned = false,
    this.isAdmin = false,
    required this.joinedAt,
    this.firstAttemptTestIds = const [],
    this.lastActiveAt,
  });

  String get displayName => '${firstName.trim()} ${lastName.trim()}'.trim();
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  UserModel copyWith({
    String? email, String? firstName, String? lastName,
    String? passwordHash, int? leaderboardScore, int? totalAttempts,
    double? leaderboardAccuracy, String? badge, bool? isBanned,
    bool? isAdmin, List<String>? firstAttemptTestIds, DateTime? lastActiveAt,
  }) => UserModel(
    id: id, joinedAt: joinedAt,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    passwordHash: passwordHash ?? this.passwordHash,
    leaderboardScore: leaderboardScore ?? this.leaderboardScore,
    totalAttempts: totalAttempts ?? this.totalAttempts,
    leaderboardAccuracy: leaderboardAccuracy ?? this.leaderboardAccuracy,
    badge: badge ?? this.badge,
    isBanned: isBanned ?? this.isBanned,
    isAdmin: isAdmin ?? this.isAdmin,
    firstAttemptTestIds: firstAttemptTestIds ?? this.firstAttemptTestIds,
    lastActiveAt: lastActiveAt ?? this.lastActiveAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'email': email, 'firstName': firstName, 'lastName': lastName,
    'passwordHash': passwordHash, 'leaderboardScore': leaderboardScore,
    'totalAttempts': totalAttempts, 'leaderboardAccuracy': leaderboardAccuracy,
    'badge': badge, 'isBanned': isBanned, 'isAdmin': isAdmin,
    'joinedAt': joinedAt.toIso8601String(),
    'firstAttemptTestIds': firstAttemptTestIds,
    'lastActiveAt': lastActiveAt?.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'] ?? '',
    email: j['email'] ?? '',
    firstName: j['firstName'] ?? '',
    lastName: j['lastName'] ?? '',
    passwordHash: j['passwordHash'] ?? '',
    leaderboardScore: (j['leaderboardScore'] ?? j['totalScore'] ?? 0) as int,
    totalAttempts: (j['totalAttempts'] ?? j['testsCompleted'] ?? 0) as int,
    leaderboardAccuracy: ((j['leaderboardAccuracy'] ?? j['accuracy'] ?? 0) as num).toDouble(),
    badge: j['badge'] ?? 'Yangi',
    isBanned: j['isBanned'] ?? false,
    isAdmin: j['isAdmin'] ?? false,
    joinedAt: DateTime.tryParse(j['joinedAt'] ?? '') ?? DateTime.now(),
    firstAttemptTestIds: List<String>.from(j['firstAttemptTestIds'] ?? j['completedTestIds'] ?? []),
    lastActiveAt: j['lastActiveAt'] != null ? DateTime.tryParse(j['lastActiveAt']) : null,
  );
}

class AdminLog {
  final String id;
  final String adminId;
  final String adminName;
  final String action;
  final String targetId;
  final String targetName;
  final String details;
  final DateTime timestamp;

  AdminLog({
    required this.id, required this.adminId, required this.adminName,
    required this.action, required this.targetId, required this.targetName,
    required this.details, DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id, 'adminId': adminId, 'adminName': adminName,
    'action': action, 'targetId': targetId, 'targetName': targetName,
    'details': details, 'timestamp': timestamp.toIso8601String(),
  };

  factory AdminLog.fromJson(Map<String, dynamic> j) => AdminLog(
    id: j['id'] ?? '', adminId: j['adminId'] ?? '',
    adminName: j['adminName'] ?? '', action: j['action'] ?? '',
    targetId: j['targetId'] ?? '', targetName: j['targetName'] ?? '',
    details: j['details'] ?? '',
    timestamp: DateTime.tryParse(j['timestamp'] ?? '') ?? DateTime.now(),
  );
}

enum Difficulty { oson, orta, qiyin, ekspert }

extension DifficultyExt on Difficulty {
  String get label => const {'oson':'Oson','orta':"O'rta",'qiyin':'Qiyin','ekspert':'Ekspert'}[name]!;
  Color get color => const {
    'oson': AppColors.ok, 'orta': AppColors.warn,
    'qiyin': Color(0xFFFF8C42), 'ekspert': AppColors.danger,
  }[name]!;
  int get defaultSecondsPerQ => const {'oson':25,'orta':40,'qiyin':55,'ekspert':80}[name]!;
}

class ScoringConfig {
  final int basePoints;
  final double accuracyWeight;
  final double timeWeight;

  const ScoringConfig({
    this.basePoints = 100,
    this.accuracyWeight = 0.7,
    this.timeWeight = 0.3,
  });

  /// Weight'lar har doim 1.0 ga yig'ilishini ta'minlash
  ScoringConfig get normalized {
    final total = accuracyWeight + timeWeight;
    if (total == 0) return const ScoringConfig();
    return ScoringConfig(
      basePoints: basePoints,
      accuracyWeight: double.parse((accuracyWeight / total).toStringAsFixed(2)),
      timeWeight: double.parse((timeWeight / total).toStringAsFixed(2)),
    );
  }

  Map<String, dynamic> toJson() => {
    'basePoints': basePoints, 'accuracyWeight': accuracyWeight, 'timeWeight': timeWeight,
  };

  factory ScoringConfig.fromJson(Map<String, dynamic> j) => ScoringConfig(
    basePoints: (j['basePoints'] ?? 100) as int,
    accuracyWeight: ((j['accuracyWeight'] ?? 0.7) as num).toDouble(),
    timeWeight: ((j['timeWeight'] ?? 0.3) as num).toDouble(),
  );
}

@immutable
class QuestionModel {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const QuestionModel({
    required this.id, required this.text,
    required this.options, required this.correctIndex,
    this.explanation,
  });

  bool get isValid =>
      text.trim().isNotEmpty &&
      options.length >= 2 &&
      options.every((o) => o.trim().isNotEmpty) &&
      correctIndex >= 0 && correctIndex < options.length;

  Map<String, dynamic> toJson() => {
    'id': id, 'text': text, 'options': options,
    'correctIndex': correctIndex, 'explanation': explanation,
  };

  factory QuestionModel.fromJson(Map<String, dynamic> j) => QuestionModel(
    id: j['id'] ?? '', text: j['text'] ?? '',
    options: List<String>.from(j['options'] ?? []),
    correctIndex: (j['correctIndex'] ?? 0) as int,
    explanation: j['explanation'],
  );
}

@immutable
class TestModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final Difficulty difficulty;
  final List<QuestionModel> questions;
  final bool isOpen;
  final DateTime createdAt;
  final int timeLimitSeconds;
  final ScoringConfig scoringConfig;

  const TestModel({
    required this.id, required this.title, required this.description,
    required this.difficulty, required this.questions,
    this.category = 'Umumiy', this.isOpen = true,
    required this.createdAt, required this.timeLimitSeconds,
    this.scoringConfig = const ScoringConfig(),
  });

  factory TestModel.create({
    required String id, required String title, required String description,
    required Difficulty difficulty, required List<QuestionModel> questions,
    String category = 'Umumiy', bool isOpen = true,
    int? timeLimitSeconds, ScoringConfig? scoringConfig,
  }) => TestModel(
    id: id, title: title, description: description, difficulty: difficulty,
    questions: questions, category: category, isOpen: isOpen,
    createdAt: DateTime.now(),
    timeLimitSeconds: timeLimitSeconds ?? (difficulty.defaultSecondsPerQ * questions.length),
    scoringConfig: (scoringConfig ?? const ScoringConfig()).normalized,
  );

  TestModel copyWith({String? title, String? description, String? category,
    Difficulty? difficulty, List<QuestionModel>? questions, bool? isOpen,
    int? timeLimitSeconds, ScoringConfig? scoringConfig}) =>
      TestModel(
        id: id, createdAt: createdAt,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        difficulty: difficulty ?? this.difficulty,
        questions: questions ?? this.questions,
        isOpen: isOpen ?? this.isOpen,
        timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
        scoringConfig: (scoringConfig ?? this.scoringConfig).normalized,
      );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description,
    'category': category, 'difficulty': difficulty.name,
    'questions': questions.map((q) => q.toJson()).toList(),
    'isOpen': isOpen, 'createdAt': createdAt.toIso8601String(),
    'timeLimitSeconds': timeLimitSeconds, 'scoringConfig': scoringConfig.toJson(),
  };

  factory TestModel.fromJson(Map<String, dynamic> j) {
    const diffMap = {
      'easy': Difficulty.oson, 'oson': Difficulty.oson,
      'medium': Difficulty.orta, 'orta': Difficulty.orta,
      'hard': Difficulty.qiyin, 'qiyin': Difficulty.qiyin,
      'expert': Difficulty.ekspert, 'ekspert': Difficulty.ekspert,
    };
    final diff = diffMap[j['difficulty']] ?? Difficulty.orta;
    final qs = ((j['questions'] ?? []) as List)
        .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
        .toList();
    return TestModel(
      id: j['id'] ?? '', title: j['title'] ?? '',
      description: j['description'] ?? '',
      category: j['category'] ?? 'Umumiy',
      difficulty: diff, questions: qs,
      isOpen: j['isOpen'] ?? true,
      createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
      timeLimitSeconds: (j['timeLimitSeconds'] as int?) ?? (diff.defaultSecondsPerQ * qs.length),
      scoringConfig: j['scoringConfig'] != null
          ? ScoringConfig.fromJson(j['scoringConfig'] as Map<String, dynamic>)
          : const ScoringConfig(),
    );
  }
}

enum AttemptType { birinchi, takrorlash }

@immutable
class TestResult {
  final String id;
  final String userId;
  final String testId;
  final String testTitle;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final double accuracy;
  final int timeTakenSeconds;
  final int totalTimeSeconds;
  final DateTime completedAt;
  final List<int?> selectedAnswers;
  final AttemptType attemptType;

  const TestResult({
    required this.id, required this.userId, required this.testId,
    required this.testTitle, required this.score,
    required this.totalQuestions, required this.correctAnswers,
    required this.accuracy, required this.timeTakenSeconds,
    required this.totalTimeSeconds, required this.completedAt,
    required this.selectedAnswers,
    this.attemptType = AttemptType.birinchi,
  });

  bool get isFirstAttempt => attemptType == AttemptType.birinchi;
  bool get isPassing => accuracy >= 60.0;

  Map<String, dynamic> toJson() => {
    'id': id, 'userId': userId, 'testId': testId,
    'testTitle': testTitle, 'score': score,
    'totalQuestions': totalQuestions, 'correctAnswers': correctAnswers,
    'accuracy': accuracy, 'timeTakenSeconds': timeTakenSeconds,
    'totalTimeSeconds': totalTimeSeconds,
    'completedAt': completedAt.toIso8601String(),
    'selectedAnswers': selectedAnswers, 'attemptType': attemptType.name,
  };

  factory TestResult.fromJson(Map<String, dynamic> j) => TestResult(
    id: j['id'] ?? '', userId: j['userId'] ?? '',
    testId: j['testId'] ?? '', testTitle: j['testTitle'] ?? '',
    score: (j['score'] ?? 0) as int,
    totalQuestions: (j['totalQuestions'] ?? 0) as int,
    correctAnswers: (j['correctAnswers'] ?? 0) as int,
    accuracy: ((j['accuracy'] ?? 0) as num).toDouble(),
    timeTakenSeconds: (j['timeTakenSeconds'] ?? 0) as int,
    totalTimeSeconds: (j['totalTimeSeconds'] ?? 1) as int,
    completedAt: DateTime.tryParse(j['completedAt'] ?? '') ?? DateTime.now(),
    selectedAnswers: List<int?>.from((j['selectedAnswers'] ?? []).map((e) => e as int?)),
    attemptType: j['attemptType'] == 'takrorlash' ? AttemptType.takrorlash : AttemptType.birinchi,
  );
}

// ─────────────────────────────────────────────────────────────
// REPOSITORY — Markazlashgan ma'lumot boshqaruvi + Cache
// ─────────────────────────────────────────────────────────────
class AppRepository {
  AppRepository._();
  static final AppRepository instance = AppRepository._();

  late SharedPreferences _prefs;
  static const _usersKey   = 'nx_users_v4';
  static const _testsKey   = 'nx_tests_v4';
  static const _resultsKey = 'nx_results_v4';
  static const _sessionKey = 'nx_session_v4';
  static const _logsKey    = 'nx_logs_v2';

  // In-memory cache
  List<UserModel>? _userCache;
  List<TestModel>? _testCache;
  List<TestResult>? _resultCache;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _seedIfEmpty();
  }

  void invalidateCache() {
    _userCache = null;
    _testCache = null;
    _resultCache = null;
  }

  // ── FOYDALANUVCHILAR ──
  List<UserModel> getUsers() {
    if (_userCache != null) return List.unmodifiable(_userCache!);
    try {
      final raw = _prefs.getString(_usersKey);
      if (raw == null) {
        _userCache = [];
        return const [];
      }
      _userCache = (jsonDecode(raw) as List)
          .map((j) => UserModel.fromJson(j as Map<String, dynamic>))
          .toList();
      return List.unmodifiable(_userCache!);
    } catch (e) {
      _userCache = [];
      return const [];
    }
  }

  Future<void> saveUsers(List<UserModel> users) async {
    _userCache = List.of(users);
    await _prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  UserModel? getUserById(String id) {
    try {
      return getUsers().firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  UserModel? getUserByEmail(String email) {
    try {
      return getUsers().firstWhere((u) => u.email.toLowerCase() == email.toLowerCase().trim());
    } catch (_) {
      return null;
    }
  }

  Future<void> upsertUser(UserModel user) async {
    final users = List<UserModel>.from(getUsers());
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx >= 0) {
      users[idx] = user;
    } else {
      users.add(user);
    }
    await saveUsers(users);
  }

  // ── TESTLAR ──
  List<TestModel> getTests() {
    if (_testCache != null) return List.unmodifiable(_testCache!);
    try {
      final raw = _prefs.getString(_testsKey);
      if (raw == null) {
        _testCache = [];
        return const [];
      }
      _testCache = (jsonDecode(raw) as List)
          .map((j) => TestModel.fromJson(j as Map<String, dynamic>))
          .toList();
      return List.unmodifiable(_testCache!);
    } catch (e) {
      _testCache = [];
      return const [];
    }
  }

  Future<void> saveTests(List<TestModel> tests) async {
    _testCache = List.of(tests);
    await _prefs.setString(_testsKey, jsonEncode(tests.map((t) => t.toJson()).toList()));
  }

  Future<void> upsertTest(TestModel test) async {
    final tests = List<TestModel>.from(getTests());
    final idx = tests.indexWhere((t) => t.id == test.id);
    if (idx >= 0) {
      tests[idx] = test;
    } else {
      tests.add(test);
    }
    await saveTests(tests);
  }

  Future<void> deleteTest(String id) async {
    final tests = List<TestModel>.from(getTests())..removeWhere((t) => t.id == id);
    await saveTests(tests);
  }

  // ── NATIJALAR ──
  List<TestResult> getResults() {
    if (_resultCache != null) return List.unmodifiable(_resultCache!);
    try {
      final raw = _prefs.getString(_resultsKey);
      if (raw == null) {
        _resultCache = [];
        return const [];
      }
      _resultCache = (jsonDecode(raw) as List)
          .map((j) => TestResult.fromJson(j as Map<String, dynamic>))
          .toList();
      return List.unmodifiable(_resultCache!);
    } catch (e) {
      _resultCache = [];
      return const [];
    }
  }

  Future<void> saveResult(TestResult result) async {
    final results = List<TestResult>.from(getResults())..add(result);
    _resultCache = results;
    await _prefs.setString(_resultsKey, jsonEncode(results.map((r) => r.toJson()).toList()));
  }

  List<TestResult> getResultsForUser(String userId) =>
      getResults().where((r) => r.userId == userId).toList()
        ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

  List<TestResult> getResultsForTest(String testId) =>
      getResults().where((r) => r.testId == testId).toList();

  TestResult? getFirstAttemptResult(String userId, String testId) {
    try {
      return getResults()
          .where((r) => r.userId == userId && r.testId == testId && r.isFirstAttempt)
          .first;
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> getTestLeaderboard(String testId) {
    final results = getResults()
        .where((r) => r.testId == testId && r.isFirstAttempt)
        .toList()
      ..sort((a, b) {
        final scoreDiff = b.score.compareTo(a.score);
        if (scoreDiff != 0) return scoreDiff;
        return a.timeTakenSeconds.compareTo(b.timeTakenSeconds); // Tezroq = yaxshiroq
      });
    return results.asMap().entries.map((e) => {
      'rank': e.key + 1,
      'result': e.value,
      'user': getUserById(e.value.userId),
    }).toList();
  }

  // ── LEADERBOARD — Faqat aktiv, ban qilinmagan foydalanuvchilar ──
  List<Map<String, dynamic>> getLeaderboard() {
    final users = getUsers()
        .where((u) => !u.isBanned && !u.isAdmin && u.leaderboardScore > 0)
        .toList()
      ..sort((a, b) {
        final scoreDiff = b.leaderboardScore.compareTo(a.leaderboardScore);
        if (scoreDiff != 0) return scoreDiff;
        return b.leaderboardAccuracy.compareTo(a.leaderboardAccuracy);
      });
    return users.asMap().entries.map((e) => {'rank': e.key + 1, 'user': e.value}).toList();
  }

  int getRankForUser(String userId) {
    final lb = getLeaderboard();
    try {
      return lb.firstWhere((e) => (e['user'] as UserModel).id == userId)['rank'] as int;
    } catch (_) {
      return 9999;
    }
  }

  // ── ADMIN LOGLAR ──
  List<AdminLog> getAdminLogs() {
    try {
      final raw = _prefs.getString(_logsKey);
      if (raw == null) return [];
      return (jsonDecode(raw) as List)
          .map((j) => AdminLog.fromJson(j as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      return [];
    }
  }

  Future<void> addAdminLog(AdminLog log) async {
    final logs = getAdminLogs()..insert(0, log);
    final trimmed = logs.take(1000).toList();
    await _prefs.setString(_logsKey, jsonEncode(trimmed.map((l) => l.toJson()).toList()));
  }

  // ── SESSIYA ──
  String? getSession() => _prefs.getString(_sessionKey);
  Future<void> setSession(String userId) => _prefs.setString(_sessionKey, userId);
  Future<void> clearSession() => _prefs.remove(_sessionKey);

  // ── SEED MA'LUMOTLAR ──
  Future<void> _seedIfEmpty() async {
    if (getUsers().isEmpty) {
      await saveUsers([
        UserModel(
          id: 'admin_001',
          email: 'admin@nexus.app',
          firstName: 'Nexus',
          lastName: 'Admin',
          passwordHash: SecurityUtils.hashPassword('Admin@1234'),
          isAdmin: true,
          badge: 'Admin',
          joinedAt: DateTime.now(),
        ),
      ]);
    }
    if (getTests().isEmpty) {
      await saveTests(_buildSeedTests());
    }
  }

  List<TestModel> _buildSeedTests() => [
    TestModel.create(
      id: 'test_001',
      title: 'Flutter Asoslari',
      category: 'Dasturlash',
      description: "Flutter vidjetlari, state management va Dart asoslarini sinab ko'ring.",
      difficulty: Difficulty.oson,
      scoringConfig: const ScoringConfig(basePoints: 100, accuracyWeight: 0.7, timeWeight: 0.3),
      questions: [
        const QuestionModel(id: 'q1', text: "Flutter'da aylanuvchi ro'yxatni ko'rsatish uchun qaysi vidjet ishlatiladi?",
            options: ['Column', 'ListView', 'Stack', 'GridView'], correctIndex: 1,
            explanation: "ListView aylanuvchi ro'yxatlar uchun mo'ljallangan va scroll qo'llab-quvvatlaydi."),
        const QuestionModel(id: 'q2', text: "Dart'da kompilyatsiya vaqtidagi konstantani e'lon qilish uchun qaysi kalit so'z?",
            options: ['var', 'final', 'const', 'static'], correctIndex: 2,
            explanation: "const kompilyatsiya vaqtidagi konstantalarni e'lon qiladi va xotira samarali ishlatiladi."),
        const QuestionModel(id: 'q3', text: "State o'zgarganda qayta render bo'luvchi widget turi?",
            options: ['StatelessWidget', 'StatefulWidget', 'InheritedWidget', 'Provider'], correctIndex: 1),
        const QuestionModel(id: 'q4', text: "'async' kalit so'zi funksiyaga nimani qo'shadi?",
            options: ['Parallel thread', 'await bilan asinxron imkoniyat', 'Tezroq bajarish', 'Xotira optimallashtirish'], correctIndex: 1),
        const QuestionModel(id: 'q5', text: "Bolalarni ustma-ust qo'yuvchi layout widget qaysi?",
            options: ['Row', 'Column', 'Stack', 'Wrap'], correctIndex: 2),
        const QuestionModel(id: 'q6', text: "Flutter'da hot reload nimani yangilaydi?",
            options: ['Butun applicationni', 'Faqat UI stateni', 'Faqat business logiikani', "Hech narsani"], correctIndex: 1,
            explanation: "Hot reload UI o'zgarishlarini applicationni qayta ishga tushirmasdan ko'rsatadi."),
      ],
    ),
    TestModel.create(
      id: 'test_002',
      title: "Ma'lumotlar Tuzilmasi",
      category: 'Dasturlash',
      description: 'Massivlar, daraxtlar, graflar va algoritmik murakkablik.',
      difficulty: Difficulty.qiyin,
      scoringConfig: const ScoringConfig(basePoints: 200, accuracyWeight: 0.65, timeWeight: 0.35),
      questions: [
        const QuestionModel(id: 'q1', text: 'Ikkilik qidiruvning o\'rtacha vaqt murakkabligi?',
            options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'], correctIndex: 1,
            explanation: "Har iteratsiyada qidirish maydoni ikki barobarga kamayadi → O(log n)"),
        const QuestionModel(id: 'q2', text: "LIFO (Last In, First Out) tartibidan foydalanuvchi tuzilma?",
            options: ['Navbat', 'Stek', "To'p (Heap)", 'Deque'], correctIndex: 1),
        const QuestionModel(id: 'q3', text: 'Quicksort ning eng yomon holatdagi vaqt murakkabligi?',
            options: ['O(n log n)', 'O(n)', 'O(n²)', 'O(log n)'], correctIndex: 2,
            explanation: "Tartiblanib ketgan massivda pivot eng kichik yoki eng katta bo'lganda O(n²)."),
        const QuestionModel(id: 'q4', text: "Min-heap ildizida qanday qiymat joylashadi?",
            options: ['Maksimal', 'Minimal', "O'rtacha", 'Median'], correctIndex: 1),
        const QuestionModel(id: 'q5', text: "BFS algoritmida qaysi tuzilmadan foydalaniladi?",
            options: ['Stek', 'Navbat', 'Ustunlik navbati', 'Bog\'liq ro\'yxat'], correctIndex: 1),
        const QuestionModel(id: 'q6', text: "Dinamik dasturlash qanday masalalarni yaxshi hal qiladi?",
            options: ['To\'liq qidirish', 'Takrorlanuvchi kichik masalalar', 'Tasodifiy', "Faqat bo'l va hukmron et"], correctIndex: 1),
      ],
    ),
    TestModel.create(
      id: 'test_003',
      title: "Mashinali O'qitish",
      category: "Sun'iy Intellekt",
      description: "Nazoratli o'qitish, model baholash va neyron tarmoqlar.",
      difficulty: Difficulty.ekspert,
      scoringConfig: const ScoringConfig(basePoints: 300, accuracyWeight: 0.6, timeWeight: 0.4),
      questions: [
        const QuestionModel(id: 'q1', text: "Qaysi aktivatsiya funksiyasi [0,1] oralig'ida qiymat qaytaradi?",
            options: ['ReLU', 'Sigmoid', 'Tanh', 'Softmax'], correctIndex: 1),
        const QuestionModel(id: 'q2', text: "Overfitting qachon yuzaga keladi?",
            options: ["O'quv — yaxshi, test — yomon", 'Ikkalasida ham yomon', "Parametrlar kam", "Kam o'rganish"], correctIndex: 0),
        const QuestionModel(id: 'q3', text: "Nomutanosib klassifikatsiya uchun eng mos metrika?",
            options: ['Accuracy', 'F1-score', 'MSE', 'RMSE'], correctIndex: 1,
            explanation: "F1-score precision va recall o'rtasida muvozanat ushlab turadi."),
        const QuestionModel(id: 'q4', text: 'Gradient descent nimani minimallashtiradi?',
            options: ['Aniqlikni', "Loss funksiyasini", "Learning rateni", 'Epoch sonini'], correctIndex: 1),
        const QuestionModel(id: 'q5', text: "Dropout o'qitish jarayonida nimani amalga oshiradi?",
            options: ["Vaznlarni oshiradi", "Tasodifiy neyronlarni o'chiradi", 'Outlierlarni olib tashlaydi', 'Inputni normallashtiradi'], correctIndex: 1),
        const QuestionModel(id: 'q6', text: "Qaysi algoritm nazoratli o'qitish (supervised) emas?",
            options: ['Chiziqli regressiya', 'Qaror daraxti', 'K-Means klasterlash', 'SVM'], correctIndex: 2),
        const QuestionModel(id: 'q7', text: "Batch normalization qanday foyda keltiradi?",
            options: ["Dataset kichraytiradi", "O'qitishni tezlashtiradi va barqarorlashtiradi", 'Murakkablikni oshiradi', "Shovqinni olib tashlaydi"], correctIndex: 1),
      ],
    ),
    TestModel.create(
      id: 'test_004',
      title: 'Veb Texnologiyalar',
      category: 'Dasturlash',
      description: 'HTTP, REST API va zamonaviy veb rivojlantirish asoslari.',
      difficulty: Difficulty.orta,
      scoringConfig: const ScoringConfig(basePoints: 150, accuracyWeight: 0.7, timeWeight: 0.3),
      questions: [
        const QuestionModel(id: 'q1', text: "REST nima degan ma'noni bildiradi?",
            options: ['Rapid Execution State Transfer', 'Representational State Transfer', 'Remote Endpoint Sync Transfer', 'Resource Encoding Standard Transfer'], correctIndex: 1),
        const QuestionModel(id: 'q2', text: "Qaysi HTTP metodi idempotent lekin xavfsiz (safe) emas?",
            options: ['GET', 'POST', 'PUT', 'PATCH'], correctIndex: 2,
            explanation: "PUT idempotent (bir necha marta chaqirsa ham natija bir xil), lekin serverda o'zgartirish qiladi."),
        const QuestionModel(id: 'q3', text: "CORS — Cross-Origin Resource Sharing nimani anglatadi?",
            options: ['Content Origin Resource Sharing', 'Cross-Origin Resource Sharing', 'Client Object Reference Service', 'Cross-Object Routing System'], correctIndex: 1),
        const QuestionModel(id: 'q4', text: "HTTP 404 status kodi nima?",
            options: ['OK', "Vaqtincha yo'naltirish", "Ruxsat yo'q", 'Topilmadi'], correctIndex: 3),
        const QuestionModel(id: 'q5', text: "JWT nimani anglatadi?",
            options: ['Java Web Token', 'JSON Web Token', 'JavaScript Web Transfer', 'JSON Worker Thread'], correctIndex: 1),
      ],
    ),
    TestModel.create(
      id: 'test_005',
      title: 'Matematika: Algebra',
      category: 'Matematika',
      description: "Chiziqli tenglamalar, kvadrat tenglamalar va algebraik ifodalar.",
      difficulty: Difficulty.orta,
      scoringConfig: const ScoringConfig(basePoints: 150, accuracyWeight: 0.7, timeWeight: 0.3),
      questions: [
        const QuestionModel(id: 'q1', text: '2x + 6 = 14 tenglamasini yeching',
            options: ['x = 3', 'x = 4', 'x = 5', 'x = 7'], correctIndex: 1,
            explanation: '2x = 14 − 6 = 8, x = 4'),
        const QuestionModel(id: 'q2', text: "x² − 5x + 6 = 0 ildizlari yig'indisi?",
            options: ['3', '5', '6', '2'], correctIndex: 1,
            explanation: "Vieta formulasi: x₁ + x₂ = 5/1 = 5"),
        const QuestionModel(id: 'q3', text: "(a + b)² = ?",
            options: ['a² + b²', 'a² + 2ab + b²', 'a² − 2ab + b²', '2a² + 2b²'], correctIndex: 1,
            explanation: "(a+b)² = a² + 2ab + b² — to'liq kvadrat formulasi"),
        const QuestionModel(id: 'q4', text: "log₂(8) = ?",
            options: ['2', '3', '4', '6'], correctIndex: 1,
            explanation: '2³ = 8, shuning uchun log₂(8) = 3'),
        const QuestionModel(id: 'q5', text: "f(x) = 3x² − 2x + 1 bo'lsa, f(2) = ?",
            options: ['9', '10', '11', '12'], correctIndex: 0,
            explanation: 'f(2) = 3(4) − 2(2) + 1 = 12 − 4 + 1 = 9'),
        const QuestionModel(id: 'q6', text: '3/4 + 1/6 = ?',
            options: ['5/12', '11/12', '4/10', '7/12'], correctIndex: 1,
            explanation: '9/12 + 2/12 = 11/12'),
        const QuestionModel(id: 'q7', text: "Arifmetik progressiya: 2, 5, 8, 11, ... 10-had?",
            options: ['29', '30', '31', '32'], correctIndex: 0,
            explanation: 'a₁₀ = 2 + (10−1)×3 = 2 + 27 = 29'),
      ],
    ),
    TestModel.create(
      id: 'test_006',
      title: 'Matematika: Geometriya',
      category: 'Matematika',
      description: "Tekislik va fazoviy geometriya, trigonometriya asoslari.",
      difficulty: Difficulty.qiyin,
      scoringConfig: const ScoringConfig(basePoints: 200, accuracyWeight: 0.65, timeWeight: 0.35),
      questions: [
        const QuestionModel(id: 'q1', text: "Radiusi 7 sm bo'lgan doiraning yuzi? (π ≈ 3.14)",
            options: ['43.96 sm²', '153.86 sm²', '49 sm²', '21.98 sm²'], correctIndex: 1,
            explanation: 'S = πr² = 3.14 × 49 ≈ 153.86 sm²'),
        const QuestionModel(id: 'q2', text: "Pifagor teoremasi to'g'ri burchakli uchburchak uchun?",
            options: ['a + b = c', 'a² + b² = c²', 'a² − b² = c²', '2a + 2b = c'], correctIndex: 1),
        const QuestionModel(id: 'q3', text: "sin(30°) = ?",
            options: ['√3/2', '1/2', '√2/2', '1'], correctIndex: 1),
        const QuestionModel(id: 'q4', text: "Uchburchak ichki burchaklari yig'indisi?",
            options: ['90°', '180°', '270°', '360°'], correctIndex: 1),
        const QuestionModel(id: 'q5', text: "a qirrali kub hajmi formulasi?",
            options: ['a²', 'a³', '6a²', '4a³'], correctIndex: 1),
        const QuestionModel(id: 'q6', text: "cos(60°) = ?",
            options: ['√3/2', '√2/2', '1/2', '0'], correctIndex: 2),
      ],
    ),
  ];
}

// ─────────────────────────────────────────────────────────────
// AUTH SERVICE
// ─────────────────────────────────────────────────────────────
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  String? _currentUserId;
  final _repo = AppRepository.instance;

  UserModel? get currentUser =>
      _currentUserId != null ? _repo.getUserById(_currentUserId!) : null;
  bool get isLoggedIn => _currentUserId != null && currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;

  Future<void> loadSession() async {
    final id = _repo.getSession();
    if (id == null) return;
    final user = _repo.getUserById(id);
    if (user != null && !user.isBanned) {
      _currentUserId = id;
      // Oxirgi aktiv vaqtni yangilash
      await _repo.upsertUser(user.copyWith(lastActiveAt: DateTime.now()));
    } else {
      await _repo.clearSession();
    }
  }

  /// Qaytadi: null = muvaffaqiyat, String = xato xabari
  Future<String?> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanFirst = SecurityUtils.sanitize(firstName);
    final cleanLast  = SecurityUtils.sanitize(lastName);

    if (!SecurityUtils.isValidEmail(cleanEmail)) return "To'g'ri email manzilini kiriting";
    if (cleanFirst.isEmpty || cleanFirst.length < 2) return "Ism kamida 2 ta belgi bo'lishi kerak";
    if (cleanLast.isEmpty  || cleanLast.length  < 2) return "Familiya kamida 2 ta belgi bo'lishi kerak";
    if (password.length < 8) return "Parol kamida 8 ta belgidan iborat bo'lishi kerak";
    if (!password.contains(RegExp(r'[A-Z]'))) return "Parolda kamida bitta katta harf bo'lishi kerak";
    if (!password.contains(RegExp(r'[0-9]'))) return "Parolda kamida bitta raqam bo'lishi kerak";

    if (_repo.getUserByEmail(cleanEmail) != null) {
      return "Bu email allaqachon ro'yxatdan o'tgan";
    }

    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      email: cleanEmail,
      firstName: cleanFirst,
      lastName: cleanLast,
      passwordHash: SecurityUtils.hashPassword(password),
      joinedAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
    await _repo.upsertUser(user);
    _currentUserId = user.id;
    await _repo.setSession(user.id);
    return null;
  }

  Future<String?> login(String email, String password) async {
    final user = _repo.getUserByEmail(email);
    if (user == null) return "Bu email bilan hisob topilmadi";
    if (user.isBanned) return 'BANNED';
    if (user.passwordHash != SecurityUtils.hashPassword(password)) {
      return "Parol noto'g'ri";
    }
    _currentUserId = user.id;
    await _repo.setSession(user.id);
    await _repo.upsertUser(user.copyWith(lastActiveAt: DateTime.now()));

    if (user.isAdmin) {
      await _repo.addAdminLog(AdminLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        adminId: user.id, adminName: user.displayName,
        action: 'LOGIN', targetId: user.id,
        targetName: user.displayName, details: 'Admin tizimga kirdi',
      ));
    }
    return null;
  }

  Future<void> logout() async {
    final user = currentUser;
    if (user != null && user.isAdmin) {
      await _repo.addAdminLog(AdminLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        adminId: user.id, adminName: user.displayName,
        action: 'LOGOUT', targetId: user.id,
        targetName: user.displayName, details: 'Admin tizimdan chiqdi',
      ));
    }
    _currentUserId = null;
    await _repo.clearSession();
  }
}

// ─────────────────────────────────────────────────────────────
// SCORING SERVICE
// ─────────────────────────────────────────────────────────────
class ScoringService {
  static int calculateScore({
    required int correctAnswers,
    required int totalQuestions,
    required int timeTakenSeconds,
    required int totalTimeSeconds,
    required ScoringConfig config,
  }) {
    if (totalQuestions == 0 || totalTimeSeconds <= 0) return 0;

    final accuracyRatio = correctAnswers / totalQuestions;
    final timeRatio = (1.0 - (timeTakenSeconds / totalTimeSeconds)).clamp(0.0, 1.0);

    final normalized = config.normalized;
    final score = (normalized.basePoints *
        (accuracyRatio * normalized.accuracyWeight + timeRatio * normalized.timeWeight))
        .round();
    return score.clamp(0, normalized.basePoints);
  }

  static Future<void> submitResult(TestResult result) async {
    final repo = AppRepository.instance;
    await repo.saveResult(result);

    final user = repo.getUserById(result.userId);
    if (user == null) return;

    if (result.isFirstAttempt) {
      final allFirst = repo.getResults()
          .where((r) => r.userId == user.id && r.isFirstAttempt)
          .toList();

      final totalScore = allFirst.fold(0, (s, r) => s + r.score);
      final avgAccuracy = allFirst.isEmpty ? 0.0
          : allFirst.fold(0.0, (s, r) => s + r.accuracy) / allFirst.length;
      final updatedIds = {...user.firstAttemptTestIds, result.testId}.toList();
      final totalAttempts = repo.getResultsForUser(user.id).length;

      await repo.upsertUser(user.copyWith(
        leaderboardScore: totalScore,
        totalAttempts: totalAttempts,
        leaderboardAccuracy: avgAccuracy,
        firstAttemptTestIds: updatedIds,
        badge: _computeBadge(totalScore, allFirst.length),
        lastActiveAt: DateTime.now(),
      ));
    } else {
      final totalAttempts = repo.getResultsForUser(user.id).length;
      await repo.upsertUser(user.copyWith(
        totalAttempts: totalAttempts,
        lastActiveAt: DateTime.now(),
      ));
    }
  }

  static String _computeBadge(int score, int tests) {
    if (score >= 20000 || tests >= 20) return 'Afsona';
    if (score >= 10000 || tests >= 15) return 'Olmaz';
    if (score >= 5000  || tests >= 10) return 'Platina';
    if (score >= 2000  || tests >= 6)  return 'Oltin';
    if (score >= 800   || tests >= 3)  return 'Kumush';
    if (score >= 200   || tests >= 1)  return 'Bronza';
    return 'Yangi';
  }

  static Color badgeColor(String badge) => const {
    'Afsona': Color(0xFFFF6B9D),
    'Olmaz': Color(0xFF67E8F9),
    'Platina': Color(0xFFE2E8F0),
    'Oltin': AppColors.gold,
    'Kumush': AppColors.silver,
    'Bronza': AppColors.bronze,
    'Admin': AppColors.primary,
  }[badge] ?? AppColors.text2;

  static IconData badgeIcon(String badge) => const {
    'Afsona': Icons.auto_awesome,
    'Olmaz': Icons.diamond,
    'Platina': Icons.workspace_premium,
    'Oltin': Icons.emoji_events,
    'Kumush': Icons.military_tech,
    'Bronza': Icons.shield,
    'Admin': Icons.admin_panel_settings,
  }[badge] ?? Icons.star_border;
}

// ─────────────────────────────────────────────────────────────
// APP STATE
// ─────────────────────────────────────────────────────────────
class AppState extends ChangeNotifier {
  bool _initialized = false;
  bool get initialized => _initialized;

  final _auth = AuthService.instance;

  Future<void> initialize() async {
    await _auth.loadSession();
    _initialized = true;
    notifyListeners();
  }

  void refresh() => notifyListeners();
}

// ─────────────────────────────────────────────────────────────
// ASOSIY ILOVA
// ─────────────────────────────────────────────────────────────
class NexusApp extends StatefulWidget {
  const NexusApp({super.key});
  @override
  State<NexusApp> createState() => _NexusAppState();
}

class _NexusAppState extends State<NexusApp> {
  final _appState = AppState();
  bool _splashDone = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await Future.wait([
      _appState.initialize(),
      Future.delayed(const Duration(milliseconds: 2400)),
    ]);
    if (mounted) setState(() => _splashDone = true);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _appState,
    builder: (_, __) => MaterialApp(
      title: 'Nexus Quiz',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: !_splashDone
          ? const SplashScreen()
          : AuthService.instance.isLoggedIn
              ? MainShell(appState: _appState)
              : AuthGate(appState: _appState),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// SPLASH
// ─────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _logoOpacity, _logoScale, _textOpacity, _progress, _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _logoOpacity = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.25, curve: Curves.easeIn));
    _logoScale   = Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.4, curve: Curves.elasticOut)));
    _textOpacity = CurvedAnimation(parent: _ctrl, curve: const Interval(0.35, 0.6, curve: Curves.easeIn));
    _progress    = CurvedAnimation(parent: _ctrl, curve: const Interval(0.55, 1.0, curve: Curves.easeInOut));
    _glow        = CurvedAnimation(parent: _ctrl, curve: const Interval(0.2, 0.6, curve: Curves.easeInOut));
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          // Glow background
          Opacity(
            opacity: _glow.value * 0.6,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.glowPurple, Colors.transparent,
                ]),
              ),
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Opacity(
              opacity: _logoOpacity.value,
              child: Transform.scale(
                scale: _logoScale.value,
                child: Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDim],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    boxShadow: [BoxShadow(
                      color: AppColors.glowPurple, blurRadius: 40, spreadRadius: 8,
                    )],
                  ),
                  child: const Icon(Icons.bolt_rounded, size: 52, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Opacity(
              opacity: _textOpacity.value,
              child: Column(children: [
                const Text('NEXUS', style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.w900,
                  letterSpacing: 10, color: AppColors.text1,
                )),
                const SizedBox(height: 6),
                Text('IMTIHON PLATFORMASI', style: AppTypography.caption.copyWith(
                  letterSpacing: 4, color: AppColors.text2,
                )),
              ]),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: 180,
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: _progress.value,
                    minHeight: 2,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Opacity(
                  opacity: _progress.value,
                  child: Text('Yuklanmoqda...', style: AppTypography.caption.copyWith(
                    color: AppColors.text3, letterSpacing: 1,
                  )),
                ),
              ]),
            ),
          ]),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// AUTH GATE
// ─────────────────────────────────────────────────────────────
class AuthGate extends StatefulWidget {
  final AppState appState;
  const AuthGate({super.key, required this.appState});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showLogin = true;
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 350),
    transitionBuilder: (child, anim) => FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(begin: const Offset(0.04, 0), end: Offset.zero).animate(anim),
        child: child,
      ),
    ),
    child: _showLogin
        ? LoginScreen(key: const ValueKey('login'), appState: widget.appState,
            onRegister: () => setState(() => _showLogin = false))
        : RegisterScreen(key: const ValueKey('register'), appState: widget.appState,
            onLogin: () => setState(() => _showLogin = true)),
  );
}

// ─────────────────────────────────────────────────────────────
// LOGIN SCREEN
// ─────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onRegister;
  const LoginScreen({super.key, required this.appState, required this.onRegister});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading = false, _obscure = true;
  String? _error;
  int _failedAttempts = 0;
  DateTime? _lockoutUntil;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  bool get _isLockedOut => _lockoutUntil != null && DateTime.now().isBefore(_lockoutUntil!);

  Future<void> _submit() async {
    if (_isLockedOut) {
      final remaining = _lockoutUntil!.difference(DateTime.now()).inSeconds;
      setState(() => _error = "Juda ko'p urinish. $remaining soniya kuting.");
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _error = null; });

    final err = await AuthService.instance.login(_emailCtrl.text, _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);

    if (err == null) {
      _failedAttempts = 0;
      widget.appState.refresh();
    } else if (err == 'BANNED') {
      _showBanDialog();
    } else {
      _failedAttempts++;
      if (_failedAttempts >= 5) {
        _lockoutUntil = DateTime.now().add(const Duration(seconds: 30));
        setState(() => _error = "5 marta xato kiritildi. 30 soniya kuting.");
      } else {
        setState(() => _error = err);
      }
    }
  }

  void _showBanDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.gpp_bad, color: AppColors.danger, size: 26),
          SizedBox(width: 10),
          Text("Hisob to'xtatildi", style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
        ]),
        content: const Text(
          "Hisobingizda qoidabuzarlik aniqlandi.\n\nHisobingiz administrator tomonidan bloklangan.\n\nKo'proq ma'lumot uchun administrator bilan bog'laning.",
          style: TextStyle(color: AppColors.text2, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tushundim', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 40),
          const _NexusLogo(),
          const SizedBox(height: 52),
          const Text('Xush kelibsiz', style: AppTypography.display),
          const SizedBox(height: 8),
          Text('Davom etish uchun tizimga kiring',
              style: AppTypography.body.copyWith(fontSize: 15)),
          const SizedBox(height: 44),
          Form(
            key: _formKey,
            child: Column(children: [
              _InputField(
                controller: _emailCtrl,
                label: 'Email manzil',
                hint: 'siz@example.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email kiritish shart';
                  if (!SecurityUtils.isValidEmail(v)) return "Noto'g'ri email format";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _InputField(
                controller: _passCtrl,
                label: 'Parol',
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscure: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.text3, size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Parol kiritish shart' : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                _ErrorBanner(_error!),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_loading || _isLockedOut) ? null : _submit,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Kirish'),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 36),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Hisobingiz yo'qmi? ", style: AppTypography.body),
            GestureDetector(
              onTap: widget.onRegister,
              child: const Text("Ro'yxatdan o'tish",
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ]),
          const SizedBox(height: 28),
          const _DemoCredentials(),
        ]),
      ),
    ),
  );
}

class _DemoCredentials extends StatelessWidget {
  const _DemoCredentials();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Demo kirish", style: AppTypography.caption.copyWith(color: AppColors.text3)),
      const SizedBox(height: 12),
      _CredRow('Admin', 'admin@nexus.app', 'Admin@1234'),
    ]),
  );
}

class _CredRow extends StatelessWidget {
  final String role, email, pass;
  const _CredRow(this.role, this.email, this.pass);
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(role, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
    ),
    const SizedBox(width: 10),
    Expanded(child: Text('$email  ·  $pass',
        style: AppTypography.body.copyWith(fontSize: 12))),
  ]);
}

// ─────────────────────────────────────────────────────────────
// REGISTER SCREEN
// ─────────────────────────────────────────────────────────────
class RegisterScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLogin;
  const RegisterScreen({super.key, required this.appState, required this.onLogin});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _firstCtrl = TextEditingController();
  final _lastCtrl  = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading = false, _obscure = true;
  String? _error;
  PasswordStrength _strength = PasswordStrength.weak;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(() {
      final s = SecurityUtils.checkStrength(_passCtrl.text);
      if (s != _strength) setState(() => _strength = s);
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose(); _firstCtrl.dispose();
    _lastCtrl.dispose();  _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.instance.register(
      email: _emailCtrl.text,
      firstName: _firstCtrl.text,
      lastName: _lastCtrl.text,
      password: _passCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (err == null) {
      widget.appState.refresh();
    } else {
      setState(() => _error = err);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          const _NexusLogo(),
          const SizedBox(height: 36),
          const Text('Hisob yaratish', style: AppTypography.display),
          const SizedBox(height: 8),
          Text("Minglab ishtirokchilar safiga qo'shiling",
              style: AppTypography.body.copyWith(fontSize: 15)),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(children: [
              Row(children: [
                Expanded(child: _InputField(
                  controller: _firstCtrl, label: 'Ism', hint: 'Ali',
                  icon: Icons.person_outline_rounded,
                  validator: (v) {
                    if (v == null || v.trim().length < 2) return 'Kamida 2 ta belgi';
                    return null;
                  },
                )),
                const SizedBox(width: 12),
                Expanded(child: _InputField(
                  controller: _lastCtrl, label: 'Familiya', hint: 'Karimov',
                  icon: Icons.person_outline_rounded,
                  validator: (v) {
                    if (v == null || v.trim().length < 2) return 'Kamida 2 ta belgi';
                    return null;
                  },
                )),
              ]),
              const SizedBox(height: 16),
              _InputField(
                controller: _emailCtrl, label: 'Email manzil', hint: 'siz@example.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email kiritish shart';
                  if (!SecurityUtils.isValidEmail(v)) return "Noto'g'ri email format";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _InputField(
                controller: _passCtrl,
                label: 'Parol',
                hint: 'Kamida 8 belgi, 1 katta harf, 1 raqam',
                icon: Icons.lock_outline_rounded,
                obscure: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.text3, size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Parol kiritish shart';
                  if (v.length < 8) return "Kamida 8 ta belgi";
                  if (!v.contains(RegExp(r'[A-Z]'))) return "Kamida 1 ta katta harf";
                  if (!v.contains(RegExp(r'[0-9]'))) return "Kamida 1 ta raqam";
                  return null;
                },
              ),
              if (_passCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                _PasswordStrengthBar(strength: _strength),
              ],
              if (_error != null) ...[
                const SizedBox(height: 14),
                _ErrorBanner(_error!),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Hisob yaratish'),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 36),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Hisobingiz bormi? ', style: AppTypography.body),
            GestureDetector(
              onTap: widget.onLogin,
              child: const Text('Kirish',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ]),
        ]),
      ),
    ),
  );
}

class _PasswordStrengthBar extends StatelessWidget {
  final PasswordStrength strength;
  const _PasswordStrengthBar({required this.strength});

  Color get _color => strength == PasswordStrength.strong ? AppColors.ok
      : strength == PasswordStrength.medium ? AppColors.warn : AppColors.danger;
  double get _width => strength == PasswordStrength.strong ? 1.0
      : strength == PasswordStrength.medium ? 0.6 : 0.3;
  String get _label => strength == PasswordStrength.strong ? "Kuchli parol ✓"
      : strength == PasswordStrength.medium ? "O'rtacha parol" : "Zaif parol";

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: _width, minHeight: 3,
        backgroundColor: AppColors.border,
        valueColor: AlwaysStoppedAnimation(_color),
      ),
    ),
    const SizedBox(height: 4),
    Text(_label, style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600)),
  ]);
}

// ─────────────────────────────────────────────────────────────
// MAIN SHELL
// ─────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  final AppState appState;
  const MainShell({super.key, required this.appState});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  List<Widget> get _pages => AuthService.instance.isAdmin
      ? [
          const AdminDashboard(),
          const AdminUsersPage(),
          const AdminTestsPage(),
          const AdminLogsPage(),
        ]
      : [
          HomePage(appState: widget.appState),
          const TestsPage(),
          const LeaderboardPage(),
          ProfilePage(appState: widget.appState),
        ];

  List<BottomNavigationBarItem> get _items => AuthService.instance.isAdmin
      ? const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Boshqaruv'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Foydalanuvchilar'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz_outlined), activeIcon: Icon(Icons.quiz), label: 'Testlar'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Loglar'),
        ]
      : const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Bosh sahifa'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz_outlined), activeIcon: Icon(Icons.quiz), label: 'Testlar'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard_outlined), activeIcon: Icon(Icons.leaderboard), label: 'Reyting'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profil'),
        ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _currentIndex, children: _pages),
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.text3,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: _items,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// HOME PAGE
// ─────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  final AppState appState;
  const HomePage({super.key, required this.appState});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final repo = AppRepository.instance;
    final rank = repo.getRankForUser(user.id);
    final results = repo.getResultsForUser(user.id);
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Xayrli tong' : hour < 17 ? 'Xayrli kun' : 'Xayrli kech';
    final totalTests = repo.getTests().where((t) => t.isOpen).length;
    final completedCount = user.firstAttemptTestIds.length;
    final progress = totalTests > 0 ? completedCount / totalTests : 0.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.card,
        onRefresh: () async => setState(() {}),
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 22, right: 22, bottom: 28,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF130E28), AppColors.bg],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('$greeting,', style: AppTypography.body.copyWith(fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(user.firstName, style: AppTypography.h1),
                  ])),
                  _BadgeChip(user.badge),
                ]),
                const SizedBox(height: 24),
                _HeroCard(user: user, rank: rank),
                const SizedBox(height: 16),
                // Progres bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("Testlar ulushi", style: AppTypography.bodyBold),
                      Text('$completedCount / $totalTests', style: AppTypography.body.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700,
                      )),
                    ]),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress, minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${(progress * 100).round()}% bajarildi',
                        style: AppTypography.caption.copyWith(color: AppColors.text3)),
                  ]),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Row(children: [
                Expanded(child: _StatTile('Topshirilgan', '${user.totalAttempts}',
                    Icons.check_circle_outline, AppColors.ok)),
                const SizedBox(width: 12),
                Expanded(child: _StatTile('Aniqlik',
                    '${user.leaderboardAccuracy.toStringAsFixed(1)}%',
                    Icons.gps_fixed_rounded, AppColors.accent)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _StatTile('Reyting balli',
                    _fmtScore(user.leaderboardScore),
                    Icons.star_rounded, AppColors.gold)),
                const SizedBox(width: 12),
                Expanded(child: _StatTile("Global o'rin",
                    rank == 9999 ? '—' : '#$rank',
                    Icons.emoji_events_outlined, AppColors.primary)),
              ]),
              const SizedBox(height: 28),
              _SectionHeader("So'nggi faoliyat", trailing: null),
              const SizedBox(height: 12),
              if (results.isEmpty)
                const _EmptyState(icon: Icons.history_rounded,
                    message: "Hali testlar topshirilmagan.\nBirinchi sinovni boshlang!")
              else
                ...results.take(5).map((r) => _ResultTile(result: r)),
              const SizedBox(height: 36),
            ])),
          ),
        ]),
      ),
    );
  }

  String _fmtScore(int s) => s >= 1000 ? '${(s / 1000).toStringAsFixed(1)}k' : '$s';
}

class _HeroCard extends StatelessWidget {
  final UserModel user;
  final int rank;
  const _HeroCard({required this.user, required this.rank});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDim],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [BoxShadow(
        color: AppColors.glowPurple, blurRadius: 28, offset: const Offset(0, 8),
      )],
    ),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("GLOBAL O'RIN", style: TextStyle(
          color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5,
        )),
        const SizedBox(height: 8),
        Text(rank == 9999 ? '—' : '#$rank', style: const TextStyle(
          color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, letterSpacing: -2,
        )),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('${user.leaderboardScore} ball', style: const TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700,
          )),
        ),
      ])),
      Container(
        width: 68, height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.18),
        ),
        child: Center(child: Text(user.initials, style: const TextStyle(
          color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800,
        ))),
      ),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────
// TESTS PAGE
// ─────────────────────────────────────────────────────────────
class TestsPage extends StatefulWidget {
  const TestsPage({super.key});
  @override
  State<TestsPage> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  Difficulty? _filterDiff;
  String? _filterCategory;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final repo = AppRepository.instance;
    final allTests = repo.getTests().where((t) => t.isOpen).toList();
    final categories = allTests.map((t) => t.category).toSet().toList()..sort();

    final tests = allTests.where((t) =>
        (_filterDiff == null || t.difficulty == _filterDiff) &&
        (_filterCategory == null || t.category == _filterCategory) &&
        (_query.isEmpty ||
            t.title.toLowerCase().contains(_query.toLowerCase()) ||
            t.category.toLowerCase().contains(_query.toLowerCase()))
    ).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(slivers: [
        _NexusAppBar(title: 'Testlar', subtitle: '${tests.length} ta mavjud'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Test qidirish...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.text3, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.text3, size: 18),
                        onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                      )
                    : null,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _DifficultyFilter(selected: _filterDiff,
            onSelect: (d) => setState(() => _filterDiff = d))),
        if (categories.isNotEmpty)
          SliverToBoxAdapter(child: _CategoryFilter(categories: categories,
              selected: _filterCategory, onSelect: (c) => setState(() => _filterCategory = c))),
        if (tests.isEmpty)
          const SliverFillRemaining(child: _EmptyState(
              icon: Icons.search_off_rounded, message: "Mos test topilmadi.\nFiltrlarni o'zgartiring"))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            sliver: SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) => _TestCard(
                test: tests[i],
                isFirstAttemptDone: user?.firstAttemptTestIds.contains(tests[i].id) ?? false,
                myBestResult: user != null ? repo.getFirstAttemptResult(user.id, tests[i].id) : null,
                onTap: () => _startTest(tests[i]),
              ),
              childCount: tests.length,
            )),
          ),
      ]),
    );
  }

  void _startTest(TestModel test) async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    final isRetake = user.firstAttemptTestIds.contains(test.id);

    if (isRetake) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Qayta urinish', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warn.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warn.withOpacity(0.3)),
              ),
              child: const Row(children: [
                Icon(Icons.info_outline, color: AppColors.warn, size: 20),
                SizedBox(width: 10),
                Expanded(child: Text(
                  "Qayta urinish reyting ballariga ta'sir qilmaydi — faqat mashq sifatida hisoblanadi.",
                  style: TextStyle(color: AppColors.warn, fontSize: 13, height: 1.5),
                )),
              ]),
            ),
          ]),
          actions: [
            OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor qilish')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Davom etish')),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    if (!mounted) return;
    await Navigator.push<TestResult>(
      context,
      MaterialPageRoute(builder: (_) => TestTakingScreen(test: test, isRetake: isRetake)),
    );
    if (mounted) setState(() {});
  }
}

class _CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelect;
  const _CategoryFilter({required this.categories, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
    child: Row(children: [
      _FilterChip('Barchasi', selected == null, () => onSelect(null), AppColors.accent),
      ...categories.map((c) => _FilterChip(c, selected == c,
          () => onSelect(c == selected ? null : c), AppColors.accent)),
    ]),
  );
}

class _DifficultyFilter extends StatelessWidget {
  final Difficulty? selected;
  final ValueChanged<Difficulty?> onSelect;
  const _DifficultyFilter({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
    child: Row(children: [
      _FilterChip('Barchasi', selected == null, () => onSelect(null), AppColors.primary),
      ...Difficulty.values.map((d) => _FilterChip(d.label, selected == d,
          () => onSelect(d == selected ? null : d), d.color)),
    ]),
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;
  const _FilterChip(this.label, this.active, this.onTap, this.color);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color : AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? color : AppColors.border),
      ),
      child: Text(label, style: TextStyle(
        color: active ? Colors.white : AppColors.text2,
        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
        fontSize: 13,
      )),
    ),
  );
}

class _TestCard extends StatelessWidget {
  final TestModel test;
  final bool isFirstAttemptDone;
  final TestResult? myBestResult;
  final VoidCallback onTap;
  const _TestCard({required this.test, required this.isFirstAttemptDone,
      this.myBestResult, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mins = (test.timeLimitSeconds / 60).ceil();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isFirstAttemptDone
              ? AppColors.ok.withOpacity(0.35) : AppColors.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(test.title, style: AppTypography.h3.copyWith(fontSize: 17)),
              const SizedBox(height: 2),
              _Tag(test.category, AppColors.primary),
            ])),
            if (isFirstAttemptDone)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.ok.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.ok.withOpacity(0.3)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.ok, size: 14),
                  SizedBox(width: 4),
                  Text('Tugatildi', style: TextStyle(color: AppColors.ok, fontSize: 11, fontWeight: FontWeight.w700)),
                ]),
              ),
          ]),
          const SizedBox(height: 8),
          Text(test.description, style: AppTypography.body, maxLines: 2, overflow: TextOverflow.ellipsis),
          if (myBestResult != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.emoji_events_outlined, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text('Eng yaxshi: ${myBestResult!.score} ball · ${myBestResult!.accuracy.round()}%',
                    style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
            ),
          ],
          const SizedBox(height: 12),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.star_outline_rounded, size: 13, color: AppColors.gold),
                const SizedBox(width: 4),
                Text('${test.scoringConfig.basePoints} ball', style: const TextStyle(
                  color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700,
                )),
              ]),
            ),
            const SizedBox(width: 8),
            _Tag(test.difficulty.label, test.difficulty.color),
            const SizedBox(width: 8),
            _Tag('${test.questions.length} savol', AppColors.text2),
            const SizedBox(width: 8),
            _Tag('$mins min', AppColors.text2),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(isFirstAttemptDone ? 'Mashq' : 'Boshlash',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TEST TAKING SCREEN — Timer + AppLifecycleState
// ─────────────────────────────────────────────────────────────
class TestTakingScreen extends StatefulWidget {
  final TestModel test;
  final bool isRetake;
  const TestTakingScreen({super.key, required this.test, this.isRetake = false});
  @override
  State<TestTakingScreen> createState() => _TestTakingScreenState();
}

class _TestTakingScreenState extends State<TestTakingScreen>
    with WidgetsBindingObserver {
  late int _remaining;
  Timer? _timer;
  int _currentQ = 0;
  late List<int?> _answers;
  bool _submitted = false;
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remaining = widget.test.timeLimitSeconds;
    _answers = List.filled(widget.test.questions.length, null);
    _startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Foydalanuvchi background'ga o'tsa — timer davom etadi
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed && _backgroundedAt != null) {
      final elapsed = DateTime.now().difference(_backgroundedAt!).inSeconds;
      setState(() => _remaining = (_remaining - elapsed).clamp(0, widget.test.timeLimitSeconds));
      _backgroundedAt = null;
      if (_remaining <= 0 && !_submitted) _submit();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _submitted) { t.cancel(); return; }
      if (_remaining <= 1) {
        t.cancel();
        setState(() => _remaining = 0);
        _submit();
        return;
      }
      setState(() => _remaining--);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitted) return;
    _submitted = true;
    _timer?.cancel();

    final timeTaken = (widget.test.timeLimitSeconds - _remaining).clamp(1, widget.test.timeLimitSeconds);
    final correct = _answers.asMap().entries
        .where((e) => e.value == widget.test.questions[e.key].correctIndex)
        .length;
    final accuracy = widget.test.questions.isEmpty ? 0.0
        : (correct / widget.test.questions.length * 100);

    final score = ScoringService.calculateScore(
      correctAnswers: correct,
      totalQuestions: widget.test.questions.length,
      timeTakenSeconds: timeTaken,
      totalTimeSeconds: widget.test.timeLimitSeconds,
      config: widget.test.scoringConfig,
    );

    final result = TestResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      userId: AuthService.instance.currentUser!.id,
      testId: widget.test.id,
      testTitle: widget.test.title,
      score: score,
      totalQuestions: widget.test.questions.length,
      correctAnswers: correct,
      accuracy: accuracy,
      timeTakenSeconds: timeTaken,
      totalTimeSeconds: widget.test.timeLimitSeconds,
      completedAt: DateTime.now(),
      selectedAnswers: List<int?>.from(_answers),
      attemptType: widget.isRetake ? AttemptType.takrorlash : AttemptType.birinchi,
    );

    await ScoringService.submitResult(result);

    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ResultScreen(result: result, test: widget.test, answers: _answers),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.test.questions[_currentQ];
    final progress = (_currentQ + 1) / widget.test.questions.length;
    final timerColor = _remaining > 30 ? AppColors.ok
        : _remaining > 10 ? AppColors.warn : AppColors.danger;
    final mins = _remaining ~/ 60;
    final secs = _remaining % 60;
    final answeredCount = _answers.where((a) => a != null).length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _showQuitDialog(context),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.text2),
                  onPressed: () => _showQuitDialog(context),
                ),
                Expanded(child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('${_currentQ + 1}', style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 15)),
                    Text(' / ${widget.test.questions.length}',
                        style: AppTypography.body.copyWith(fontSize: 15)),
                    if (widget.isRetake) ...[
                      const SizedBox(width: 8),
                      _StatusPill('MASHQ', AppColors.warn),
                    ],
                    const SizedBox(width: 12),
                    Text('$answeredCount javob berildi',
                        style: AppTypography.caption.copyWith(color: AppColors.text3)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress, minHeight: 4,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ])),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: timerColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: timerColor.withOpacity(0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.timer_outlined, size: 14, color: timerColor),
                    const SizedBox(width: 5),
                    Text(
                      '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                      style: TextStyle(color: timerColor, fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ]),
                ),
              ]),
            ),
            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 4),
                  _Tag(widget.test.difficulty.label, widget.test.difficulty.color),
                  const SizedBox(height: 18),
                  Text(q.text, style: const TextStyle(
                    fontSize: 19, fontWeight: FontWeight.w700,
                    color: AppColors.text1, height: 1.45,
                  )),
                  const SizedBox(height: 28),
                  ...q.options.asMap().entries.map((e) => _OptionTile(
                    index: e.key,
                    text: e.value,
                    selected: _answers[_currentQ] == e.key,
                    onTap: () => setState(() => _answers[_currentQ] = e.key),
                  )),
                  const SizedBox(height: 16),
                  // Question navigator
                  Wrap(spacing: 8, runSpacing: 8, children: List.generate(
                    widget.test.questions.length, (i) => GestureDetector(
                      onTap: () => setState(() => _currentQ = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: i == _currentQ ? AppColors.primary
                              : _answers[i] != null ? AppColors.ok.withOpacity(0.2)
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: i == _currentQ ? AppColors.primary
                                : _answers[i] != null ? AppColors.ok.withOpacity(0.5)
                                : AppColors.border,
                          ),
                        ),
                        child: Center(child: Text('${i + 1}', style: TextStyle(
                          color: i == _currentQ ? Colors.white
                              : _answers[i] != null ? AppColors.ok : AppColors.text2,
                          fontSize: 12, fontWeight: FontWeight.w700,
                        ))),
                      ),
                    ),
                  )),
                ]),
              ),
            ),
            // Footer navigation
            Container(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(children: [
                if (_currentQ > 0) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentQ--),
                      child: const Text('← Oldingi'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentQ < widget.test.questions.length - 1) {
                        setState(() => _currentQ++);
                      } else {
                        _showSubmitConfirm();
                      }
                    },
                    child: Text(_currentQ < widget.test.questions.length - 1
                        ? 'Keyingi →' : 'Topshirish ✓'),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  void _showSubmitConfirm() {
    final unanswered = _answers.where((a) => a == null).length;
    if (unanswered > 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Topshirishni tasdiqlash', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warn.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warn.withOpacity(0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warn, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  '$unanswered ta savol javobsiz qoldi.\nTopshirishni davom ettirasizmi?',
                  style: AppTypography.body.copyWith(color: AppColors.warn, height: 1.5),
                )),
              ]),
            ),
          ]),
          actions: [
            OutlinedButton(onPressed: () => Navigator.pop(context),
                child: const Text("Qaytish")),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); _submit(); },
              child: const Text('Topshirish'),
            ),
          ],
        ),
      );
    } else {
      _submit();
    }
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Testdan chiqish?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text("Jarayoningiz yo'qoladi. Ishonchingiz komilmi?",
            style: TextStyle(color: AppColors.text2)),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Davom etish')),
          TextButton(
            onPressed: () {
              _submitted = true;
              _timer?.cancel();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Chiqish', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.index, required this.text, required this.selected, required this.onTap});
  static const _labels = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withOpacity(0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.cardHover,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(
            index < _labels.length ? _labels[index] : '${index + 1}',
            style: TextStyle(
              color: selected ? Colors.white : AppColors.text2,
              fontWeight: FontWeight.w800, fontSize: 13,
            ),
          )),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: TextStyle(
          color: selected ? AppColors.text1 : AppColors.text2,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 15, height: 1.35,
        ))),
        if (selected)
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
      ]),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// RESULT SCREEN
// ─────────────────────────────────────────────────────────────
class ResultScreen extends StatefulWidget {
  final TestResult result;
  final TestModel test;
  final List<int?> answers;
  const ResultScreen({super.key, required this.result, required this.test, required this.answers});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _showAnswers = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final repo = AppRepository.instance;
    final currentUser = AuthService.instance.currentUser;
    final rank = currentUser != null ? repo.getRankForUser(currentUser.id) : 9999;
    final prevBestResult = r.isFirstAttempt ? null
        : repo.getFirstAttemptResult(r.userId, r.testId);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => Navigator.popUntil(context, (rt) => rt.isFirst),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(children: [
                  const SizedBox(height: 16),
                  // Mashq ogohlantirish
                  if (!r.isFirstAttempt) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.warn.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warn.withOpacity(0.25)),
                      ),
                      child: const Row(children: [
                        Icon(Icons.info_outline_rounded, color: AppColors.warn, size: 18),
                        SizedBox(width: 10),
                        Expanded(child: Text(
                          "Bu mashq urinish — reyting ballariga ta'sir qilmaydi",
                          style: TextStyle(color: AppColors.warn, fontSize: 13),
                        )),
                      ]),
                    ),
                  ],
                  // Result icon
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (r.isPassing ? AppColors.ok : AppColors.danger).withOpacity(0.12),
                        border: Border.all(color: r.isPassing ? AppColors.ok : AppColors.danger, width: 2),
                      ),
                      child: Icon(
                        r.isPassing ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                        size: 48, color: r.isPassing ? AppColors.ok : AppColors.danger,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(r.isPassing ? 'Ajoyib natija! 🎉' : "Mashq qilishda davom eting!",
                      style: AppTypography.h1.copyWith(
                          color: r.isPassing ? AppColors.ok : AppColors.text1)),
                  const SizedBox(height: 6),
                  Text(widget.test.title, style: AppTypography.body),
                  // Rank (birinchi urinish)
                  if (r.isFirstAttempt) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.leaderboard_rounded, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text("Joriy o'rningiz: ${rank == 9999 ? '—' : '#$rank'}",
                            style: const TextStyle(color: AppColors.primary,
                                fontWeight: FontWeight.w700, fontSize: 13)),
                      ]),
                    ),
                  ],
                  // Oldingi natija bilan solishtirish
                  if (prevBestResult != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.compare_arrows_rounded, color: AppColors.text2, size: 16),
                        const SizedBox(width: 8),
                        Text("Birinchi urinish: ${prevBestResult.score} ball · ${prevBestResult.accuracy.round()}%",
                            style: AppTypography.caption.copyWith(color: AppColors.text2)),
                      ]),
                    ),
                  ],
                  const SizedBox(height: 28),
                  _ResultGrid(r: r),
                  const SizedBox(height: 18),
                  // Score breakdown
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Ball hisobi', style: AppTypography.caption),
                      const SizedBox(height: 14),
                      _ScoreRow("Asosiy ball", '${widget.test.scoringConfig.basePoints}', AppColors.primary),
                      _ScoreRow("Aniqlik og'irligi",
                          '${(widget.test.scoringConfig.accuracyWeight * 100).round()}%', AppColors.accent),
                      _ScoreRow("Tezlik og'irligi",
                          '${(widget.test.scoringConfig.timeWeight * 100).round()}%', AppColors.warn),
                      const Divider(color: AppColors.border, height: 20),
                      _ScoreRow('Yakuniy ball', '${r.score}', AppColors.gold),
                    ]),
                  ),
                  const SizedBox(height: 18),
                  // Toggle answers
                  GestureDetector(
                    onTap: () => setState(() => _showAnswers = !_showAnswers),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(_showAnswers ? "Ko'rib chiqishni yopish" : "Javoblarni ko'rish",
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        Icon(_showAnswers ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primary),
                      ]),
                    ),
                  ),
                  if (_showAnswers) ...[
                    const SizedBox(height: 16),
                    ...widget.test.questions.asMap().entries.map((e) => _ReviewQuestion(
                      q: e.value, selected: widget.answers[e.key], index: e.key,
                    )),
                  ],
                  const SizedBox(height: 32),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('Bosh sahifaga qaytish'),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ScoreRow(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTypography.body.copyWith(fontSize: 13)),
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
    ]),
  );
}

class _ResultGrid extends StatelessWidget {
  final TestResult r;
  const _ResultGrid({required this.r});

  static String _fmtTime(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(children: [
      Row(children: [
        _ResultStat('Ball', '${r.score}', Icons.star_rounded, AppColors.gold),
        Container(width: 1, height: 60, color: AppColors.border),
        _ResultStat('Aniqlik', '${r.accuracy.round()}%', Icons.gps_fixed_rounded, AppColors.accent),
      ]),
      Container(height: 1, color: AppColors.border),
      Row(children: [
        _ResultStat("To'g'ri", '${r.correctAnswers}/${r.totalQuestions}',
            Icons.check_circle_outline, AppColors.ok),
        Container(width: 1, height: 60, color: AppColors.border),
        _ResultStat('Vaqt', _fmtTime(r.timeTakenSeconds), Icons.timer_outlined, AppColors.primary),
      ]),
    ]),
  );
}

class _ResultStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _ResultStat(this.label, this.value, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Column(children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(height: 8),
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
      const SizedBox(height: 4),
      Text(label, style: AppTypography.caption.copyWith(fontSize: 11)),
    ]),
  ));
}

class _ReviewQuestion extends StatelessWidget {
  final QuestionModel q;
  final int? selected;
  final int index;
  const _ReviewQuestion({required this.q, required this.selected, required this.index});

  @override
  Widget build(BuildContext context) {
    final isCorrect = selected == q.correctIndex;
    final color = isCorrect ? AppColors.ok : selected == null ? AppColors.text2 : AppColors.danger;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(
              isCorrect ? Icons.check_rounded : selected == null ? Icons.remove_rounded : Icons.close_rounded,
              size: 14, color: color,
            ),
          ),
          const SizedBox(width: 10),
          Text('${index + 1}-savol', style: AppTypography.caption.copyWith(color: AppColors.text2)),
        ]),
        const SizedBox(height: 10),
        Text(q.text, style: const TextStyle(color: AppColors.text1, fontSize: 14,
            fontWeight: FontWeight.w600, height: 1.4)),
        const SizedBox(height: 12),
        if (selected != null && !isCorrect)
          _AnswerRow("Sizning javobingiz", q.options[selected!], AppColors.danger),
        _AnswerRow("To'g'ri javob", q.options[q.correctIndex], AppColors.ok),
        if (q.explanation != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('💡 ', style: TextStyle(fontSize: 12)),
              Expanded(child: Text(q.explanation!, style: AppTypography.body.copyWith(fontSize: 12))),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _AnswerRow(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      Expanded(child: Text(value, style: const TextStyle(color: AppColors.text1, fontSize: 12))),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────
// LEADERBOARD PAGE
// ─────────────────────────────────────────────────────────────
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  @override
  void initState() { super.initState(); _tabs = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;
    final leaderboard = repo.getLeaderboard();
    final myId = AuthService.instance.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          _NexusAppBar(title: 'Reyting', subtitle: '${leaderboard.length} ta ishtirokchi'),
          SliverToBoxAdapter(child: Container(
            color: AppColors.bg,
            child: TabBar(
              controller: _tabs,
              tabs: const [Tab(text: 'Umumiy'), Tab(text: "Test bo'yicha")],
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text2,
              dividerColor: AppColors.border,
            ),
          )),
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.15)),
            ),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, size: 14, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(child: Text('Reyting faqat birinchi urinish ballariga asoslanadi',
                  style: TextStyle(color: AppColors.primary, fontSize: 11))),
            ]),
          )),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _GlobalLeaderboard(leaderboard: leaderboard, myId: myId),
            const _TestLeaderboard(),
          ],
        ),
      ),
    );
  }
}

class _GlobalLeaderboard extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard;
  final String? myId;
  const _GlobalLeaderboard({required this.leaderboard, required this.myId});

  @override
  Widget build(BuildContext context) {
    if (leaderboard.isEmpty) return const _EmptyState(
        icon: Icons.leaderboard_outlined, message: "Hali ishtirokchilar yo'q.\nBirinchi bo'ling!");
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: leaderboard.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) return const _LbHeader();
        final rank = leaderboard[i - 1]['rank'] as int;
        final user = leaderboard[i - 1]['user'] as UserModel;
        return _LbRow(rank: rank, user: user, isMe: user.id == myId);
      },
    );
  }
}

class _LbHeader extends StatelessWidget {
  const _LbHeader();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(color: AppColors.cardHover, borderRadius: BorderRadius.circular(10)),
    child: const Row(children: [
      SizedBox(width: 40, child: Text('#', style: TextStyle(color: AppColors.text3, fontSize: 11, fontWeight: FontWeight.w700))),
      Expanded(flex: 3, child: Text('FOYDALANUVCHI', style: TextStyle(color: AppColors.text3, fontSize: 11, fontWeight: FontWeight.w700))),
      SizedBox(width: 60, child: Text('BALL', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 11, fontWeight: FontWeight.w700))),
      SizedBox(width: 55, child: Text('ANI %', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 11, fontWeight: FontWeight.w700))),
      SizedBox(width: 40, child: Text('TEST', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 11, fontWeight: FontWeight.w700))),
    ]),
  );
}

class _LbRow extends StatelessWidget {
  final int rank;
  final UserModel user;
  final bool isMe;
  const _LbRow({required this.rank, required this.user, required this.isMe});

  Color get _rankColor => rank == 1 ? AppColors.gold : rank == 2 ? AppColors.silver : rank == 3 ? AppColors.bronze : AppColors.text3;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: isMe ? AppColors.primary.withOpacity(0.08) : AppColors.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: isMe ? AppColors.primary.withOpacity(0.35) : AppColors.border),
    ),
    child: Row(children: [
      SizedBox(width: 40, child: rank <= 3
          ? Icon(Icons.emoji_events_rounded, color: _rankColor, size: 20)
          : Text('#$rank', style: TextStyle(color: _rankColor, fontWeight: FontWeight.w700, fontSize: 13))),
      Expanded(flex: 3, child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.primary.withOpacity(0.6), AppColors.primaryDim.withOpacity(0.6),
            ]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(user.initials, style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12))),
        ),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(user.displayName, style: const TextStyle(
                color: AppColors.text1, fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis)),
            if (isMe) ...[
              const SizedBox(width: 4),
              _StatusPill('SIZ', AppColors.primary),
            ],
          ]),
          Row(children: [
            Icon(ScoringService.badgeIcon(user.badge), size: 10,
                color: ScoringService.badgeColor(user.badge)),
            const SizedBox(width: 3),
            Text(user.badge, style: TextStyle(
                color: ScoringService.badgeColor(user.badge), fontSize: 10, fontWeight: FontWeight.w700)),
          ]),
        ])),
      ])),
      SizedBox(width: 60, child: Text('${user.leaderboardScore}', textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w800))),
      SizedBox(width: 55, child: Text('${user.leaderboardAccuracy.toStringAsFixed(1)}%',
          textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600))),
      SizedBox(width: 40, child: Text('${user.firstAttemptTestIds.length}', textAlign: TextAlign.right,
          style: AppTypography.body.copyWith(fontSize: 12))),
    ]),
  );
}

class _TestLeaderboard extends StatefulWidget {
  const _TestLeaderboard();
  @override
  State<_TestLeaderboard> createState() => _TestLeaderboardState();
}

class _TestLeaderboardState extends State<_TestLeaderboard> {
  TestModel? _selected;

  @override
  Widget build(BuildContext context) {
    final tests = AppRepository.instance.getTests();
    if (tests.isEmpty) return const _EmptyState(icon: Icons.quiz_outlined, message: 'Testlar mavjud emas');

    return Column(children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(children: tests.map((t) => GestureDetector(
          onTap: () => setState(() => _selected = t),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _selected?.id == t.id ? AppColors.primary : AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _selected?.id == t.id ? AppColors.primary : AppColors.border),
            ),
            child: Text(t.title, style: TextStyle(
              color: _selected?.id == t.id ? Colors.white : AppColors.text2,
              fontWeight: FontWeight.w600, fontSize: 13,
            )),
          ),
        )).toList()),
      ),
      Expanded(child: _selected == null
          ? const _EmptyState(icon: Icons.touch_app_outlined,
              message: "Test tanlang\nreytingni ko'rish uchun")
          : _buildTestLb(_selected!)),
    ]);
  }

  Widget _buildTestLb(TestModel test) {
    final entries = AppRepository.instance.getTestLeaderboard(test.id);
    if (entries.isEmpty) return const _EmptyState(
        icon: Icons.hourglass_empty_rounded, message: "Bu testni hali\nhech kim topshirmagan");
    final myId = AuthService.instance.currentUser?.id;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: entries.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: AppColors.cardHover, borderRadius: BorderRadius.circular(10)),
          child: const Row(children: [
            SizedBox(width: 36, child: Text('#', style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
            Expanded(flex: 3, child: Text('FOYDALANUVCHI', style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
            SizedBox(width: 55, child: Text('BALL', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
            SizedBox(width: 50, child: Text('ANI %', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
            SizedBox(width: 55, child: Text('VAQT', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
          ]),
        );
        final e = entries[i - 1];
        final r = e['result'] as TestResult;
        final user = e['user'] as UserModel?;
        final rank = e['rank'] as int;
        final isMe = r.userId == myId;
        final rankColor = rank == 1 ? AppColors.gold : rank == 2 ? AppColors.silver
            : rank == 3 ? AppColors.bronze : AppColors.text3;
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary.withOpacity(0.07) : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isMe ? AppColors.primary.withOpacity(0.3) : AppColors.border),
          ),
          child: Row(children: [
            SizedBox(width: 36, child: Text('#$rank', style: TextStyle(
                color: rankColor, fontWeight: FontWeight.w800, fontSize: 13))),
            Expanded(flex: 3, child: Text(user?.displayName ?? 'Foydalanuvchi',
                style: TextStyle(color: isMe ? AppColors.primary : AppColors.text1,
                    fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis)),
            SizedBox(width: 55, child: Text('${r.score}', textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w800))),
            SizedBox(width: 50, child: Text('${r.accuracy.round()}%', textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.accent, fontSize: 12))),
            SizedBox(width: 55, child: Text(
                '${r.timeTakenSeconds ~/ 60}:${(r.timeTakenSeconds % 60).toString().padLeft(2, '0')}',
                textAlign: TextAlign.right,
                style: AppTypography.body.copyWith(fontSize: 11))),
          ]),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROFILE PAGE
// ─────────────────────────────────────────────────────────────
class ProfilePage extends StatefulWidget {
  final AppState appState;
  const ProfilePage({super.key, required this.appState});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final repo = AppRepository.instance;
    final rank = repo.getRankForUser(user.id);
    final results = repo.getResultsForUser(user.id);
    final firstAttempts = results.where((r) => r.isFirstAttempt).toList();
    final retakes = results.where((r) => !r.isFirstAttempt).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 22, right: 22, bottom: 28,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF130E28), AppColors.bg],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Profil', style: AppTypography.h2),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: AppColors.text2),
                  onPressed: () => _confirmLogout(context),
                ),
              ]),
              const SizedBox(height: 24),
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDim]),
                ),
                child: Center(child: Text(user.initials, style: const TextStyle(
                    color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800))),
              ),
              const SizedBox(height: 14),
              Text(user.displayName, style: AppTypography.h1),
              const SizedBox(height: 4),
              Text(user.email, style: AppTypography.body),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(ScoringService.badgeIcon(user.badge),
                    color: ScoringService.badgeColor(user.badge), size: 18),
                const SizedBox(width: 6),
                Text(user.badge, style: TextStyle(
                    color: ScoringService.badgeColor(user.badge),
                    fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(width: 20),
                const Icon(Icons.emoji_events_outlined, color: AppColors.primary, size: 18),
                const SizedBox(width: 4),
                Text("O'rin ${rank == 9999 ? '—' : '#$rank'}", style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 15)),
              ]),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          sliver: SliverList(delegate: SliverChildListDelegate([
            Row(children: [
              Expanded(child: _StatTile('Reyting balli', '${user.leaderboardScore}',
                  Icons.star_rounded, AppColors.gold)),
              const SizedBox(width: 12),
              Expanded(child: _StatTile('Birinchi urinish', '${firstAttempts.length}',
                  Icons.check_circle_outline, AppColors.ok)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _StatTile('Aniqlik',
                  '${user.leaderboardAccuracy.toStringAsFixed(1)}%',
                  Icons.gps_fixed_rounded, AppColors.accent)),
              const SizedBox(width: 12),
              Expanded(child: _StatTile('Qayta urinish', '${retakes.length}',
                  Icons.refresh_rounded, AppColors.warn)),
            ]),
            const SizedBox(height: 28),
            _SectionHeader("Birinchi urinishlar (Reyting)", trailing: '${firstAttempts.length}'),
            const SizedBox(height: 12),
            if (firstAttempts.isEmpty)
              const _EmptyState(icon: Icons.history_rounded, message: 'Hali testlar topshirilmagan')
            else
              ...firstAttempts.map((r) => _ResultTile(result: r, showBadge: true)),
            if (retakes.isNotEmpty) ...[
              const SizedBox(height: 24),
              _SectionHeader('Mashq urinishlar', trailing: '${retakes.length}'),
              const SizedBox(height: 12),
              ...retakes.map((r) => _ResultTile(result: r, showBadge: false)),
            ],
            const SizedBox(height: 40),
          ])),
        ),
      ]),
    );
  }

  void _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Chiqish?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Tizimdan chiqishni xohlaysizmi?',
            style: TextStyle(color: AppColors.text2)),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor qilish')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Chiqish')),
        ],
      ),
    );
    if (confirmed == true) {
      await AuthService.instance.logout();
      widget.appState.refresh();
    }
  }
}

// ─────────────────────────────────────────────────────────────
// ADMIN DASHBOARD
// ─────────────────────────────────────────────────────────────
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;
    final users = repo.getUsers().where((u) => !u.isAdmin).toList();
    final results = repo.getResults();
    final firstAttempts = results.where((r) => r.isFirstAttempt).toList();
    final bannedCount = users.where((u) => u.isBanned).length;
    final activeUsers = users.where((u) => !u.isBanned).toList();
    final avgScore = activeUsers.isEmpty ? 0.0
        : activeUsers.fold(0.0, (s, u) => s + u.leaderboardScore) / activeUsers.length;
    final avgAcc = activeUsers.isEmpty ? 0.0
        : activeUsers.fold(0.0, (s, u) => s + u.leaderboardAccuracy) / activeUsers.length;

    // Faol foydalanuvchilar (so'nggi 7 kun)
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentActive = users.where((u) =>
        u.lastActiveAt != null && u.lastActiveAt!.isAfter(weekAgo)).length;

    final topUsers = List<UserModel>.from(activeUsers)
      ..sort((a, b) => b.leaderboardScore.compareTo(a.leaderboardScore));

    // Shubhali: 98%+ aniqlik VA ko'p testlar (bu haqiqiy shubhali ko'rsatkich)
    final suspicious = users.where((u) =>
        !u.isBanned &&
        u.leaderboardAccuracy > 98.0 &&
        u.firstAttemptTestIds.length >= 3).toList();

    final admin = AuthService.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.card,
        onRefresh: () async => setState(() {}),
        child: CustomScrollView(slivers: [
          _NexusAppBar(title: 'Admin Boshqaruvi', subtitle: 'Tahlil va nazorat'),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(delegate: SliverChildListDelegate([
              // Admin info
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                ),
                child: Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(admin?.displayName ?? 'Administrator', style: AppTypography.h3),
                    Text(admin?.email ?? '', style: AppTypography.body),
                  ])),
                  TextButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: const Text('Chiqish'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.text2),
                  ),
                ]),
              ),
              // Metriklar
              _buildMetricGrid(users, results, firstAttempts, avgScore, avgAcc, bannedCount, recentActive),
              const SizedBox(height: 24),
              _SectionHeader('Top foydalanuvchilar', trailing: null),
              const SizedBox(height: 12),
              if (topUsers.isEmpty)
                const _EmptyState(icon: Icons.people_outline, message: "Foydalanuvchilar yo'q")
              else
                ...topUsers.take(5).toList().asMap().entries.map(
                    (e) => _TopUserTile(rank: e.key + 1, user: e.value)),
              const SizedBox(height: 24),
              _SectionHeader('⚠️ Shubhali foydalanuvchilar',
                  trailing: suspicious.isEmpty ? null : '${suspicious.length}'),
              const SizedBox(height: 4),
              Text('98%+ aniqlik, 3+ test', style: AppTypography.caption.copyWith(color: AppColors.text3)),
              const SizedBox(height: 12),
              if (suspicious.isEmpty)
                const _EmptyState(icon: Icons.verified_user_outlined, message: 'Shubhali faoliyat aniqlanmadi')
              else
                ...suspicious.map((u) => _SuspiciousTile(user: u)),
              const SizedBox(height: 32),
            ])),
          ),
        ]),
      ),
    );
  }

  Widget _buildMetricGrid(List<UserModel> users, List<TestResult> results,
      List<TestResult> firstAttempts, double avgScore, double avgAcc,
      int bannedCount, int recentActive) {
    final tests = AppRepository.instance.getTests();
    return Column(children: [
      Row(children: [
        Expanded(child: _AdminMetric("Foydalanuvchilar", '${users.length}', Icons.people_rounded, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _AdminMetric('Jami testlar', '${tests.length}', Icons.quiz_rounded, AppColors.accent)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _AdminMetric("Jami urinish", '${results.length}', Icons.assignment_rounded, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _AdminMetric("Birinchi urinish", '${firstAttempts.length}', Icons.looks_one_rounded, AppColors.ok)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _AdminMetric("O'rt. ball", avgScore.round().toString(), Icons.bar_chart_rounded, AppColors.gold)),
        const SizedBox(width: 12),
        Expanded(child: _AdminMetric("O'rt. aniqlik", '${avgAcc.toStringAsFixed(1)}%', Icons.gps_fixed_rounded, AppColors.accent)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _AdminMetric('Bloklangan', '$bannedCount', Icons.block_rounded, AppColors.danger)),
        const SizedBox(width: 12),
        Expanded(child: _AdminMetric('7-kun aktiv', '$recentActive', Icons.online_prediction_rounded, AppColors.ok)),
      ]),
    ]);
  }

  void _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Chiqish?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Tizimdan chiqishni xohlaysizmi?', style: TextStyle(color: AppColors.text2)),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor qilish')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Chiqish')),
        ],
      ),
    );
    if (confirmed == true) await AuthService.instance.logout();
  }
}

class _AdminMetric extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _AdminMetric(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 10),
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
      const SizedBox(height: 3),
      Text(label, style: AppTypography.body.copyWith(fontSize: 11)),
    ]),
  );
}

class _TopUserTile extends StatelessWidget {
  final int rank;
  final UserModel user;
  const _TopUserTile({required this.rank, required this.user});

  @override
  Widget build(BuildContext context) {
    final rankColor = rank == 1 ? AppColors.gold : rank == 2 ? AppColors.silver
        : rank == 3 ? AppColors.bronze : AppColors.text2;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        rank <= 3
            ? Icon(Icons.emoji_events_rounded, color: rankColor, size: 22)
            : Text('#$rank', style: TextStyle(color: rankColor, fontWeight: FontWeight.w700)),
        const SizedBox(width: 12),
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.primary.withOpacity(0.6), AppColors.primaryDim.withOpacity(0.6),
            ]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(user.initials, style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(user.displayName, style: AppTypography.h3.copyWith(fontSize: 14)),
          Text('${user.leaderboardScore} ball · ${user.leaderboardAccuracy.toStringAsFixed(1)}% aniqlik',
              style: AppTypography.body.copyWith(fontSize: 12)),
        ])),
        _BadgeChip(user.badge),
      ]),
    );
  }
}

class _SuspiciousTile extends StatelessWidget {
  final UserModel user;
  const _SuspiciousTile({required this.user});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.card, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.warn.withOpacity(0.3)),
    ),
    child: Row(children: [
      const Icon(Icons.warning_amber_rounded, color: AppColors.warn, size: 24),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(user.displayName, style: AppTypography.h3.copyWith(fontSize: 14)),
        Text('Aniqlik: ${user.leaderboardAccuracy.toStringAsFixed(1)}% · ${user.firstAttemptTestIds.length} test',
            style: AppTypography.body.copyWith(fontSize: 12)),
      ])),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────
// ADMIN USERS PAGE
// ─────────────────────────────────────────────────────────────
class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});
  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _sortBy = 'score'; // score | alpha | joined

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final repo = AppRepository.instance;
    var allUsers = repo.getUsers().where((u) => !u.isAdmin).toList();

    // Sort
    switch (_sortBy) {
      case 'alpha': allUsers.sort((a, b) => a.displayName.compareTo(b.displayName)); break;
      case 'joined': allUsers.sort((a, b) => b.joinedAt.compareTo(a.joinedAt)); break;
      default: allUsers.sort((a, b) => b.leaderboardScore.compareTo(a.leaderboardScore));
    }

    final filtered = allUsers.where((u) =>
        u.displayName.toLowerCase().contains(_query.toLowerCase()) ||
        u.email.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(slivers: [
        _NexusAppBar(title: 'Foydalanuvchilar', subtitle: '${allUsers.length} ta'),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Qidirish...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.text3, size: 20),
                suffixIcon: _query.isNotEmpty ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.text3),
                  onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                ) : null,
              ),
            )),
            const SizedBox(width: 10),
            PopupMenuButton<String>(
              color: AppColors.card,
              onSelected: (v) => setState(() => _sortBy = v),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'score', child: Text("Ball bo'yicha")),
                const PopupMenuItem(value: 'alpha', child: Text("Alifbo bo'yicha")),
                const PopupMenuItem(value: 'joined', child: Text("Yangi kelganlar")),
              ],
              child: Container(
                width: 42, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.card, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.sort_rounded, color: AppColors.text2, size: 20),
              ),
            ),
          ]),
        )),
        if (filtered.isEmpty)
          const SliverFillRemaining(child: _EmptyState(icon: Icons.people_outline, message: 'Foydalanuvchi topilmadi'))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            sliver: SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) => _AdminUserTile(
                user: filtered[i],
                onTap: () => _showUserDetail(context, filtered[i]),
                onRefresh: () => setState(() {}),
              ),
              childCount: filtered.length,
            )),
          ),
      ]),
    );
  }

  void _showUserDetail(BuildContext context, UserModel user) {
    final results = AppRepository.instance.getResultsForUser(user.id);
    final firstAttempts = results.where((r) => r.isFirstAttempt).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85, maxChildSize: 0.95, minChildSize: 0.5,
        expand: false,
        builder: (_, ctrl) => Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(
              color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDim]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text(user.initials, style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.displayName, style: AppTypography.h2),
                Text(user.email, style: AppTypography.body),
                Text("Qo'shilgan: ${user.joinedAt.day}/${user.joinedAt.month}/${user.joinedAt.year}",
                    style: AppTypography.caption.copyWith(color: AppColors.text3)),
              ])),
              _BadgeChip(user.badge),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              _MiniStat('Ball', '${user.leaderboardScore}', AppColors.gold),
              _MiniStat('Birinchi', '${firstAttempts.length}', AppColors.ok),
              _MiniStat('Aniqlik', '${user.leaderboardAccuracy.toStringAsFixed(0)}%', AppColors.accent),
            ]),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          // Results header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(children: const [
              Expanded(flex: 3, child: Text('TEST', style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
              SizedBox(width: 50, child: Text('BALL', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
              SizedBox(width: 50, child: Text('ANI %', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
              SizedBox(width: 50, child: Text('TUR', textAlign: TextAlign.right, style: TextStyle(color: AppColors.text3, fontSize: 10, fontWeight: FontWeight.w700))),
            ]),
          ),
          Expanded(child: ListView(
            controller: ctrl,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: results.isEmpty
                ? [const _EmptyState(icon: Icons.history_rounded, message: "Natijalar yo'q")]
                : results.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [
                      Expanded(flex: 3, child: Text(r.testTitle,
                          style: const TextStyle(color: AppColors.text1, fontSize: 12),
                          overflow: TextOverflow.ellipsis)),
                      SizedBox(width: 50, child: Text('${r.score}', textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700))),
                      SizedBox(width: 50, child: Text('${r.accuracy.round()}%', textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColors.accent, fontSize: 12))),
                      SizedBox(width: 50, child: Text(r.isFirstAttempt ? '1-chi' : 'Mashq',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: r.isFirstAttempt ? AppColors.ok : AppColors.warn,
                              fontSize: 11, fontWeight: FontWeight.w700))),
                    ]),
                  )).toList(),
          )),
        ]),
      ),
    );
  }
}

class _AdminUserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap, onRefresh;
  const _AdminUserTile({required this.user, required this.onTap, required this.onRefresh});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: user.isBanned ? AppColors.danger.withOpacity(0.3) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.primary.withOpacity(0.6), AppColors.primaryDim.withOpacity(0.6),
              ]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(user.initials, style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(user.displayName, style: AppTypography.h3.copyWith(fontSize: 14)),
              if (user.isBanned) ...[
                const SizedBox(width: 6),
                _StatusPill('BLOKLANGAN', AppColors.danger),
              ],
            ]),
            Text(user.email, style: AppTypography.body.copyWith(fontSize: 11)),
          ])),
          _BadgeChip(user.badge),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _MiniStat('Ball', '${user.leaderboardScore}', AppColors.gold),
          _MiniStat('Testlar', '${user.firstAttemptTestIds.length}', AppColors.ok),
          _MiniStat('Aniq', '${user.leaderboardAccuracy.toStringAsFixed(0)}%', AppColors.accent),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          _AdminAction('Nishon', Icons.military_tech_rounded, AppColors.primary,
              () => _changeBadge(context)),
          const SizedBox(width: 8),
          _AdminAction(user.isBanned ? 'Ochish' : 'Bloklash',
              Icons.gavel_rounded, AppColors.danger, () => _toggleBan(context)),
          const SizedBox(width: 8),
          _AdminAction('Reset', Icons.restart_alt_rounded, AppColors.warn,
              () => _resetScore(context)),
        ]),
      ]),
    ),
  );

  void _changeBadge(BuildContext context) {
    const badges = ['Yangi', 'Bronza', 'Kumush', 'Oltin', 'Platina', 'Olmaz', 'Afsona'];
    final admin = AuthService.instance.currentUser;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4, decoration: BoxDecoration(
            color: AppColors.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 16),
        const Text('Nishon belgilash', style: AppTypography.h3),
        const SizedBox(height: 8),
        ...badges.map((b) => ListTile(
          leading: Icon(ScoringService.badgeIcon(b), color: ScoringService.badgeColor(b)),
          title: Text(b, style: TextStyle(
              color: ScoringService.badgeColor(b), fontWeight: FontWeight.w700)),
          trailing: user.badge == b ? const Icon(Icons.check_rounded, color: AppColors.ok) : null,
          onTap: () async {
            final oldBadge = user.badge;
            await AppRepository.instance.upsertUser(user.copyWith(badge: b));
            if (admin != null) {
              await AppRepository.instance.addAdminLog(AdminLog(
                id: 'log_${DateTime.now().millisecondsSinceEpoch}',
                adminId: admin.id, adminName: admin.displayName,
                action: 'BADGE_CHANGE', targetId: user.id, targetName: user.displayName,
                details: '$oldBadge → $b',
              ));
            }
            if (context.mounted) { Navigator.pop(context); onRefresh(); }
          },
        )),
        const SizedBox(height: 16),
      ]),
    );
  }

  void _toggleBan(BuildContext context) {
    final admin = AuthService.instance.currentUser;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(user.isBanned ? 'Blokni ochish?' : 'Bloklash?',
            style: TextStyle(color: user.isBanned ? AppColors.ok : AppColors.danger,
                fontWeight: FontWeight.w700)),
        content: Text(user.isBanned
            ? "Foydalanuvchi tizimga kirishga ruxsat oladi."
            : "Foydalanuvchi tizimga kira olmaydi.",
            style: AppTypography.body),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
          TextButton(
            onPressed: () async {
              await AppRepository.instance.upsertUser(user.copyWith(isBanned: !user.isBanned));
              if (admin != null) {
                await AppRepository.instance.addAdminLog(AdminLog(
                  id: 'log_${DateTime.now().millisecondsSinceEpoch}',
                  adminId: admin.id, adminName: admin.displayName,
                  action: user.isBanned ? 'UNBAN' : 'BAN',
                  targetId: user.id, targetName: user.displayName,
                  details: user.isBanned ? 'Blok ochildi' : 'Foydalanuvchi bloklandi',
                ));
              }
              if (context.mounted) { Navigator.pop(context); onRefresh(); }
            },
            child: Text(user.isBanned ? 'Blokni ochish' : 'Bloklash',
                style: TextStyle(color: user.isBanned ? AppColors.ok : AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _resetScore(BuildContext context) {
    final admin = AuthService.instance.currentUser;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Ballni nolga tushirish?",
            style: TextStyle(color: AppColors.warn, fontWeight: FontWeight.w700)),
        content: Text("${user.displayName} ning barcha reyting bali va natijalar tarixidan o'chiriladi.",
            style: AppTypography.body),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
          TextButton(
            onPressed: () async {
              await AppRepository.instance.upsertUser(user.copyWith(
                leaderboardScore: 0, leaderboardAccuracy: 0.0,
                totalAttempts: 0, firstAttemptTestIds: [], badge: 'Yangi',
              ));
              if (admin != null) {
                await AppRepository.instance.addAdminLog(AdminLog(
                  id: 'log_${DateTime.now().millisecondsSinceEpoch}',
                  adminId: admin.id, adminName: admin.displayName,
                  action: 'RESET_SCORE', targetId: user.id, targetName: user.displayName,
                  details: 'Ball va statistika nolga tushirildi',
                ));
              }
              if (context.mounted) { Navigator.pop(context); onRefresh(); }
            },
            child: const Text("Tasdiqlash", style: TextStyle(color: AppColors.warn)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ADMIN TESTS PAGE
// ─────────────────────────────────────────────────────────────
class AdminTestsPage extends StatefulWidget {
  const AdminTestsPage({super.key});
  @override
  State<AdminTestsPage> createState() => _AdminTestsPageState();
}

class _AdminTestsPageState extends State<AdminTestsPage> {
  @override
  Widget build(BuildContext context) {
    final tests = AppRepository.instance.getTests();
    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, null),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yangi test', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(slivers: [
        _NexusAppBar(title: 'Test boshqaruvi', subtitle: '${tests.length} ta test'),
        if (tests.isEmpty)
          const SliverFillRemaining(child: _EmptyState(icon: Icons.quiz_outlined,
              message: "Testlar yo'q.\n+ tugmasini bosib yangi test yarating"))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            sliver: SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) => _AdminTestCard(
                test: tests[i],
                onEdit: () => _openEditor(context, tests[i]),
                onViewStats: () => _showTestStats(context, tests[i]),
                onRefresh: () => setState(() {}),
              ),
              childCount: tests.length,
            )),
          ),
      ]),
    );
  }

  void _openEditor(BuildContext context, TestModel? existing) async {
    await Navigator.push(context, MaterialPageRoute(
        builder: (_) => TestEditorScreen(test: existing)));
    setState(() {});
  }

  void _showTestStats(BuildContext context, TestModel test) {
    final repo = AppRepository.instance;
    final entries = repo.getTestLeaderboard(test.id);
    final allResults = repo.getResultsForTest(test.id);
    final retakes = allResults.where((r) => !r.isFirstAttempt).length;
    final avgScore = entries.isEmpty ? 0 :
        entries.fold(0, (s, e) => s + (e['result'] as TestResult).score) ~/ entries.length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85, maxChildSize: 0.95, minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(
              color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(test.title, style: AppTypography.h2),
              const SizedBox(height: 6),
              Row(children: [
                _Tag(test.difficulty.label, test.difficulty.color),
                const SizedBox(width: 8),
                _Tag('${entries.length} ishtirokchi', AppColors.primary),
                const SizedBox(width: 8),
                _Tag("O'rt: $avgScore ball", AppColors.gold),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              _MiniStat('Birinchi', '${entries.length}', AppColors.ok),
              _MiniStat('Mashq', '$retakes', AppColors.warn),
              _MiniStat('Jami', '${allResults.length}', AppColors.primary),
            ]),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border),
          Expanded(
            child: entries.isEmpty
                ? const _EmptyState(icon: Icons.hourglass_empty_rounded, message: "Hali natijalar yo'q")
                : ListView.builder(
                    controller: ctrl,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: entries.length,
                    itemBuilder: (_, i) {
                      final e = entries[i];
                      final r = e['result'] as TestResult;
                      final user = e['user'] as UserModel?;
                      final rank = e['rank'] as int;
                      final rankColor = rank == 1 ? AppColors.gold : rank == 2 ? AppColors.silver
                          : rank == 3 ? AppColors.bronze : AppColors.text3;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(children: [
                          SizedBox(width: 36, child: Text('#$rank', style: TextStyle(
                              color: rankColor, fontWeight: FontWeight.w700, fontSize: 13))),
                          Expanded(flex: 2, child: Text(user?.displayName ?? 'Foydalanuvchi',
                              style: const TextStyle(color: AppColors.text1, fontSize: 12),
                              overflow: TextOverflow.ellipsis)),
                          SizedBox(width: 55, child: Text('${r.score}', textAlign: TextAlign.right,
                              style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w700))),
                          SizedBox(width: 45, child: Text('${r.accuracy.round()}%', textAlign: TextAlign.right,
                              style: const TextStyle(color: AppColors.accent, fontSize: 12))),
                          SizedBox(width: 55, child: Text(
                              '${r.timeTakenSeconds ~/ 60}:${(r.timeTakenSeconds % 60).toString().padLeft(2, '0')}',
                              textAlign: TextAlign.right,
                              style: AppTypography.body.copyWith(fontSize: 11))),
                        ]),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}

class _AdminTestCard extends StatelessWidget {
  final TestModel test;
  final VoidCallback onEdit, onViewStats, onRefresh;
  const _AdminTestCard({required this.test, required this.onEdit, required this.onViewStats, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final results = AppRepository.instance.getResultsForTest(test.id);
    final firstAttempts = results.where((r) => r.isFirstAttempt).length;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: test.isOpen ? AppColors.ok.withOpacity(0.2) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(test.title, style: AppTypography.h3.copyWith(fontSize: 16)),
            const SizedBox(height: 2),
            _Tag(test.category, AppColors.primary),
          ])),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(test.isOpen ? 'Ochiq' : 'Yopiq',
                style: TextStyle(color: test.isOpen ? AppColors.ok : AppColors.text3,
                    fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Switch(
              value: test.isOpen,
              onChanged: (_) => _toggleOpen(context),
            ),
          ]),
        ]),
        const SizedBox(height: 6),
        Text(test.description, style: AppTypography.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.star_outline_rounded, size: 13, color: AppColors.gold),
          const SizedBox(width: 4),
          Text('${test.scoringConfig.basePoints} ball',
              style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(width: 12),
          const Icon(Icons.people_outline_rounded, size: 13, color: AppColors.accent),
          const SizedBox(width: 4),
          Text('$firstAttempts ishtirokchi',
              style: const TextStyle(color: AppColors.accent, fontSize: 11)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          _Tag(test.difficulty.label, test.difficulty.color),
          const SizedBox(width: 8),
          _Tag('${test.questions.length} savol', AppColors.text2),
          const Spacer(),
          TextButton.icon(icon: const Icon(Icons.bar_chart_rounded, size: 16),
              label: const Text('Natijalar'), onPressed: onViewStats,
              style: TextButton.styleFrom(foregroundColor: AppColors.accent, padding: EdgeInsets.zero)),
          TextButton.icon(icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Tahrirlash'), onPressed: onEdit,
              style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero)),
          TextButton.icon(icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text("O'chirish"), onPressed: () => _confirmDelete(context),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger, padding: EdgeInsets.zero)),
        ]),
      ]),
    );
  }

  void _toggleOpen(BuildContext context) async {
    final admin = AuthService.instance.currentUser;
    final updated = test.copyWith(isOpen: !test.isOpen);
    await AppRepository.instance.upsertTest(updated);
    if (admin != null) {
      await AppRepository.instance.addAdminLog(AdminLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        adminId: admin.id, adminName: admin.displayName,
        action: test.isOpen ? 'TEST_CLOSE' : 'TEST_OPEN',
        targetId: test.id, targetName: test.title,
        details: test.isOpen ? 'Test yopildi' : 'Test ochildi',
      ));
    }
    onRefresh();
  }

  void _confirmDelete(BuildContext context) => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Testni o'chirish?", style: TextStyle(fontWeight: FontWeight.w700)),
      content: Text('"${test.title}" o\'chiriladi. Bu amalni bekor qilib bo\'lmaydi.',
          style: AppTypography.body),
      actions: [
        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Bekor qilish')),
        TextButton(
          onPressed: () async {
            final admin = AuthService.instance.currentUser;
            await AppRepository.instance.deleteTest(test.id);
            if (admin != null) {
              await AppRepository.instance.addAdminLog(AdminLog(
                id: 'log_${DateTime.now().millisecondsSinceEpoch}',
                adminId: admin.id, adminName: admin.displayName,
                action: 'TEST_DELETE', targetId: test.id, targetName: test.title,
                details: "Test o'chirildi",
              ));
            }
            if (context.mounted) { Navigator.pop(context); onRefresh(); }
          },
          child: const Text("O'chirish", style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// ADMIN LOGS PAGE
// ─────────────────────────────────────────────────────────────
class AdminLogsPage extends StatefulWidget {
  const AdminLogsPage({super.key});
  @override
  State<AdminLogsPage> createState() => _AdminLogsPageState();
}

class _AdminLogsPageState extends State<AdminLogsPage> {
  String _filterAction = 'Barchasi';
  static const _actionFilters = [
    'Barchasi', 'LOGIN', 'LOGOUT', 'BAN', 'UNBAN',
    'BADGE_CHANGE', 'RESET_SCORE', 'TEST_CREATE', 'TEST_EDIT',
    'TEST_DELETE', 'TEST_OPEN', 'TEST_CLOSE',
  ];

  Color _actionColor(String a) => const {
    'LOGIN': AppColors.ok, 'LOGOUT': AppColors.text2, 'BAN': AppColors.danger,
    'UNBAN': AppColors.ok, 'BADGE_CHANGE': AppColors.gold, 'RESET_SCORE': AppColors.warn,
    'TEST_CREATE': AppColors.ok, 'TEST_EDIT': AppColors.primary,
    'TEST_DELETE': AppColors.danger, 'TEST_OPEN': AppColors.ok, 'TEST_CLOSE': AppColors.warn,
  }[a] ?? AppColors.primary;

  IconData _actionIcon(String a) => const {
    'LOGIN': Icons.login_rounded, 'LOGOUT': Icons.logout_rounded,
    'BAN': Icons.block_rounded, 'UNBAN': Icons.check_circle_rounded,
    'BADGE_CHANGE': Icons.military_tech_rounded, 'RESET_SCORE': Icons.restart_alt_rounded,
    'TEST_CREATE': Icons.add_circle_rounded, 'TEST_EDIT': Icons.edit_rounded,
    'TEST_DELETE': Icons.delete_rounded, 'TEST_OPEN': Icons.lock_open_rounded,
    'TEST_CLOSE': Icons.lock_rounded,
  }[a] ?? Icons.admin_panel_settings_rounded;

  @override
  Widget build(BuildContext context) {
    final allLogs = AppRepository.instance.getAdminLogs();
    final filtered = _filterAction == 'Barchasi'
        ? allLogs : allLogs.where((l) => l.action == _filterAction).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(slivers: [
        _NexusAppBar(title: 'Admin Loglari', subtitle: '${allLogs.length} ta yozuv'),
        SliverToBoxAdapter(child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(children: _actionFilters.map((a) {
            final isActive = _filterAction == a;
            final color = a == 'Barchasi' ? AppColors.primary : _actionColor(a);
            return GestureDetector(
              onTap: () => setState(() => _filterAction = a),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? color : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isActive ? color : AppColors.border),
                ),
                child: Text(a, style: TextStyle(
                    color: isActive ? Colors.white : AppColors.text2,
                    fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            );
          }).toList()),
        )),
        if (filtered.isEmpty)
          const SliverFillRemaining(child: _EmptyState(icon: Icons.history_rounded, message: "Loglar yo'q"))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) {
                final log = filtered[i];
                final color = _actionColor(log.action);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                          color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                      child: Icon(_actionIcon(log.action), color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                          child: Text(log.action, style: TextStyle(
                              color: color, fontSize: 10, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(log.targetName, style: const TextStyle(
                            color: AppColors.text1, fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis)),
                      ]),
                      const SizedBox(height: 3),
                      Text(log.details, style: AppTypography.body.copyWith(fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(_fmtTime(log.timestamp), style: AppTypography.caption.copyWith(color: AppColors.text3)),
                    ])),
                  ]),
                );
              },
              childCount: filtered.length,
            )),
          ),
      ]),
    );
  }

  String _fmtTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'Hozir';
    if (diff.inHours < 1)   return '${diff.inMinutes} daqiqa oldin';
    if (diff.inDays < 1)    return '${diff.inHours} soat oldin';
    return '${t.day}/${t.month}/${t.year} ${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';
  }
}

// ─────────────────────────────────────────────────────────────
// TEST EDITOR — To'liq qayta yozilgan
// ─────────────────────────────────────────────────────────────
class TestEditorScreen extends StatefulWidget {
  final TestModel? test;
  const TestEditorScreen({super.key, this.test});
  @override
  State<TestEditorScreen> createState() => _TestEditorScreenState();
}

class _TestEditorScreenState extends State<TestEditorScreen> {
  final _titleCtrl    = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _timeCtrl     = TextEditingController();
  Difficulty _difficulty = Difficulty.orta;
  bool _isOpen = true;
  List<_QDraft> _questions = [];
  bool _saving = false;
  int _basePoints = 100;
  double _accWeight = 0.7;
  double _timeWeight = 0.3;

  static const _defaultCategories = [
    'Dasturlash', 'Matematika', "Sun'iy Intellekt",
    'Fizika', 'Kimyo', 'Tarix', 'Iqtisodiyot', 'Umumiy',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.test != null) {
      final t = widget.test!;
      _titleCtrl.text    = t.title;
      _descCtrl.text     = t.description;
      _categoryCtrl.text = t.category;
      _timeCtrl.text     = '${t.timeLimitSeconds ~/ 60}';
      _difficulty = t.difficulty;
      _isOpen     = t.isOpen;
      _basePoints = t.scoringConfig.basePoints;
      _accWeight  = t.scoringConfig.accuracyWeight;
      _timeWeight = t.scoringConfig.timeWeight;
      _questions  = t.questions.map((q) => _QDraft.fromModel(q)).toList();
    } else {
      _questions = [_QDraft.empty()];
      _categoryCtrl.text = 'Umumiy';
      _timeCtrl.text     = '10';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _descCtrl.dispose();
    _categoryCtrl.dispose(); _timeCtrl.dispose();
    for (final q in _questions) { q.dispose(); }
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) { _snack('Sarlavha kiritish shart'); return; }
    if (title.length < 3) { _snack("Sarlavha kamida 3 ta belgi bo'lishi kerak"); return; }
    if (_questions.isEmpty) { _snack("Kamida bitta savol qo'shing"); return; }

    final timeLimitMins = int.tryParse(_timeCtrl.text) ?? 0;
    if (timeLimitMins <= 0) { _snack("Vaqt limitini kiriting (daqiqa)"); return; }
    if (timeLimitMins > 180) { _snack("Vaqt limiti 180 daqiqadan oshmasin"); return; }

    // Savollarni tekshirish
    for (var i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      if (q.textCtrl.text.trim().isEmpty) {
        _snack('${i + 1}-savol matni kiritilmagan'); return;
      }
      if (q.options.any((o) => o.ctrl.text.trim().isEmpty)) {
        _snack('${i + 1}-savolning barcha variantlarini to\'ldiring'); return;
      }
      if (q.options.length < 2) {
        _snack("${i + 1}-savolda kamida 2 ta variant bo'lishi kerak"); return;
      }
    }

    setState(() => _saving = true);
    final isNew = widget.test == null;
    final test = TestModel.create(
      id: widget.test?.id ?? 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: SecurityUtils.sanitize(title),
      description: SecurityUtils.sanitize(_descCtrl.text.trim()),
      category: _categoryCtrl.text.trim().isEmpty ? 'Umumiy'
          : SecurityUtils.sanitize(_categoryCtrl.text.trim()),
      difficulty: _difficulty,
      isOpen: _isOpen,
      timeLimitSeconds: timeLimitMins * 60,
      scoringConfig: ScoringConfig(
          basePoints: _basePoints, accuracyWeight: _accWeight, timeWeight: _timeWeight),
      questions: _questions.asMap().entries.map((e) => QuestionModel(
        id: 'q${e.key + 1}',
        text: SecurityUtils.sanitize(e.value.textCtrl.text.trim()),
        options: e.value.options.map((o) => SecurityUtils.sanitize(o.ctrl.text.trim())).toList(),
        correctIndex: e.value.correctIndex,
        explanation: e.value.explanationCtrl.text.trim().isEmpty
            ? null : SecurityUtils.sanitize(e.value.explanationCtrl.text.trim()),
      )).toList(),
    );

    await AppRepository.instance.upsertTest(test);
    final admin = AuthService.instance.currentUser;
    if (admin != null) {
      await AppRepository.instance.addAdminLog(AdminLog(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        adminId: admin.id, adminName: admin.displayName,
        action: isNew ? 'TEST_CREATE' : 'TEST_EDIT',
        targetId: test.id, targetName: test.title,
        details: isNew ? "Yangi test yaratildi (${test.questions.length} savol)" : "Test tahrirlandi",
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(
      title: Text(widget.test == null ? 'Yangi test' : 'Testni tahrirlash'),
      actions: [
        TextButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(height: 16, width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Saqlash', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _InputField(controller: _titleCtrl, label: 'Test sarlavhasi',
            hint: 'Masalan: Flutter Advanced', icon: Icons.title_rounded),
        const SizedBox(height: 14),
        _InputField(controller: _descCtrl, label: 'Tavsif',
            hint: 'Test haqida qisqacha...', icon: Icons.description_rounded, maxLines: 2),
        const SizedBox(height: 14),
        _InputField(controller: _categoryCtrl, label: 'Kategoriya',
            hint: 'Masalan: Matematika', icon: Icons.category_outlined),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: _defaultCategories.map((c) => GestureDetector(
            onTap: () => setState(() => _categoryCtrl.text = c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _categoryCtrl.text == c ? AppColors.accent : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _categoryCtrl.text == c ? AppColors.accent : AppColors.border),
              ),
              child: Text(c, style: TextStyle(
                  color: _categoryCtrl.text == c ? Colors.white : AppColors.text2,
                  fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          )).toList()),
        ),
        const SizedBox(height: 14),
        _InputField(controller: _timeCtrl, label: 'Vaqt limiti (daqiqa)',
            hint: '10', icon: Icons.timer_outlined, keyboardType: TextInputType.number),
        const SizedBox(height: 20),
        const Text('Qiyinlik darajasi', style: AppTypography.h3),
        const SizedBox(height: 10),
        Row(children: Difficulty.values.map((d) => GestureDetector(
          onTap: () => setState(() => _difficulty = d),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _difficulty == d ? d.color : AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _difficulty == d ? d.color : AppColors.border),
            ),
            child: Text(d.label, style: TextStyle(
                color: _difficulty == d ? Colors.white : AppColors.text2,
                fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        )).toList()),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Test ochiq', style: AppTypography.h3),
          Switch(value: _isOpen, onChanged: (v) => setState(() => _isOpen = v)),
        ]),
        const Divider(color: AppColors.border, height: 32),
        const Text('⚡ Ball konfiguratsiyasi', style: AppTypography.h2),
        const SizedBox(height: 6),
        Text('Bu test uchun ball hisobi sozlamalari',
            style: AppTypography.body.copyWith(fontSize: 13)),
        const SizedBox(height: 16),
        _ScoringConfigCard(
          basePoints: _basePoints,
          accWeight: _accWeight,
          timeWeight: _timeWeight,
          onBaseChanged: (v) => setState(() => _basePoints = v),
          onAccChanged: (v) => setState(() {
            _accWeight = v;
            _timeWeight = double.parse((1.0 - v).toStringAsFixed(2));
          }),
          onTimeChanged: (v) => setState(() {
            _timeWeight = v;
            _accWeight = double.parse((1.0 - v).toStringAsFixed(2));
          }),
        ),
        const Divider(color: AppColors.border, height: 32),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Savollar (${_questions.length})', style: AppTypography.h2),
          TextButton.icon(
            onPressed: () => setState(() => _questions.add(_QDraft.empty())),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text("Qo'shish"),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ]),
        const SizedBox(height: 10),
        ..._questions.asMap().entries.map((e) => _QuestionEditor(
          draft: e.value,
          index: e.key,
          onDelete: _questions.length > 1 ? () => setState(() => _questions.removeAt(e.key)) : null,
          onUpdate: () => setState(() {}),
        )),
        const SizedBox(height: 40),
      ]),
    ),
  );
}

class _ScoringConfigCard extends StatelessWidget {
  final int basePoints;
  final double accWeight, timeWeight;
  final ValueChanged<int> onBaseChanged;
  final ValueChanged<double> onAccChanged, onTimeChanged;
  const _ScoringConfigCard({required this.basePoints, required this.accWeight,
      required this.timeWeight, required this.onBaseChanged,
      required this.onAccChanged, required this.onTimeChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
    ),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Asosiy ball', style: AppTypography.bodyBold),
          Text('Maksimal mumkin ball', style: AppTypography.caption.copyWith(color: AppColors.text3)),
        ]),
        Row(children: [
          _CircleBtn(Icons.remove_rounded, () => onBaseChanged((basePoints - 50).clamp(50, 1000))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text('$basePoints', style: const TextStyle(
                  color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 18))),
          _CircleBtn(Icons.add_rounded, () => onBaseChanged((basePoints + 50).clamp(50, 1000)),
              primary: true),
        ]),
      ]),
      const SizedBox(height: 18),
      _WeightSlider("Aniqlik og'irligi", accWeight, AppColors.accent, onAccChanged),
      const SizedBox(height: 12),
      _WeightSlider("Tezlik og'irligi", timeWeight, AppColors.warn, onTimeChanged),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.cardHover, borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          const Icon(Icons.calculate_outlined, size: 15, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('100% + tez → ~${(basePoints * (accWeight + timeWeight * 0.9)).round()} ball',
              style: AppTypography.body.copyWith(fontSize: 12)),
        ]),
      ),
    ]),
  );
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  const _CircleBtn(this.icon, this.onTap, {this.primary = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30, height: 30,
      decoration: BoxDecoration(
        color: primary ? AppColors.primary : AppColors.cardHover,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: primary ? Colors.white : AppColors.text2),
    ),
  );
}

class _WeightSlider extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;
  const _WeightSlider(this.label, this.value, this.color, this.onChanged);

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTypography.body.copyWith(fontSize: 13)),
      Text('${(value * 100).round()}%', style: TextStyle(
          color: color, fontWeight: FontWeight.w700, fontSize: 13)),
    ]),
    SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: color, thumbColor: color,
        inactiveTrackColor: color.withOpacity(0.2),
        overlayColor: color.withOpacity(0.1),
        trackHeight: 4,
      ),
      child: Slider(value: value, min: 0.1, max: 0.9, divisions: 8, onChanged: onChanged),
    ),
  ]);
}

class _OptionDraft {
  final TextEditingController ctrl;
  _OptionDraft() : ctrl = TextEditingController();
  _OptionDraft.fromText(String t) : ctrl = TextEditingController(text: t);
  void dispose() => ctrl.dispose();
}

class _QDraft {
  final TextEditingController textCtrl;
  final TextEditingController explanationCtrl;
  List<_OptionDraft> options;
  int correctIndex;

  _QDraft({required this.textCtrl, required this.explanationCtrl,
      required this.options, required this.correctIndex});

  factory _QDraft.empty() => _QDraft(
    textCtrl: TextEditingController(),
    explanationCtrl: TextEditingController(),
    options: [_OptionDraft(), _OptionDraft(), _OptionDraft(), _OptionDraft()],
    correctIndex: 0,
  );

  factory _QDraft.fromModel(QuestionModel q) => _QDraft(
    textCtrl: TextEditingController(text: q.text),
    explanationCtrl: TextEditingController(text: q.explanation ?? ''),
    options: q.options.map((o) => _OptionDraft.fromText(o)).toList(),
    correctIndex: q.correctIndex,
  );

  void dispose() {
    textCtrl.dispose(); explanationCtrl.dispose();
    for (final o in options) { o.dispose(); }
  }
}

class _QuestionEditor extends StatelessWidget {
  final _QDraft draft;
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback onUpdate;
  const _QuestionEditor({required this.draft, required this.index,
      this.onDelete, required this.onUpdate});
  static const _labels = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text('${index + 1}', style: const TextStyle(
              color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13))),
        ),
        const SizedBox(width: 8),
        const Text('Savol', style: AppTypography.h3),
        const Spacer(),
        if (onDelete != null)
          IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
              onPressed: onDelete),
      ]),
      const SizedBox(height: 10),
      TextField(
        controller: draft.textCtrl,
        style: const TextStyle(color: AppColors.text1, fontSize: 14),
        decoration: const InputDecoration(hintText: 'Savol matnini kiriting...'),
        maxLines: 3,
      ),
      const SizedBox(height: 14),
      const Text("To'g'ri javobni belgilash uchun harf tugmasini bosing",
          style: TextStyle(color: AppColors.text3, fontSize: 11)),
      const SizedBox(height: 8),
      ...draft.options.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          GestureDetector(
            onTap: () { draft.correctIndex = e.key; onUpdate(); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: draft.correctIndex == e.key ? AppColors.ok : AppColors.cardHover,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text(
                e.key < _labels.length ? _labels[e.key] : '${e.key + 1}',
                style: TextStyle(
                  color: draft.correctIndex == e.key ? Colors.white : AppColors.text2,
                  fontSize: 12, fontWeight: FontWeight.w800,
                ),
              )),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: TextField(
            controller: e.value.ctrl,
            style: const TextStyle(color: AppColors.text1, fontSize: 13),
            decoration: InputDecoration(
              hintText: '${e.key + 1}-variant',
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          )),
        ]),
      )),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: OutlinedButton.icon(
          onPressed: () { draft.options.add(_OptionDraft()); onUpdate(); },
          icon: const Icon(Icons.add_rounded, size: 14),
          label: const Text("Variant qo'shish", style: TextStyle(fontSize: 12)),
        )),
        if (draft.options.length > 2) ...[
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {
              draft.options.last.dispose();
              draft.options.removeLast();
              if (draft.correctIndex >= draft.options.length) {
                draft.correctIndex = draft.options.length - 1;
              }
              onUpdate();
            },
            icon: const Icon(Icons.remove_rounded, size: 14),
            label: const Text('Olib tashlash', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger)),
          ),
        ],
      ]),
      const SizedBox(height: 8),
      TextField(
        controller: draft.explanationCtrl,
        style: AppTypography.body.copyWith(fontSize: 12),
        decoration: const InputDecoration(
          hintText: '💡 Izoh (ixtiyoriy)...',
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────
// UMUMIY VIDJETLAR
// ─────────────────────────────────────────────────────────────
class _NexusLogo extends StatelessWidget {
  const _NexusLogo();
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDim]),
      ),
      child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
    ),
    const SizedBox(width: 10),
    const Text('NEXUS', style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 3, color: AppColors.text1)),
  ]);
}

class _NexusAppBar extends StatelessWidget {
  final String title, subtitle;
  const _NexusAppBar({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => SliverAppBar(
    expandedHeight: 90, pinned: true,
    backgroundColor: AppColors.bg,
    surfaceTintColor: Colors.transparent,
    flexibleSpace: FlexibleSpaceBar(
      titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      title: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTypography.h2),
        Text(subtitle, style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.text3)),
      ]),
    ),
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  const _InputField({
    required this.controller, required this.label, required this.hint,
    required this.icon, this.obscure = false, this.suffixIcon,
    this.keyboardType, this.validator, this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    validator: validator,
    maxLines: obscure ? 1 : maxLines,
    style: const TextStyle(color: AppColors.text1, fontSize: 15),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.text3, size: 20),
      suffixIcon: suffixIcon,
    ),
  );
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.danger.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.danger.withOpacity(0.3)),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(message, style: const TextStyle(color: AppColors.danger, fontSize: 13))),
    ]),
  );
}

class _BadgeChip extends StatelessWidget {
  final String badge;
  const _BadgeChip(this.badge);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: ScoringService.badgeColor(badge).withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: ScoringService.badgeColor(badge).withOpacity(0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(ScoringService.badgeIcon(badge), size: 13, color: ScoringService.badgeColor(badge)),
      const SizedBox(width: 5),
      Text(badge, style: TextStyle(color: ScoringService.badgeColor(badge),
          fontWeight: FontWeight.w700, fontSize: 12)),
    ]),
  );
}



// ═══════════════════════════════════════════════════════════════
//  NEXUS QUIZ v3.0 — YAKUNIY QISM
//  Document 2 kodining oxiriga (_StatusPill dan keyin) qo'shing
// ═══════════════════════════════════════════════════════════════

// _StatusPill — document 2 da to'liq berilmagan edi:
class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    child: Text(label, style: const TextStyle(
        color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionHeader(this.title, {this.trailing});
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: AppTypography.h3),
        if (trailing != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: AppColors.card, borderRadius: BorderRadius.circular(20)),
            child: Text(trailing!, style: AppTypography.body.copyWith(fontSize: 12)),
          ),
      ]);
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 52, color: AppColors.text3),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(fontSize: 15, height: 1.6)),
      ]),
    ),
  );
}

class _StatTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatTile(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Flexible(child: Text(label,
            style: AppTypography.body.copyWith(fontSize: 11),
            overflow: TextOverflow.ellipsis)),
      ]),
      const SizedBox(height: 10),
      Text(value, style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800, color: color)),
    ]),
  );
}

class _ResultTile extends StatelessWidget {
  final TestResult result;
  final bool showBadge;
  const _ResultTile({required this.result, this.showBadge = true});

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'hozir';
    if (diff.inHours < 1) return '${diff.inMinutes}d oldin';
    if (diff.inDays < 1) return '${diff.inHours}s oldin';
    if (diff.inDays < 7) return '${diff.inDays}k oldin';
    return '${t.day}/${t.month}/${t.year}';
  }

  @override
  Widget build(BuildContext context) {
    final color = result.accuracy >= 80
        ? AppColors.ok
        : result.accuracy >= 50
            ? AppColors.warn
            : AppColors.danger;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text('${result.accuracy.round()}%',
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w800))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(result.testTitle,
              style: AppTypography.h3.copyWith(fontSize: 13),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Row(children: [
            Flexible(child: Text(
                "${result.correctAnswers}/${result.totalQuestions} to'g'ri · ${result.score} ball",
                style: AppTypography.body.copyWith(fontSize: 11))),
            if (showBadge && !result.isFirstAttempt) ...[
              const SizedBox(width: 6),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                      color: AppColors.warn.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('MASHQ', style: TextStyle(
                      color: AppColors.warn,
                      fontSize: 8,
                      fontWeight: FontWeight.w800))),
            ],
          ]),
        ])),
        const SizedBox(width: 8),
        Text(_timeAgo(result.completedAt),
            style: AppTypography.body.copyWith(fontSize: 10)),
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: TextStyle(
        color: color, fontSize: 11, fontWeight: FontWeight.w700)),
  );
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: TextStyle(
            color: color, fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption.copyWith(
            color: AppColors.text3, fontSize: 10)),
      ]),
    ),
  );
}

class _AdminAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _AdminAction(this.label, this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Flexible(child: Text(label, style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontSize: 11),
              overflow: TextOverflow.ellipsis)),
        ]),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  FOYDALANISH YO'RIQNOMASI
// ═══════════════════════════════════════════════════════════════
//
//  LOYIHA TUZILMASI:
//  lib/
//    main.dart  ← Document 2 + ushbu fayl birlashtirilgan holda
//
//  QADAMLAR:
//  1. Document 2 dagi butun kodni oling (oxirida "child" bilan tugagan)
//  2. "child" so'zidan keyin quyidagini qo'shing:
//       : Text(label, style: const TextStyle(
//           color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
//     );
//   }
//  }
//  3. Keyin ushbu fayldagi barcha classlarni (SectionHeader dan boshlab)
//     qo'shing
//
//  pubspec.yaml ga qo'shing:
//  dependencies:
//    flutter:
//      sdk: flutter
//    shared_preferences: ^2.2.3
//
//  LOGIN:
//  Email:    admin@nexus.app
//  Parol:    Admin@1234
// ═══════════════════════════════════════════════════════════════
