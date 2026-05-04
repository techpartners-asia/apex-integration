import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  group('PortfolioOverviewDto.fromJson', () {
    test(
      'parses getIpsBalance responseData with exact API keys',
      () {
        final PortfolioOverviewDto dto = PortfolioOverviewDto.fromJson(
          <String, Object?>{
            'responseCode': 0,
            'responseDesc': '',
            'resultValue': null,
            'responseData': <String, Object?>{
              'stockTotal': '60000',
              'bondTotal': '60.0',
              'stockPercent': '40000',
              'bondPercent': '40.0',
              'cashTotal': '100000',
              'packQty': '1',
              'packAmount': '100000',
              'packFee': '2510.50',
              'description': 'Туршилтын багц',
            },
            'security': <Map<String, Object?>>[
              <String, Object?>{
                'securityCode': 'MCS',
                'firstInvDate': '2026-04-01T00:00:00Z',
                'firstPrice': 5000,
                'currentPrice': null,
                'percent': null,
                'qty': 2,
                'curCode': 'MNT',
                'portfolioPercent': 59.99,
                'typePercent': 100,
                'securityType': 'stock',
                'closePrices': <Map<String, Object?>>[
                  <String, Object?>{
                    'closePrice': 5100,
                    'tradeDate': '2026-04-02T00:00:00Z',
                  },
                ],
              },
              <String, Object?>{
                'securityCode': 'GOVT-BOND',
                'firstInvDate': '2026-04-01T00:00:00Z',
                'firstPrice': 100000,
                'currentPrice': 100500,
                'percent': 0.5,
                'qty': 1,
                'curCode': 'MNT',
                'portfolioPercent': 40.01,
                'typePercent': 100,
                'securityType': 'bond',
                'closePrices': null,
              },
            ],
            'packDetail': <String, Object?>{
              'isRecommended': true,
              'packCode': 'PACK-001',
              'name': 'Growth',
              'name2': 'Өсөлт',
              'packDesc': 'Balanced package',
              'bondPercent': 40.01,
              'stockPercent': 59.99,
            },
          },
        );

        expect(dto.responseCode, 0);
        expect(dto.responseDesc, isNull);
        expect(dto.resultValue, isNull);
        expect(dto.currency, 'MNT');
        expect(dto.stockTotal, 60000);
        expect(dto.bondTotal, 60.0);
        expect(dto.stockPercent, 40000);
        expect(dto.bondPercent, 40.0);
        expect(dto.cashTotal, 100000);
        expect(dto.investedBalance, 60060.0);
        expect(dto.packQty, 1);
        expect(dto.packAmount, 100000);
        expect(dto.packFee, 2510.50);
        expect(dto.description, 'Туршилтын багц');
        expect(dto.profitOrLoss, isNull);
        expect(dto.yieldAmount, isNull);
        expect(dto.security, hasLength(2));
        expect(dto.security.first.securityCode, 'MCS');
        expect(dto.security.first.currentPrice, isNull);
        expect(dto.security.first.percent, isNull);
        expect(dto.security.first.closePrices, hasLength(1));
        expect(dto.security.first.closePrices!.first.closePrice, 5100);
        expect(dto.security.last.closePrices, isNull);
        expect(dto.packDetail, isNotNull);
        expect(dto.packDetail!.packCode, 'PACK-001');
        expect(dto.packDetail!.isRecommended, isTrue);
      },
    );

    test(
      'maps nested getIpsBalance data into the domain model',
      () {
        final overview = PortfolioOverviewDto.fromJson(
          <String, Object?>{
            'responseCode': 0,
            'responseData': <String, Object?>{
              'stockTotal': 5816638.8918,
              'bondTotal': 3880000,
              'cashTotal': 206402.29,
              'packFee': 999.66,
              'packAmount': 100000,
              'packQty': 97,
              'description': 'ЪЪ71121212 ОВОГ1 НЭР1',
            },
            'security': <Map<String, Object?>>[
              <String, Object?>{
                'securityCode': 'XOC',
                'qty': 3,
                'currentPrice': null,
                'percent': null,
                'closePrices': null,
              },
            ],
            'packDetail': <String, Object?>{
              'packCode': 'PACK-X',
              'isRecommended': false,
              'name': 'Pack X',
            },
          },
        ).toDomain();

        expect(overview.packQty, 97);
        expect(overview.description, 'ЪЪ71121212 ОВОГ1 НЭР1');
        expect(overview.security, hasLength(1));
        expect(overview.security.first.securityCode, 'XOC');
        expect(overview.security.first.currentPrice, isNull);
        expect(overview.security.first.percent, isNull);
        expect(overview.security.first.closePrices, isNull);
        expect(overview.packDetail?.packCode, 'PACK-X');
        expect(overview.packDetail?.isRecommended, isFalse);
      },
    );
  });

  group('PortfolioHoldingDto', () {
    test('parses getAcntYieldProfit profit item with exact API keys', () {
      final PortfolioHoldingDto dto = PortfolioHoldingDto.fromYieldProfitJson(
        <String, Object?>{
          'acntCode': '007810000000',
          'symbol': 'XOC',
          'securityName': 'InvestX',
          'buyAmount': 1200,
          'custCode': 'CIF-123',
          'balance': 3,
          'profit': 54,
          'profitPercent': 4.5,
          'responseCode': 0,
          'responseDesc': '',
        },
      );

      expect(dto.securityCode, 'XOC');
      expect(dto.securityName, 'InvestX');
      // expect(dto.quantity, 3);
      expect(dto.currentValue, 1200);
      // expect(dto.yieldPercent, 4.5);
      // expect(dto.profitAmount, 54);
    });

    test('parses getStockAcntYieldDtl yield object with exact API keys', () {
      final List<PortfolioHoldingDto> holdings =
          PortfolioHoldingDto.listFromStockYieldDetailResponse(
            <String, Object?>{
              'responseCode': 0,
              'yield': <String, Object?>{
                'securityCode': 'ABC',
                'securityName': 'Alpha',
                'currentValue': 200,
                'investmentValue': 180,
                'todaysYield': 5,
                'totalYield': 18,
                'totalPercent': 9,
                'todaysPercent': 2.5,
                'symbol': 'ABC',
              },
            },
          );

      expect(holdings, hasLength(1));
      expect(holdings.first.securityCode, 'ABC');
      expect(holdings.first.securityName, 'Alpha');
      // expect(holdings.first.quantity, 180);
      expect(holdings.first.currentValue, 200);
      // expect(holdings.first.profitAmount, 18);
      // expect(holdings.first.yieldPercent, 9);
    });
  });
}
