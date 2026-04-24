import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/features/shared/data/dto/portfolio_statement_dto.dart';

void main() {
  test(
    'parses getBkrPublicCasaAcntStmt response with exact API keys',
    () {
      final CasaStatementResponseDto dto = CasaStatementResponseDto.fromJson(
        <String, Object?>{
          'responseCode': 0,
          'responseDesc': '',
          'custName': 'Тест Хэрэглэгч',
          'txnDate': '2026-04-08',
          'startDate': '2026-04-01',
          'endDate': '2026-04-09',
          'beginBalance': '100',
          'endBalance': '250',
          'pageCount': 10,
          'totalPage': 1,
          'totalCount': 2,
          'resultValue': '',
          'MgBkrCasaAcntStatementResData': <Map<String, Object?>>[
            <String, Object?>{
              'txnDate': '2026-04-08',
              'jrNo': 101,
              'jritemNo': '1',
              'txnCode': 'CR',
              'credit': 150,
              'debit': 0,
              'balance': 250,
              'txnDesc': 'Recharge',
              'postDate': '2026-04-08T10:00:00',
              'isFee': 0,
              'txnNo': 101,
            },
            <String, Object?>{
              'txnDate': '2026-04-09',
              'jrNo': 102,
              'jritemNo': '2',
              'txnCode': 'DR',
              'credit': 0,
              'debit': 10,
              'balance': 240,
              'txnDesc': 'Fee',
              'postDate': '2026-04-09T10:00:00',
              'isFee': 1,
              'txnNo': 102,
            },
          ],
        },
        fallbackStartDate: '2026-04-01',
        fallbackEndDate: '2026-04-09',
      );

      expect(dto.startDate, '2026-04-01');
      expect(dto.endDate, '2026-04-09');
      expect(dto.entries, hasLength(2));
      expect(dto.entries.first.isCredit, isTrue);
      expect(dto.entries.first.amount, 150);
      expect(dto.entries.first.description, 'Recharge');
      expect(dto.entries.last.isCredit, isFalse);
      expect(dto.entries.last.amount, 10);

      final domain = dto.toDomain();
      expect(domain.totalCount, 2);
      expect(domain.entries, hasLength(2));
      expect(domain.entries.first.description, 'Recharge');
    },
  );
}
