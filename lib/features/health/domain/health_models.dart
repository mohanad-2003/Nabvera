import '../../../core/localization/generated/app_localizations.dart';

/// One day's aggregated health metrics — used both for what the device's
/// health store reports (see `HealthService`) and what the backend
/// returns (`GET /api/health/summary`, mirroring
/// `backend/src/models/HealthDailySummary.js`). Any field being `null`
/// means "no data for that metric that day", never zero.
class HealthMetricsDay {
  const HealthMetricsDay({
    required this.date,
    this.steps,
    this.activeMinutes,
    this.activeCalories,
    this.sleepMinutes,
  });

  final DateTime date;
  final int? steps;
  final int? activeMinutes;
  final int? activeCalories;
  final int? sleepMinutes;

  factory HealthMetricsDay.fromJson(Map<String, dynamic> json) => HealthMetricsDay(
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    steps: (json['steps'] as num?)?.toInt(),
    activeMinutes: (json['activeMinutes'] as num?)?.toInt(),
    activeCalories: (json['activeCalories'] as num?)?.toInt(),
    sleepMinutes: (json['sleepMinutes'] as num?)?.toInt(),
  );

  Map<String, dynamic> toSyncJson() => {
    'date': '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    if (steps != null) 'steps': steps,
    if (activeMinutes != null) 'activeMinutes': activeMinutes,
    if (activeCalories != null) 'activeCalories': activeCalories,
    if (sleepMinutes != null) 'sleepMinutes': sleepMinutes,
  };
}

/// The user's health-sync preferences — mirrors `User.healthPreferences`
/// in the backend. Fully opt-in; every flag defaults to off.
class HealthPreferences {
  const HealthPreferences({
    this.syncEnabled = false,
    this.shareSteps = false,
    this.shareActivity = false,
    this.shareSleep = false,
    this.lastSyncedAt,
  });

  final bool syncEnabled;
  final bool shareSteps;
  final bool shareActivity;
  final bool shareSleep;
  final DateTime? lastSyncedAt;

  bool get hasAnyDataTypeSelected => shareSteps || shareActivity || shareSleep;

  HealthPreferences copyWith({
    bool? syncEnabled,
    bool? shareSteps,
    bool? shareActivity,
    bool? shareSleep,
    DateTime? lastSyncedAt,
  }) => HealthPreferences(
    syncEnabled: syncEnabled ?? this.syncEnabled,
    shareSteps: shareSteps ?? this.shareSteps,
    shareActivity: shareActivity ?? this.shareActivity,
    shareSleep: shareSleep ?? this.shareSleep,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
  );

  factory HealthPreferences.fromJson(Map<String, dynamic> json) => HealthPreferences(
    syncEnabled: json['syncEnabled'] as bool? ?? false,
    shareSteps: json['shareSteps'] as bool? ?? false,
    shareActivity: json['shareActivity'] as bool? ?? false,
    shareSleep: json['shareSleep'] as bool? ?? false,
    lastSyncedAt: json['lastSyncedAt'] == null ? null : DateTime.tryParse(json['lastSyncedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'syncEnabled': syncEnabled,
    'shareSteps': shareSteps,
    'shareActivity': shareActivity,
    'shareSleep': shareSleep,
  };
}

/// The 14-day rule-based comparison from `GET /api/health/summary` — never
/// AI-computed, never medical advice. `codes` only ever contains fixed,
/// known values (see [healthInsightCodeLabel]); the backend never sends
/// rendered text (`backend/src/services/healthInsightsService.js`).
class HealthInsights {
  const HealthInsights({
    required this.codes,
    required this.avgStepsCurrent,
    required this.avgStepsPrevious,
    required this.disclaimerCode,
  });

  final List<String> codes;
  final int? avgStepsCurrent;
  final int? avgStepsPrevious;
  final String disclaimerCode;

  factory HealthInsights.fromJson(Map<String, dynamic> json) {
    final currentWeek = json['currentWeek'] as Map<String, dynamic>? ?? const {};
    final previousWeek = json['previousWeek'] as Map<String, dynamic>? ?? const {};
    return HealthInsights(
      codes: (json['codes'] as List? ?? const []).cast<String>(),
      avgStepsCurrent: (currentWeek['avgSteps'] as num?)?.toInt(),
      avgStepsPrevious: (previousWeek['avgSteps'] as num?)?.toInt(),
      disclaimerCode: json['disclaimerCode'] as String? ?? 'not_medical_advice',
    );
  }
}

/// The full `GET /api/health/summary` response.
class HealthOverview {
  const HealthOverview({required this.days, required this.insights});

  final List<HealthMetricsDay> days;
  final HealthInsights insights;

  HealthMetricsDay? get today => days.isEmpty ? null : days.last;

  factory HealthOverview.fromJson(Map<String, dynamic> json) => HealthOverview(
    days: (json['days'] as List? ?? const []).cast<Map<String, dynamic>>().map(HealthMetricsDay.fromJson).toList(),
    insights: HealthInsights.fromJson(json['insights'] as Map<String, dynamic>? ?? const {}),
  );

  static const empty = HealthOverview(days: [], insights: HealthInsights(codes: [], avgStepsCurrent: null, avgStepsPrevious: null, disclaimerCode: 'not_medical_advice'));
}

/// Localizes a fixed insight code (see the doc comment on
/// [HealthInsights.codes]) — the single place that decides user-facing
/// wording, deliberately safe/descriptive phrasing only (never "you're
/// exhausted" or any claim of a health problem).
String healthInsightCodeLabel(AppLocalizations l10n, String code) => switch (code) {
  'activity_up' => l10n.healthInsightActivityUp,
  'activity_down' => l10n.healthInsightActivityDown,
  'sleep_consistent' => l10n.healthInsightSleepConsistent,
  'sleep_low_data' => l10n.healthInsightSleepLowData,
  'rest_day_suggested' => l10n.healthInsightRestDaySuggested,
  'keep_momentum' => l10n.healthInsightKeepMomentum,
  _ => '',
};
