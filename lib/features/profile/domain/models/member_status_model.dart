class MemberStatusModel {
  final bool isMember;
  final int totalPointValue;
  final int nextMilestone;
  final double progressPercent;
  final int remainingPoints;
  final double walletBalance;

  const MemberStatusModel({
    required this.isMember,
    required this.totalPointValue,
    required this.nextMilestone,
    required this.progressPercent,
    required this.remainingPoints,
    required this.walletBalance,
  });

  factory MemberStatusModel.fromJson(Map<String, dynamic> json) {
    return MemberStatusModel(
      isMember: _parseBool(json['is_member']),
      totalPointValue: int.tryParse('${json['total_point_value'] ?? 0}') ?? 0,
      nextMilestone: int.tryParse('${json['next_milestone'] ?? 6500}') ?? 6500,
      progressPercent: double.tryParse('${json['progress_percent'] ?? 0}') ?? 0,
      remainingPoints: int.tryParse('${json['remaining_points'] ?? 0}') ?? 0,
      walletBalance: double.tryParse('${json['wallet_balance'] ?? 0}') ?? 0,
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is num) {
      return value == 1;
    }

    final String stringValue = '${value ?? ''}'.toLowerCase();
    return stringValue == 'true' || stringValue == '1';
  }
}
