import 'package:flutter_grocery/features/member/domain/models/member_matrix_model.dart';
import 'package:flutter_grocery/features/profile/domain/models/member_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Matrix API models', () {
    test('parses matrix status progression and referral levels', () {
      final status = MatrixStatusModel.fromJson({
        'user_id': 1,
        'name': 'Rahul Sharma',
        'is_member': true,
        'current_level': 2,
        'current_position': 'Silver',
        'total_team_members': 5,
        'direct_referrals_filled': 5,
        'direct_referrals_active': 5,
        'incentives_eligible': true,
        'direct_referrals': [
          {
            'id': 2,
            'position': 1,
            'is_member': true,
            'name': 'Priya Patel',
            'matrix_level': 1,
            'matrix_position': 'Bronze',
          },
        ],
        'current_level_info': {
          'level': 2,
          'position_name': 'Silver',
          'required_members': 16,
          'incentive_amount': 2500,
        },
        'next_level': {
          'level': 3,
          'position_name': 'Gold',
          'incentive_amount': 11000,
          'remaining_members': 64,
          'condition': 'Need 4+ directs at Level 2 (Silver+)',
          'directs_ready': 0,
          'directs_required': 4,
        },
      });

      expect(status.currentPosition, 'Silver');
      expect(status.directReferrals.single.matrixPosition, 'Bronze');
      expect(
        status.nextLevel?.condition,
        'Need 4+ directs at Level 2 (Silver+)',
      );
      expect(status.nextLevel?.directsRequired, 4);
    });

    test('parses team and recursive tree level fields', () {
      final team = MatrixTeamModel.fromJson({
        'total': 1,
        'members': [
          {
            'id': 2,
            'name': 'Priya Patel',
            'position': 1,
            'level': 1,
            'position_name': 'Bronze',
          },
        ],
      });
      final tree = MatrixTreeNodeModel.fromJson({
        'id': 1,
        'name': 'Rahul Sharma',
        'phone': '+91-9876543210',
        'is_member': true,
        'position': null,
        'depth': 0,
        'matrix_level': 2,
        'matrix_position': 'Silver',
        'children': [],
      });

      expect(team.members.single.positionName, 'Bronze');
      expect(tree.matrixLevel, 2);
      expect(tree.matrixPosition, 'Silver');
    });

    test('parses member wallet and point progress', () {
      final member = MemberStatusModel.fromJson({
        'is_member': true,
        'total_point_value': 3100,
        'next_milestone': 6500,
        'progress_percent': 100,
        'remaining_points': 0,
        'wallet_balance': 2500,
      });

      expect(member.totalPointValue, 3100);
      expect(member.walletBalance, 2500);
    });
  });
}
