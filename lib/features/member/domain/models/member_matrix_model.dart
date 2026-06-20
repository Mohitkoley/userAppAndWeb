class MatrixStatusModel {
  final int userId;
  final String name;
  final bool isMember;
  final int currentLevel;
  final String? currentPosition;
  final int totalTeamMembers;
  final int directReferralsFilled;
  final int directReferralsActive;
  final bool incentivesEligible;
  final List<MatrixReferralModel> directReferrals;
  final MatrixLevelInfoModel? currentLevelInfo;
  final MatrixLevelInfoModel? nextLevel;

  MatrixStatusModel({
    required this.userId,
    required this.name,
    required this.isMember,
    required this.currentLevel,
    required this.currentPosition,
    required this.totalTeamMembers,
    required this.directReferralsFilled,
    required this.directReferralsActive,
    required this.incentivesEligible,
    required this.directReferrals,
    required this.currentLevelInfo,
    required this.nextLevel,
  });

  factory MatrixStatusModel.fromJson(Map<String, dynamic> json) {
    return MatrixStatusModel(
      userId: _parseInt(json['user_id']),
      name: '${json['name'] ?? ''}',
      isMember: _parseBool(json['is_member']),
      currentLevel: _parseInt(json['current_level']),
      currentPosition: json['current_position']?.toString(),
      totalTeamMembers: _parseInt(json['total_team_members']),
      directReferralsFilled: _parseInt(json['direct_referrals_filled']),
      directReferralsActive: _parseInt(json['direct_referrals_active']),
      incentivesEligible: _parseBool(json['incentives_eligible']),
      directReferrals: (json['direct_referrals'] as List? ?? [])
          .map(
            (item) =>
                MatrixReferralModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      currentLevelInfo: json['current_level_info'] != null
          ? MatrixLevelInfoModel.fromJson(
              Map<String, dynamic>.from(json['current_level_info']),
            )
          : null,
      nextLevel: json['next_level'] != null
          ? MatrixLevelInfoModel.fromJson(
              Map<String, dynamic>.from(json['next_level']),
            )
          : null,
    );
  }
}

class MatrixReferralModel {
  final int id;
  final String name;
  final int position;
  final bool isMember;
  final int matrixLevel;
  final String? matrixPosition;

  MatrixReferralModel({
    required this.id,
    required this.name,
    required this.position,
    required this.isMember,
    required this.matrixLevel,
    required this.matrixPosition,
  });

  factory MatrixReferralModel.fromJson(Map<String, dynamic> json) {
    return MatrixReferralModel(
      id: _parseInt(json['id']),
      name: '${json['name'] ?? ''}',
      position: _parseInt(json['position']),
      isMember: _parseBool(json['is_member']),
      matrixLevel: _parseInt(json['matrix_level']),
      matrixPosition: json['matrix_position']?.toString(),
    );
  }
}

class MatrixLevelInfoModel {
  final int level;
  final String positionName;
  final int requiredMembers;
  final double incentiveAmount;
  final int remainingMembers;
  final String condition;
  final int directsReady;
  final int directsRequired;

  MatrixLevelInfoModel({
    required this.level,
    required this.positionName,
    required this.requiredMembers,
    required this.incentiveAmount,
    required this.remainingMembers,
    required this.condition,
    required this.directsReady,
    required this.directsRequired,
  });

  factory MatrixLevelInfoModel.fromJson(Map<String, dynamic> json) {
    return MatrixLevelInfoModel(
      level: _parseInt(json['level']),
      positionName: '${json['position_name'] ?? ''}',
      requiredMembers: _parseInt(json['required_members']),
      incentiveAmount: _parseDouble(json['incentive_amount']),
      remainingMembers: _parseInt(json['remaining_members']),
      condition: '${json['condition'] ?? ''}',
      directsReady: _parseInt(json['directs_ready']),
      directsRequired: _parseInt(json['directs_required']),
    );
  }
}

class MatrixTeamModel {
  final int total;
  final List<MatrixTeamMemberModel> members;

  MatrixTeamModel({required this.total, required this.members});

  factory MatrixTeamModel.fromJson(Map<String, dynamic> json) {
    return MatrixTeamModel(
      total: _parseInt(json['total']),
      members: (json['members'] as List? ?? [])
          .map(
            (item) =>
                MatrixTeamMemberModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }
}

class MatrixTeamMemberModel {
  final int id;
  final String name;
  final int position;
  final int level;
  final String? positionName;

  MatrixTeamMemberModel({
    required this.id,
    required this.name,
    required this.position,
    required this.level,
    required this.positionName,
  });

  factory MatrixTeamMemberModel.fromJson(Map<String, dynamic> json) {
    return MatrixTeamMemberModel(
      id: _parseInt(json['id']),
      name: '${json['name'] ?? ''}',
      position: _parseInt(json['position']),
      level: _parseInt(json['level']),
      positionName: json['position_name']?.toString(),
    );
  }
}

class MatrixTreeNodeModel {
  final int id;
  final String name;
  final String phone;
  final bool isMember;
  final int? position;
  final int depth;
  final int matrixLevel;
  final String? matrixPosition;
  final List<MatrixTreeNodeModel> children;

  MatrixTreeNodeModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isMember,
    required this.position,
    required this.depth,
    required this.matrixLevel,
    required this.matrixPosition,
    required this.children,
  });

  factory MatrixTreeNodeModel.fromJson(Map<String, dynamic> json) {
    return MatrixTreeNodeModel(
      id: _parseInt(json['id']),
      name: '${json['name'] ?? ''}',
      phone: '${json['phone'] ?? ''}',
      isMember: _parseBool(json['is_member']),
      position: json['position'] == null ? null : _parseInt(json['position']),
      depth: _parseInt(json['depth']),
      matrixLevel: _parseInt(json['matrix_level']),
      matrixPosition: json['matrix_position']?.toString(),
      children: (json['children'] as List? ?? [])
          .map(
            (item) =>
                MatrixTreeNodeModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }
}

class MatrixIncentiveHistoryModel {
  final double totalIncentive;
  final List<MatrixIncentiveModel> history;

  MatrixIncentiveHistoryModel({
    required this.totalIncentive,
    required this.history,
  });

  factory MatrixIncentiveHistoryModel.fromJson(Map<String, dynamic> json) {
    return MatrixIncentiveHistoryModel(
      totalIncentive: _parseDouble(json['total_incentive']),
      history: (json['history'] as List? ?? [])
          .map(
            (item) =>
                MatrixIncentiveModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }
}

class MatrixIncentiveModel {
  final int level;
  final String positionName;
  final double amount;
  final int totalTeamMembers;
  final String status;
  final String creditedAt;

  MatrixIncentiveModel({
    required this.level,
    required this.positionName,
    required this.amount,
    required this.totalTeamMembers,
    required this.status,
    required this.creditedAt,
  });

  factory MatrixIncentiveModel.fromJson(Map<String, dynamic> json) {
    return MatrixIncentiveModel(
      level: _parseInt(json['level']),
      positionName: '${json['position_name'] ?? ''}',
      amount: _parseDouble(json['amount']),
      totalTeamMembers: _parseInt(json['total_team_members']),
      status: '${json['status'] ?? ''}',
      creditedAt: '${json['credited_at'] ?? ''}',
    );
  }
}

class MatrixLevelModel {
  final int level;
  final String positionName;
  final int requiredMembers;
  final double incentiveAmount;

  MatrixLevelModel({
    required this.level,
    required this.positionName,
    required this.requiredMembers,
    required this.incentiveAmount,
  });

  factory MatrixLevelModel.fromJson(Map<String, dynamic> json) {
    return MatrixLevelModel(
      level: _parseInt(json['level']),
      positionName: '${json['position_name'] ?? json['position'] ?? ''}',
      requiredMembers: _parseInt(json['required_members']),
      incentiveAmount: _parseDouble(json['incentive_amount']),
    );
  }
}

int _parseInt(dynamic value) => int.tryParse('${value ?? 0}') ?? 0;
double _parseDouble(dynamic value) => double.tryParse('${value ?? 0}') ?? 0;
bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  } else if (value is num) {
    return value == 1;
  }

  final String stringValue = '${value ?? ''}'.toLowerCase();
  return stringValue == 'true' || stringValue == '1';
}
