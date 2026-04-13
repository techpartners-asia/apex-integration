import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../app/investx_api/backend/mini_app_api_repository.dart';

import '../../../app/bootstrap/mini_app_bootstrap_flow.dart';
import '../../../app/session/mini_app_session_controller.dart';
import '../../../app/session/mini_app_session_store.dart';
import '../sec_acnt/application/sec_acnt_bank_account_lookup_repository.dart';
import '../sec_acnt/application/sec_acnt_bank_options_repository.dart';
import '../../../runtime/mini_app_payment_executor.dart';
import '../../../runtime/mini_app_launch_context.dart';
import '../shared/domain/services/investment_services.dart';

class IpsDependencies {
  final InvestmentServices services;
  final MiniAppPaymentExecutor paymentExecutor;
  final MiniAppSessionStore sessionStore;
  final MiniAppSessionController sessionController;
  final MiniAppApiRepository appApi;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final MiniAppBootstrapFlow? bootstrapFlow;
  final MiniAppLogger logger;

  const IpsDependencies({
    required this.services,
    required this.paymentExecutor,
    required this.sessionStore,
    required this.sessionController,
    required this.appApi,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    this.bootstrapFlow,
    this.logger = const SilentMiniAppLogger(),
  });

  void prepareLaunch(MiniAppLaunchContext context) {
    sessionController.prepareLaunch(userToken: context.userToken);
  }
}
