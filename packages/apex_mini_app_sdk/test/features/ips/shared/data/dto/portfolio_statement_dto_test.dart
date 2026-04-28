import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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
      expect(dto.stmtList, hasLength(2));
      expect(dto.stmtList.first.isCredit, isTrue);
      expect(dto.stmtList.first.amount, 150);
      expect(dto.stmtList.first.description, 'Recharge');
      expect(dto.stmtList.last.isCredit, isFalse);
      expect(dto.stmtList.last.amount, 10);

      final domain = dto.toDomain();
      expect(domain.totalCount, 2);
      expect(domain.stmtList, hasLength(2));
      expect(domain.stmtList.first.description, 'Recharge');
    },
  );

  test(
    'throws business exception when statement response code is not success',
    () {
      expect(
        () => CasaStatementResponseDto.fromJson(
          <String, Object?>{
            'responseCode': 9999,
            'responseDesc': 'Системийн алдаа!',
            'resultValue': null,
            'casafintxn': null,
          },
          fallbackStartDate: '2026-04-01',
          fallbackEndDate: '2026-04-09',
        ),
        throwsA(
          isA<ApiBusinessException>()
              .having(
                (ApiBusinessException error) => error.responseCode,
                'responseCode',
                9999,
              )
              .having(
                (ApiBusinessException error) => error.message,
                'message',
                'Системийн алдаа!',
              ),
        ),
      );
    },
  );

  test('parses success response with null statement list as empty data', () {
    final CasaStatementResponseDto dto = CasaStatementResponseDto.fromJson(
      <String, Object?>{
        'responseCode': 0,
        'responseDesc': null,
        'resultValue': null,
        'casafintxn': null,
        'pageCount': null,
        'totalPage': null,
        'totalCount': null,
      },
      fallbackStartDate: '2026-04-01',
      fallbackEndDate: '2026-04-09',
    );

    expect(dto.resultValue, isNull);
    expect(dto.stmtList, isEmpty);
    expect(dto.pageCount, 0);
    expect(dto.totalPage, 0);
    expect(dto.totalCount, 0);
  });
}
