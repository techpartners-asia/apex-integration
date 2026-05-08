// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'sdk_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class SdkLocalizationsMn extends SdkLocalizations {
  SdkLocalizationsMn([String locale = 'mn']) : super(locale);

  @override
  String get commonLoading => 'Ачаалж байна';

  @override
  String get commonRetry => 'Дахин оролдох';

  @override
  String get commonContinue => 'Үргэлжлүүлэх';

  @override
  String get commonSubmit => 'Илгээх';

  @override
  String get commonCancel => 'Цуцлах';

  @override
  String get commonClose => 'Хаах';

  @override
  String get commonBack => 'Буцах';

  @override
  String get commonNext => 'Дараах';

  @override
  String get commonPrevious => 'Өмнөх';

  @override
  String get commonDone => 'Дуусгах';

  @override
  String get commonRefresh => 'Шинэчлэх';

  @override
  String get commonSelect => 'Сонгох';

  @override
  String get commonOpen => 'Нээх';

  @override
  String get commonViewDetails => 'Дэлгэрэнгүй харах';

  @override
  String get commonAmount => 'Дүн';

  @override
  String get commonCurrency => 'Валют';

  @override
  String get commonStatus => 'Төлөв';

  @override
  String get commonMessage => 'Мессеж';

  @override
  String get commonNoData => 'Өгөгдөл алга';

  @override
  String get commonRequired => 'Шаардлагатай';

  @override
  String get errorsGenericTitle => 'Алдаа гарлаа';

  @override
  String get errorsServiceUnavailable => 'Үйлчилгээ одоогоор боломжгүй байна.';

  @override
  String get errorsUnexpected => 'Санамсаргүй алдаа гарлаа.';

  @override
  String get errorsNetwork =>
      'Сүлжээний холболт амжилтгүй боллоо. Дахин оролдоно уу.';

  @override
  String get errorsSession =>
      'Таны session хүчингүй байна. Mini app-аа дахин нээнэ үү.';

  @override
  String get errorsConfig =>
      'Энэ mini app integration зөв тохируулагдаагүй байна.';

  @override
  String get errorsSessionExpired =>
      'Session хүчингүй болсон эсвэл дууссан байна.';

  @override
  String get errorsUnauthorized => 'Танд энэ үйлдлийг хийх эрх алга.';

  @override
  String get errorsApiLoadFailed => 'Backend-ээс өгөгдөл татаж чадсангүй.';

  @override
  String get errorsActionFailed => 'Үйлдлийг гүйцэтгэж чадсангүй.';

  @override
  String get errorsMissingIntegration =>
      'Шаардлагатай host integration тохируулагдаагүй байна.';

  @override
  String get errorsMissingContract =>
      'Backend-ийн нарийн contract хараахан бэлэн болоогүй байна.';

  @override
  String get errorsUnknownRoute => 'Хүссэн урсгалын route бүртгэгдээгүй байна.';

  @override
  String get validationRequired => 'Энэ талбарыг заавал бөглөнө.';

  @override
  String get validationSelectionRequired => 'Утга сонгоно уу.';

  @override
  String get validationInvalidEmail => 'Имэйл хаягаа зөв оруулна уу.';

  @override
  String get validationInvalidPhone => 'Утасны дугаараа зөв оруулна уу.';

  @override
  String get validationInvalidRegisterNo =>
      'Регистрийн дугаараа зөв оруулна уу.';

  @override
  String get validationInvalidIban => 'IBAN / дансны дугаараа зөв оруулна уу.';

  @override
  String validationMinLength(int count) {
    return 'Хамгийн багадаа $count тэмдэгт оруулна уу.';
  }

  @override
  String validationMaxLength(int count) {
    return 'Ихдээ $count тэмдэгт оруулна уу.';
  }

  @override
  String get validationMinQuantity => 'Тоо хэмжээ хамгийн багадаа 1 байна.';

  @override
  String get validationInvalidAmount => 'Зөв дүн оруулна уу.';

  @override
  String get validationMinAmount =>
      'Дүн нь зөвшөөрөгдөх доод хэмжээнээс бага байна.';

  @override
  String get validationQuestionnaireIncomplete =>
      'Үргэлжлүүлэхийн өмнө бүх асуултад хариулна уу.';

  @override
  String get validationMissingPackSelection =>
      'Эхлээд санал болгосон багцаас сонгоно уу.';

  @override
  String get validationMissingSrcFiCode =>
      'Санал болгосон багцыг авахын өмнө хүчинтэй srcFiCode шаардлагатай.';

  @override
  String get validationMissingOrderId => 'Захиалгын дугаар шаардлагатай.';

  @override
  String get validationMissingAcntReference => 'Дансны лавлагаа шаардлагатай.';

  @override
  String get ipsHomeTitle => 'IPS тойм';

  @override
  String get ipsHomeSubtitle =>
      'ҮЦ дансны баталгаажуулалт болон IPS эрхийн урсгал.';

  @override
  String get ipsHomeOverviewCardTitle => 'Одоогийн төлөв';

  @override
  String get ipsHomeOpenAcntCta => 'Дансны урсгал';

  @override
  String get ipsHomeQuestionnaireCta => 'Асуумж';

  @override
  String get ipsHomeRecommendedPackCta => 'Санал болгосон багц';

  @override
  String get ipsHomePortfolioCta => 'Хөрөнгө оруулалтын багц';

  @override
  String get ipsHomeOrdersCta => 'Захиалга';

  @override
  String get ipsHomeNextStepsTitle => 'Дараагийн алхам';

  @override
  String get ipsHomeNextStepsSubtitle =>
      'Одоогийн төлөв дээр тулгуурлан IPS-ийн дараагийн урсгалыг нээнэ.';

  @override
  String get ipsHomeSecAcntLabel => 'ҮЦ данс';

  @override
  String get ipsHomeIpsAcntLabel => 'IPS данс';

  @override
  String get ipsHomeAcntStatusLabel => 'Дансны төлөв';

  @override
  String get ipsHomeIpsBalanceLabel => 'IPS үлдэгдэл';

  @override
  String ipsHomeGreeting(Object displayName) {
    return 'Сайн байна уу, $displayName';
  }

  @override
  String get ipsOverviewVerificationTitle => 'Баталгаажуулалт';

  @override
  String get ipsOverviewVerificationSubtitle =>
      'Та доорх алхмуудыг гүйцэтгэснээр багц худалдан авах эрх нээгдэнэ.';

  @override
  String get ipsOverviewFinalStepLabel => 'Сүүлийн алхам';

  @override
  String get ipsOverviewFirstPackTitle => 'Анхны багцаа худалдан авах';

  @override
  String get ipsOverviewActionTitle => 'Арилжаа';

  @override
  String get ipsOverviewProfileVerified => 'Баталгаажсан';

  @override
  String get ipsOverviewProfileGuestName => 'InvestX хэрэглэгч';

  @override
  String get ipsOverviewProfileMenuPersonalInfo => 'Хувийн мэдээлэл';

  @override
  String get ipsOverviewProfilePersonalInfoMissing => 'Мэдээлэл дутуу';

  @override
  String get ipsOverviewProfileMenuLaw => 'Хууль';

  @override
  String get ipsOverviewProfileMenuPackInfo => 'Багцын мэдээлэл';

  @override
  String get ipsOverviewProfileMenuAchievements => 'Таны амжилт';

  @override
  String get ipsOverviewProfileMenuTerms => 'Үйлчилгээний нөхцөл';

  @override
  String get ipsOverviewProfileMenuFeedback => 'Гомдол, санал хүсэлт';

  @override
  String get ipsOverviewProfileMenuContact => 'Холбоо барих';

  @override
  String get ipsOverviewDashboardGreetingLabel => 'Таньд энэ өдрийн мэнд';

  @override
  String ipsOverviewDashboardProfitMessage(Object amount) {
    return '$amount-н өгөөжтэй';
  }

  @override
  String get ipsOverviewDashboardQuickRecharge => 'Багц цэнэглэх';

  @override
  String get ipsOverviewDashboardQuickWithdraw => 'Мөнгө татах';

  @override
  String get ipsOverviewDashboardAllocationStocks => 'Хувьцаа';

  @override
  String get ipsOverviewDashboardAllocationBonds => 'Бонд';

  @override
  String get ipsOverviewDashboardAllocationTotal => 'Нийт хөрөнгө оруулалт';

  @override
  String get ipsOverviewDashboardYieldLabel => 'Таны өгөөж';

  @override
  String get ipsOverviewDashboardDetails => 'Дэлгэрэнгүй харах';

  @override
  String get ipsOverviewDashboardReminderTitle => 'Санамж';

  @override
  String get ipsOverviewDashboardReminderBody =>
      'Та дансаа сар бүр тогтмол цэнэглэснээр таны сонгосон багц тогтмол цэнэглэгдэж байх болно. ҮЦ данс хооронд шилжсэн дүн 2-4 ажлын өдрийн дотор автоматаар арилжаалагдана.';

  @override
  String get ipsOverviewDashboardGoalTitle => 'Зорилтот зорилго';

  @override
  String get ipsOverviewDashboardGoalProgress => 'Биелүүлэлт';

  @override
  String ipsOverviewDashboardRewardTitle(int count) {
    return 'Тасралтгүй $count дахь сар!';
  }

  @override
  String get ipsOverviewDashboardRewardBody =>
      'Та тасралтгүй хөрөнгө оруулалт хийсэнд тань урамшуулан 5000 Tino Coin бэлэглэх болно.';

  @override
  String get ipsOverviewDashboardActionRecharge => 'Багц цэнэглэх';

  @override
  String get ipsOverviewDashboardActionSell => 'Багц хаах';

  @override
  String get ipsAcntTitle => 'ҮЦ данс';

  @override
  String get ipsAcntSubtitle =>
      'Танилцуулга, зөвшөөрөл, данс нээх хүсэлт, QR үүсгэх урсгал.';

  @override
  String get ipsAcntOpenAcnt => 'ҮЦ данс нээх';

  @override
  String get ipsAcntVerifyAcnt => 'Данс баталгаажуулах';

  @override
  String get ipsAcntGenerateQr => 'QR үүсгэх';

  @override
  String get ipsAcntQrValue => 'QR утга';

  @override
  String get ipsAcntOpeningFee => 'Нээлтийн шимтгэл';

  @override
  String get ipsAcntMissingService =>
      'ҮЦ дансны integration тохируулагдаагүй байна.';

  @override
  String get ipsAcntHasAcnt => 'ҮЦ данс бүртгэлтэй';

  @override
  String get ipsAcntNoAcnt => 'ҮЦ данс бүртгэлгүй';

  @override
  String get ipsAcntBalance => 'ҮЦ дансны үлдэгдэл';

  @override
  String get ipsAcntFlowBody => 'Данс нээх урсгал.';

  @override
  String get ipsAcntPendingQrMessage =>
      'ҮЦ данс нээх урсгалыг үргэлжлүүлэхийн тулд QR үүсгэнэ үү.';

  @override
  String get ipsBootstrapMissingService =>
      'Bootstrap service тохируулагдаагүй байна.';

  @override
  String get ipsBootstrapLoading => 'Дансны эхний төлөвийг шалгаж байна.';

  @override
  String get ipsSplashTitle => 'InvestX эхлэл';

  @override
  String get ipsSplashSubtitle =>
      'Одоогийн хэрэглэгч, login session болон IPS төлвийн эхлэлийн урсгалыг ажиллуулна.';

  @override
  String get ipsQuestionnaireTitle => 'Асуумж';

  @override
  String get ipsQuestionnaireSubtitle =>
      'Асуумжийн жагсаалт авах болон оноо тооцох урсгал.';

  @override
  String get ipsQuestionnaireCalculateScore => 'Оноо тооцоолох';

  @override
  String ipsQuestionnaireQuestionPrefix(Object index) {
    return 'Асуулт $index';
  }

  @override
  String ipsQuestionnaireOptionPrefix(Object index) {
    return 'Сонголт $index';
  }

  @override
  String get ipsQuestionnaireResTitle => 'Тооцсон үр дүн';

  @override
  String get ipsQuestionnaireCustomerCode => 'Харилцагчийн код';

  @override
  String get ipsQuestionnaireViewPacks => 'Санал болгосон багц харах';

  @override
  String get ipsQuestionnaireMissingService =>
      'Асуумжийн service тохируулагдаагүй байна.';

  @override
  String get ipsQuestionnaireScore => 'Оноо';

  @override
  String get ipsQuestionnaireSummary => 'Тайлбар';

  @override
  String get ipsQuestionnaireLoading => 'Асуумжийг ачаалж байна.';

  @override
  String get ipsQuestionnaireRecommendationTitle => 'Таны итгэлт зөвлөх';

  @override
  String get ipsQuestionnaireRecommendationBody =>
      'Хэдхэн асуултад хариулаад танд хамгийн тохирох INVESTX багцын зөвлөмжийг бэлтгэе.';

  @override
  String get ipsQuestionnaireCalculatingMessage =>
      'Танд хамгийн тохирох багцын зөвлөмжийг бэлтгэж байна.';

  @override
  String get ipsQuestionnaireStaticQuestionTitle => 'Хөрөнгө оруулалтын хэмжээ';

  @override
  String get ipsQuestionnaireStaticOption100k => '100,000';

  @override
  String get ipsQuestionnaireStaticOption200k => '200,000';

  @override
  String get ipsQuestionnaireStaticOption500k => '500,000';

  @override
  String get ipsQuestionnaireStaticOption1000000Plus => '1,000,000+';

  @override
  String get ipsQuestionnaireTargetGoalMissing =>
      'Үргэлжлүүлэхийн өмнө хөрөнгө оруулах дүнгээ сонгоно уу.';

  @override
  String get ipsSignatureUploading => 'Гарын үсгийг илгээж байна.';

  @override
  String get ipsPackTitle => 'Санал болгосон багц';

  @override
  String get ipsPackSubtitle => 'IPS багцын санал болон сонголтын урсгал.';

  @override
  String get ipsPackRecommendedBadge => 'Санал болгосон';

  @override
  String get ipsPackChoosePack => 'Багц сонгох';

  @override
  String get ipsPackAllocation => 'Хуваарилалт';

  @override
  String get ipsPackBondPercent => 'Бонд';

  @override
  String get ipsPackStockPercent => 'Хувьцаа';

  @override
  String get ipsPackAssetPercent => 'Бусад хөрөнгө';

  @override
  String get ipsPackNoPacks => 'Санал болгосон багц ирсэнгүй.';

  @override
  String get ipsPackMissingService => 'Багцын service тохируулагдаагүй байна.';

  @override
  String get ipsPackSrcFiCodeRequired =>
      'Official pack API дуудахдаа questionnaire-ийн srcFiCode шаардлагатай.';

  @override
  String get ipsPackCode => 'Багцын код';

  @override
  String get ipsPackSecondaryName => 'Нэмэлт нэр';

  @override
  String get ipsPackLoading => 'Санал болгосон багцыг ачаалж байна.';

  @override
  String ipsPackAllocationValue(Object bond, Object stock) {
    return 'Бонд $bond%, Хувьцаа $stock%';
  }

  @override
  String get ipsContractTitle => 'Гэрээ';

  @override
  String get ipsContractSubtitle =>
      'Гэрээ үүсгэх болон гарын үсгийн баталгаажуулалт.';

  @override
  String get ipsContractCreate => 'Гэрээ үүсгэх';

  @override
  String get ipsContractTermsTitle => 'Үйлчилгээний нөхцөл';

  @override
  String get ipsContractMissingPack => 'Багцын сонголтын мэдээлэл алга.';

  @override
  String get ipsContractMissingService =>
      'Гэрээний service тохируулагдаагүй байна.';

  @override
  String get ipsContractCreated => 'Гэрээ үүслээ';

  @override
  String get ipsContractOpenPortfolio => 'Хөрөнгө оруулалтын багц нээх';

  @override
  String get ipsContractId => 'Гэрээний дугаар';

  @override
  String get ipsContractRiskScore => 'Эрсдэлийн оноо';

  @override
  String get ipsContractTermsBody =>
      'Санал болгосон багцыг баталгаажуулж, үйлчилгээний нөхцөлийг зөвшөөрөөд IPS гэрээг үүсгэнэ.';

  @override
  String get ipsContractPreparingAccounts =>
      'IPS дансуудыг үүсгэж, багцын мэдээллийг ачаалж байна.';

  @override
  String get ipsContractPackQuantityPrompt => 'Авах ширхэгийн тоог оруулна уу.';

  @override
  String get ipsContractUnitPrice => 'Нэгж багцын үнэ';

  @override
  String get ipsContractServiceFee => 'Үйлчилгээний шимтгэл';

  @override
  String get ipsContractIpsAccountsMissing =>
      'Шаардлагатай IPS дансууд хараахан бэлэн болоогүй байна. Дахин оролдоно уу.';

  @override
  String get ipsContractPackPricingUnavailable =>
      'Сонгосон багцын үнийн мэдээлэл одоогоор байхгүй байна. Дахин оролдоно уу.';

  @override
  String get ipsContractPreparingPayment =>
      'Гэрээ, төлбөрийн хүсэлт, wallet төлбөрийг бэлтгэж байна.';

  @override
  String get ipsPortfolioTitle => 'Хөрөнгө оруулалтын багц';

  @override
  String get ipsPortfolioSubtitle =>
      'IPS дансны тойм, эзэмшил, өгөөж, ашиг/алдагдал.';

  @override
  String get ipsPortfolioAvailableBalance => 'Боломжит үлдэгдэл';

  @override
  String get ipsPortfolioInvestedBalance => 'Хөрөнгө оруулсан үлдэгдэл';

  @override
  String get ipsPortfolioProfitLoss => 'Ашиг/Алдагдал';

  @override
  String get ipsPortfolioYield => 'Өгөөж';

  @override
  String get ipsPortfolioHoldings => 'Миний багц';

  @override
  String get ipsPortfolioNoHoldings => 'Эзэмшлийн мэдээлэл алга.';

  @override
  String get ipsPortfolioRecharge => 'Цэнэглэх';

  @override
  String get ipsPortfolioSellOrder => 'Зарах захиалга';

  @override
  String get ipsPortfolioOrderList => 'Захиалгын жагсаалт';

  @override
  String get ipsPortfolioStatements => 'Хуулга';

  @override
  String get ipsPortfolioMissingService =>
      'Хөрөнгө оруулалтын багцын service тохируулагдаагүй байна.';

  @override
  String get ipsPortfolioLoading =>
      'Хөрөнгө оруулалтын багцын тоймыг ачаалж байна.';

  @override
  String get ipsPortfolioHoldingQuantity => 'Тоо ширхэг';

  @override
  String get ipsPortfolioHoldingValueLabel => 'Одоогийн үнэлгээ';

  @override
  String ipsPortfolioHoldingValue(Object quantity, Object value) {
    return 'Тоо ширхэг $quantity • Үнэлгээ $value';
  }

  @override
  String get ipsOrdersTitle => 'Захиалга';

  @override
  String get ipsOrdersSubtitle => 'IPS захиалгын жагсаалт болон цуцлах урсгал.';

  @override
  String get ipsOrdersNoOrders => 'IPS захиалга алга.';

  @override
  String get ipsOrdersCancelOrder => 'Захиалга цуцлах';

  @override
  String get ipsOrdersCreatedAt => 'Үүсгэсэн огноо';

  @override
  String get ipsOrdersOrderId => 'Захиалгын дугаар';

  @override
  String get ipsOrdersMissingService =>
      'Захиалгын service тохируулагдаагүй байна.';

  @override
  String get ipsOrdersType => 'Захиалгын төрөл';

  @override
  String get ipsOrdersTypeBuy => 'Авах';

  @override
  String get ipsOrdersTypeSell => 'Зарах';

  @override
  String get ipsOrdersTypeRecharge => 'Цэнэглэх';

  @override
  String get ipsOrdersLoading => 'Захиалгын жагсаалтыг ачаалж байна.';

  @override
  String ipsOrdersCancelOrderConfirm(Object orderId) {
    return '$orderId захиалгыг цуцлах уу?';
  }

  @override
  String ipsOrdersSummary(Object type, Object status) {
    return '$type • $status';
  }

  @override
  String get ipsPaymentRechargeTitle => 'Багц цэнэглэх';

  @override
  String get ipsPaymentRechargeSubtitle =>
      'Солилцоо/цэнэглэлт болон QR үүсгэх урсгал.';

  @override
  String get ipsPaymentRechargeQuantityHint => 'Авах ширхэгийн тоог оруулна уу';

  @override
  String get ipsPaymentRechargeTotalAmount => 'Нийт дүн';

  @override
  String get ipsPaymentCreateQr => 'QR үүсгэх';

  @override
  String get ipsPaymentQrGenerated => 'Төлбөрийн QR үүслээ';

  @override
  String get ipsPaymentPending => 'Төлбөр хүлээгдэж байна.';

  @override
  String get ipsPaymentMissingService =>
      'Цэнэглэлт/төлбөрийн service тохируулагдаагүй байна.';

  @override
  String get ipsPaymentQrValue => 'QR утга';

  @override
  String get ipsPaymentAcntFlow => 'Дансны урсгал';

  @override
  String get ipsPaymentCreateInvoiceAndPay => 'Нэхэмжлэл үүсгээд төлөх';

  @override
  String get ipsPaymentInvoiceId => 'Нэхэмжлэлийн дугаар';

  @override
  String get ipsPaymentStatusTimedOut => 'Хугацаа хэтэрсэн';

  @override
  String get ipsPaymentStatusUnsupported => 'Дэмжигдээгүй';

  @override
  String get ipsPaymentInvoiceCreateFailed =>
      'SDK төлбөрийн нэхэмжлэл үүсгэж чадсангүй.';

  @override
  String get ipsPaymentInvalidInvoice =>
      'Төлбөрийн нэхэмжлэлийн хариунд ашиглах invoice ID байгаагүй.';

  @override
  String get ipsPaymentHostResponseTimedOut =>
      'Host аппын төлбөрийн хариу хүлээлгийн хугацаа дууслаа.';

  @override
  String get ipsPaymentHostCallbackFailed =>
      'Host аппын төлбөрийн callback амжилтгүй боллоо.';

  @override
  String get ipsSellTitle => 'Багц зарах';

  @override
  String get ipsSellCloseTitle => 'Багц хаах';

  @override
  String get ipsSellSubtitle => 'IPS багцын зарах захиалга үүсгэх урсгал.';

  @override
  String get ipsSellMissingService =>
      'Зарах захиалгын service тохируулагдаагүй байна.';

  @override
  String get ipsSellCreateOrder => 'Зарах захиалга үүсгэх';

  @override
  String get ipsSellPendingMessage =>
      'Энэ хүсэлт нь таны эзэмшиж буй бүх багцын нэгжийг зарж багцыг хаах үйлдэл юм.';

  @override
  String get ipsSellReminderBody =>
      'Доорх багцын тоо нь таны одоогийн багцын үлдэгдлээс автоматаар авсан болно. Хүсэлт илгээснээр эзэмшиж буй бүх багцын нэгжид зарах захиалга үүсэж, эцсийн дүн нь тухайн үеийн хөрөнгийн үнэлгээ, мөнгөн үлдэгдэл, шимтгэлээр тооцогдоно.';

  @override
  String get ipsSellQuantityClosing => 'Хааж буй багцын тоо';

  @override
  String get ipsSellTotalAmount => 'НИЙТ ДҮН';

  @override
  String get ipsSellProfit => 'АШИГ';

  @override
  String get ipsSellTotalFee => 'НИЙТ ШИМТГЭЛ';

  @override
  String get ipsSellPayoutAmount => 'Танд орох дүн';

  @override
  String get ipsSellSubmitRequest => 'Хүсэлт илгээх';

  @override
  String get ipsSellSuccessTitle => 'Таны төлбөр амжилттай төлөгдлөө';

  @override
  String get ipsSellSuccessBody =>
      'Таны багцаа хаах хүсэлтийг амжилттай хүлээн авлаа. Багцын арилжаа нь долоо хоног бүрийн Мягмар болон Пүрэв гаригт хийгдэнэ. Таны нийт хөрөнгө оруулалтын буцаалтын гүйлгээ ажлын 10 хоногт багтан хийгдэх бөгөөд таны арилжааны банкны данс руу орох болно.';

  @override
  String ipsSellPackLabel(int number) {
    return 'Багц $number';
  }

  @override
  String ipsSellAllocationLabel(int bond, int stock) {
    return '$bond% бонд, $stock% хувьцаа';
  }

  @override
  String get ipsStatementTitle => 'Хуулга';

  @override
  String get ipsStatementSubtitle => 'Хуулга болон дансны товч дүнгийн дэлгэц.';

  @override
  String get ipsStatementSummary => 'Хуулгын товч дүн';

  @override
  String get ipsStatementBeginBalance => 'Эхний үлдэгдэл';

  @override
  String get ipsStatementEndBalance => 'Эцсийн үлдэгдэл';

  @override
  String ipsStatementEntriesCount(int count) {
    return '$count гүйлгээ';
  }

  @override
  String get ipsStatementMissingService =>
      'Хуулгын service тохируулагдаагүй байна.';

  @override
  String get ipsStatementsLoading => 'Хуулгын товч мэдээллийг ачаалж байна.';

  @override
  String get ipsYieldTitle => 'Өгөөж';

  @override
  String get ipsYieldSubtitle => 'Хөрөнгө оруулалтын багцын өгөөжийн задаргаа.';

  @override
  String get ipsYieldDetails => 'Өгөөжийн дэлгэрэнгүй';

  @override
  String get ipsProfitTitle => 'Ашиг алдагдал';

  @override
  String get ipsProfitSubtitle => 'IPS эзэмшлийн ашиг алдагдлын товч мэдээлэл.';

  @override
  String get ipsProfitSummary => 'Ашиг алдагдлын тойм';

  @override
  String get ipsSuccessReqCreated => 'Хүсэлт амжилттай үүслээ.';

  @override
  String get ipsSuccessOrderCancelled => 'Захиалгыг амжилттай цуцаллаа.';

  @override
  String get ipsSuccessContractCreated => 'Гэрээг амжилттай үүсгэлээ.';

  @override
  String get ipsSuccessQrCreated => 'QR амжилттай үүслээ.';

  @override
  String get ipsStatusPending => 'Хүлээгдэж буй';

  @override
  String get ipsStatusActive => 'Идэвхтэй';

  @override
  String get ipsStatusCompleted => 'Амжилттай';

  @override
  String get ipsStatusCancelled => 'Цуцлагдсан';

  @override
  String get ipsStatusFailed => 'Амжилтгүй';

  @override
  String get ipsUnknownRouteTitle => 'Маршрут олдсонгүй';

  @override
  String ipsUnknownRouteMessage(Object route) {
    return 'IPS дотор $route маршрут бүртгэгдээгүй байна.';
  }

  @override
  String internalUnknownRouteMessage(Object, Object route) {
    return ' модульд $route маршрут бүртгэгдээгүй байна.';
  }

  @override
  String get internalProfileCatalogTitle => 'Профайл дэлгэцүүд';

  @override
  String get internalProfileModuleName => 'Профайл';

  @override
  String get internalProfileRouteHomeTitle => 'Холбоо барих мэдээлэл шинэчлэх';

  @override
  String get internalProfileRouteHomeDescription =>
      'Одоогийн и-мэйл болон утасны мэдээллийг шалгана.';

  @override
  String get internalProfileRouteUpdateEmailTitle => 'И-мэйл шинэчлэх';

  @override
  String get internalProfileRouteUpdateEmailDescription =>
      'Шинэ и-мэйл хаягаа оруулна.';

  @override
  String get internalProfileRouteVerifyEmailTitle => 'И-мэйл баталгаажуулах';

  @override
  String get internalProfileRouteVerifyEmailDescription =>
      'И-мэйлээр ирсэн баталгаажуулах кодоо оруулна.';

  @override
  String get internalProfileRouteEmailVerifiedTitle => 'И-мэйл баталгаажсан';

  @override
  String get internalProfileRouteEmailVerifiedDescription =>
      'И-мэйл баталгаажуулалт амжилттай болсон төлөв.';

  @override
  String get internalProfileRouteUpdatePhoneTitle => 'Утас шинэчлэх';

  @override
  String get internalProfileRouteUpdatePhoneDescription =>
      'Шинэ утасны дугаараа оруулна.';

  @override
  String get internalProfileRouteVerifyPhoneTitle => 'Утас баталгаажуулах';

  @override
  String get internalProfileRouteVerifyPhoneDescription =>
      'Утсаар ирсэн баталгаажуулах кодоо оруулна.';

  @override
  String get internalProfileRoutePhoneVerifiedTitle => 'Утас баталгаажсан';

  @override
  String get internalProfileRoutePhoneVerifiedDescription =>
      'Утас баталгаажуулалт амжилттай болсон төлөв.';

  @override
  String get internalProfileRouteReviewUpdatesTitle => 'Шинэчлэл шалгах';

  @override
  String get internalProfileRouteReviewUpdatesDescription =>
      'Шинэчилсэн холбоо барих мэдээллээ шалгана.';

  @override
  String get internalProfileRouteConfirmChangesTitle => 'Өөрчлөлт батлах';

  @override
  String get internalProfileRouteConfirmChangesDescription =>
      'Хадгалахаас өмнө холбоо барих мэдээллийн өөрчлөлтөө батална.';

  @override
  String get internalProfileRouteUpdateCompleteTitle => 'Шинэчлэл дууссан';

  @override
  String get internalProfileRouteUpdateCompleteDescription =>
      'Холбоо барих мэдээлэл шинэчилж дууссан төлөв.';

  @override
  String get internalProfileProcessing => 'Боловсруулж байна...';

  @override
  String get internalProfileFlowProgressTitle => 'Урсгалын явц';

  @override
  String internalProfileFlowProgressStep(Object step, Object total) {
    return '$total алхмын $step-р алхам';
  }

  @override
  String get internalProfileSectionDetailsTitle => 'Профайлын мэдээлэл';

  @override
  String get internalProfileFieldFullName => 'Овог нэр';

  @override
  String get internalProfileFieldCurrentEmail => 'Одоогийн и-мэйл';

  @override
  String get internalProfileFieldCurrentPhone => 'Одоогийн утас';

  @override
  String get internalProfileFieldSdkVersion => 'SDK хувилбар';

  @override
  String get internalProfileFieldNewEmail => 'Шинэ и-мэйл';

  @override
  String get internalProfileFieldNewPhone => 'Шинэ утасны дугаар';

  @override
  String get internalProfileFieldUpdatedEmail => 'Шинэчилсэн и-мэйл';

  @override
  String get internalProfileFieldUpdatedPhone => 'Шинэчилсэн утас';

  @override
  String get internalProfileFieldUpdatedBy => 'Шинэчилсэн хэрэглэгч';

  @override
  String get internalProfileContactEntryHint =>
      'Баталгаажуулалт хүсэхээс өмнө оруулсан утга зөв эсэхийг нягтална уу.';

  @override
  String get internalProfileVerificationInstructions =>
      'Хамгийн сүүлд ашигласан холбоо барих сувгаар ирсэн 6 оронтой кодоо оруулна уу.';

  @override
  String get internalProfileVerificationCodeLabel => 'Баталгаажуулах код';

  @override
  String get internalProfileInvalidVerificationCode =>
      'Баталгаажуулах код буруу байна.';

  @override
  String get internalProfileVerificationSuccess =>
      'Баталгаажуулалт амжилттай дууслаа.';

  @override
  String get internalProfileUpdateSuccess =>
      'Холбоо барих мэдээлэл амжилттай шинэчлэгдлээ.';

  @override
  String get internalAuthCatalogTitle => 'Нэвтрэх дэлгэцүүд';

  @override
  String get internalAuthModuleName => 'Нэвтрэх';

  @override
  String get internalAuthRouteRegistrationTitle => 'Бүртгэл үүсгэх';

  @override
  String get internalAuthRouteRegistrationDescription =>
      'Auth дизайны жишээнээс хөрвүүлсэн бүртгэлийн урсгал.';

  @override
  String get internalAuthRouteRegistrationConfirmationTitle => 'Бүртгэл батлах';

  @override
  String get internalAuthRouteRegistrationConfirmationDescription =>
      'Нөхцөлөө шалгаж, данс нээх тохиргоогоо дуусгана.';

  @override
  String get internalAuthContinueRegistration => 'Бүртгэл үргэлжлүүлэх';

  @override
  String get internalAuthSectionPersonalInformation => 'Хувийн мэдээлэл';

  @override
  String get internalAuthFieldFullName => 'Овог нэр';

  @override
  String get internalAuthFieldEmail => 'И-мэйл хаяг';

  @override
  String get internalAuthFieldPhone => 'Утасны дугаар';

  @override
  String get internalAuthFinishRegistration => 'Бүртгэл дуусгах';

  @override
  String get internalAuthSectionVerification => 'Баталгаажуулалт';

  @override
  String get internalAuthIdentityCheck => 'Иргэний баталгаажуулалт';

  @override
  String get internalAuthPendingReview => 'Шалгаж байна';

  @override
  String get internalAuthEmailVerification => 'И-мэйл баталгаажуулалт';

  @override
  String get internalAuthPhoneVerification => 'Утас баталгаажуулалт';

  @override
  String get internalAuthVerified => 'Баталгаажсан';

  @override
  String get internalAuthSectionConsent => 'Зөвшөөрөл';

  @override
  String get internalAuthConsentBody =>
      'Үйлчилгээний нөхцөл болон нууцлалын бодлогыг зөвшөөрч байна.';

  @override
  String get internalStatesCatalogTitle => 'Төлвийн дэлгэцүүд';

  @override
  String get internalStatesModuleName => 'Төлвүүд';

  @override
  String get internalStatesRouteSplashTitle => 'Splash';

  @override
  String get internalStatesRouteSplashDescription =>
      'Брэнд нэвтрэх анхны splash төлөв.';

  @override
  String get internalStatesRouteSplashAlternateTitle => 'Splash хувилбар';

  @override
  String get internalStatesRouteSplashAlternateDescription =>
      'Splash дэлгэцийн хоёрдогч хувилбар.';

  @override
  String get internalStatesRouteLoadingTitle => 'Ачаалалтын дэлгэц';

  @override
  String get internalStatesRouteLoadingDescription =>
      'Нөхцөлт тайлбартай ачаалалтын төлөв.';

  @override
  String get internalStatesRouteKycOverlayTitle => 'KYC overlay';

  @override
  String get internalStatesRouteKycOverlayDescription =>
      'KYC шаардлагатай үед харуулах дараагийн алхмын дэлгэц.';

  @override
  String get internalStatesSplashHeroPrimaryTitle => '';

  @override
  String get internalStatesSplashHeroPrimarySubtitle =>
      'Таны ажлын орчныг бэлдэж байна...';

  @override
  String get internalStatesSplashHeroAlternateTitle => ' Finance';

  @override
  String get internalStatesSplashHeroAlternateSubtitle =>
      'Танд зориулсан самбарыг ачаалж байна...';

  @override
  String get internalStatesLoadingMessage => 'Дансны мэдээллийг татаж байна...';

  @override
  String get internalStatesLoadingHint =>
      'Энэ дэлгэцийг бэлдэх хүртэл түр хүлээнэ үү.';

  @override
  String get internalStatesKycDefaultStatusMessage =>
      'Бүх wallet боломжийг ашиглахын тулд баталгаажуулалтаа дуусгана уу.';

  @override
  String get internalStatesKycSuccessTitle =>
      'Иргэний баталгаажуулалт амжилттай';

  @override
  String get internalStatesKycSuccessSubtitle =>
      'Таны профайл баталгаажсан тул бүх боломжийг ашиглах боломжтой боллоо.';

  @override
  String get internalStatesKycRequiredTitle => 'KYC шаардлагатай';

  @override
  String get internalStatesKycRequiredSubtitle =>
      'Үргэлжлүүлэхийн өмнө профайлын баталгаажуулалт шаардлагатай.';

  @override
  String get internalStatesKycStartVerification => 'Баталгаажуулалт эхлүүлэх';

  @override
  String get internalStatesKycLater => 'Дараа';

  @override
  String get internalStatesKycScanningId => 'Бичиг баримт шалгаж байна...';

  @override
  String get internalStatesKycVerifying => 'Баталгаажуулж байна...';

  @override
  String get internalStatesKycCapturingBiometric =>
      'Биометрийн мэдээлэл авч байна...';

  @override
  String get internalStatesKycFailureFaceMatch =>
      'Нүүр тулгалт амжилтгүй боллоо.Гэрэл сайтай орчинд дахин оролдоно уу.';

  @override
  String get reject => 'Татгалзах';

  @override
  String get accept => 'Зөвшөөрч байна';

  @override
  String get tinoConsent =>
      'Таны Tino апп дээрх бүртгэлтэй байгаа мэдээллийг ашиглахыг зөвшөөрч байна уу';

  @override
  String get commonSuccess => 'Амжилттай';

  @override
  String get commonWarning => 'Анхаарах';

  @override
  String get commonPay => 'Төлбөр төлөх';

  @override
  String get commonGoHome => 'Нүүр хуудас руу очих';

  @override
  String get commonHome => 'Нүүр';

  @override
  String get commonProfile => 'Миний';

  @override
  String get commonBank => 'Банк';

  @override
  String get commonIban => 'IBAN дугаар';

  @override
  String get commonPackUnit => 'PACK';

  @override
  String get commonBrandInvestx => 'investX';

  @override
  String get commonDrawSignaturePrompt =>
      'Та гарын үсгээ зурж баталгаажуулна уу';

  @override
  String get commonSignaturePlaceholder => 'Энд гарын үсгээ зурна уу';

  @override
  String get commonTotalPayable => 'Нийт төлөх дүн';

  @override
  String commonPackQuantity(Object count) {
    return '$count PACK';
  }

  @override
  String get secAcntPersonalInformationSubtitle =>
      'Та өөрийн хувийн мэдээллээ оруулна уу.';

  @override
  String get secAcntFieldSecondaryPhone => 'Нэмэлт утасны дугаар';

  @override
  String get secAcntBankSelectionTitle => 'Банк сонгох';

  @override
  String get secAcntPaymentSheetTitle => 'Tino Pay';

  @override
  String get secAcntPaymentOptionTinoBalance => 'Tino харилцах үлдэгдэл';

  @override
  String get secAcntPaymentOptionTinoPayLater => 'Tino Pay Later эрх';

  @override
  String get secAcntSuccessBankDetailsTitle => 'Банкны мэдээлэл';

  @override
  String get secAcntAgreementConsent =>
      'Би ҮЦ-ын данс нээх гэрээ болон үйлчилгээний нөхцөлтэй танилцаж, зөвшөөрч байна.';

  @override
  String get secAcntServiceFeeTitle => 'Үйлчилгээний хураамж';

  @override
  String get secAcntPaymentTitle => 'Үнэт цаасны данс нээх хураамж';

  @override
  String secAcntPaymentTitleWithAmount(Object amount) {
    return 'Үнэт цаасны данс нээх хураамж $amount';
  }

  @override
  String get secAcntPaymentNoticeMessage =>
      'Энэхүү данс нээгдсэнээр та дотоод болон гадаад зах зээлийн хөрөнгө оруулалт хийх боломжтой болно.';

  @override
  String get secAcntPaymentAmountUnavailable =>
      'Төлөх дүнг одоогоор авч чадсангүй. Дансны мэдээллээ шинэчлээд дахин оролдоно уу.';

  @override
  String get secAcntPaymentFailedTitle => 'Төлбөр амжилтгүй';

  @override
  String get secAcntCalculationTitle => 'Таны төлбөр амжилттай төлөгдлөө';

  @override
  String get secAcntCalculationMessageTitle =>
      'Таны бүртгэлийн хүсэлт амжилттай үүслээ';

  @override
  String get secAcntCalculationPendingMessage =>
      'Таны бүртгэлийн хүсэлт шалгагдаж байна. Баталгаажмагц танд мэдэгдэх болно.';

  @override
  String get secAcntBankNotSelected => 'Банк сонгоогүй';

  @override
  String get secAcntProfileUpdating => 'Хувийн мэдээллийг хадгалж байна.';

  @override
  String get secAcntInvestxAgreementTitle => 'INVESTX үйлчилгээний гэрээ';

  @override
  String get secAcntSecuritiesAgreementTitle => 'Үнэт цаасны данс нээх гэрээ';

  @override
  String get secAcntInvestxAgreementText =>
      '1. Энэхүү INVESTX үйлчилгээний гэрээ нь хөрөнгө оруулалтын үйлчилгээг эхлүүлэх, хэрэглэгчийн мэдээллийг баталгаажуулах, дансны ашиглалттай холбоотой үндсэн нөхцөлийг тодорхойлно.\n\n2. Хэрэглэгч нь оруулсан мэдээлэл үнэн зөв болохыг баталгаажуулж, үйлчилгээтэй холбоотой мэдэгдлийг апп дотор болон бүртгэлтэй сувгаар хүлээн авна.\n\n3. INVESTX үйлчилгээний дараагийн шатуудад эрсдэлийн асуумж, багцын сонголт, худалдан авалтын үйлдэл дарааллаар идэвхжинэ.';

  @override
  String get secAcntSecuritiesAgreementText =>
      '1. Үнэт цаасны данс нээх хүсэлт гаргах үед хэрэглэгчийн овог, нэр, регистр, холбоо барих мэдээлэл болон банкны мэдээллийг баталгаажуулна.\n\n2. Данс нээхтэй холбоотой шимтгэл, баталгаажуулалтын хугацаа болон үйлчилгээний нөхцөлийг хэрэглэгч урьдчилан зөвшөөрсөн байна.\n\n3. Баталгаажуулалтын явц амжилттай дууссаны дараа дараагийн шатны INVESTX үйлчилгээний гэрээ болон эрсдэлийн асуумж нээгдэнэ.';

  @override
  String get secAcntTermsText =>
      '1. Энэхүү үйлчилгээний нөхцөл нь хэрэглэгчийн хөрөнгө оруулалтын дансны бүртгэл, ашиглалт, мэдээллийн аюулгүй байдалтай холбоотой нийтлэг журмыг тодорхойлно.\n\n2. Апп дотор илгээсэн хүсэлт, гарын үсэг, зөвшөөрөл болон төлбөрийн баталгаажуулалтыг системийн хүчинтэй үйлдэл гэж үзнэ.\n\n3. Бүртгэлийн хүсэлт шалгагдаж байх хугацаанд зарим үйлдэл хязгаарлагдаж болох ба шалгалт амжилттай дуусмагц хэрэглэгчид мэдэгдэнэ.\n\n4. Хэрэглэгч үйлчилгээний явцад шинэчилсэн нөхцөл гарсан тохиолдолд мэдэгдлийг хүлээн авч танилцан, шаардлагатай тохиолдолд дахин зөвшөөрөл өгнө.';

  @override
  String get ipsPackBenefitStableYield => 'Тогтвортой өгөөжийг зорьдог';

  @override
  String get ipsPackBenefitLowVolatility => 'Хэлбэлзэл бага';

  @override
  String get ipsPackBenefitMinRisk => 'Эрсдэл хамгийн бага';

  @override
  String get ipsPackBenefitStockGrowth => 'Өсөлтийн боломжтой хувьцааны жинтэй';

  @override
  String get ipsPackBenefitBalancedStructure => 'Тэнцвэртэй бүтэцтэй багц';

  @override
  String get ipsPackBenefitGrowthFocused => 'Илүү өсөлт чиглэсэн бүтэцтэй';

  @override
  String get ipsOverviewPackPrompt => 'Та өөрт тохирсон багцаа сонгоно уу';

  @override
  String get ipsPackPerfectFit => 'Танд тэгс тохирох';

  @override
  String get advice => 'Зөвлөмж';

  @override
  String get investmentFund => 'Хөрөнгө оруулалтын сан';

  @override
  String get ipsHelpTitle => 'Тусламж';

  @override
  String get ipsHelpContactTitle => 'Холбоо барих';

  @override
  String get ipsHelpEmail => 'И-Мэйл';

  @override
  String get ipsHelpPhone => 'Дугаар';

  @override
  String get ipsHelpLocationTitle => 'Хаяг байршил';

  @override
  String get ipsHelpLocationWorkingHours => 'Даваа - Баасан 09:00 - 18:00';

  @override
  String get ipsFeedbackTitle => 'Санал хүсэлт';

  @override
  String get ipsFeedbackEmptyTitle => 'Одоогоор та санал гомдол өгөөгүй байна';

  @override
  String get ipsFeedbackEmptyBody =>
      'Та санал гомдол өгөх товч дээр дарж санал гомдлоо өгнө үү';

  @override
  String get ipsFeedbackCreateButton => 'Санал гомдол өгөх';

  @override
  String get ipsFeedbackCreateTitle => 'Гарчиг';

  @override
  String get ipsFeedbackCreateTitleHint => 'Утга оруулна уу';

  @override
  String get ipsFeedbackCreateBody => 'Тайлбар';

  @override
  String get ipsFeedbackCreateBodyHint => 'Дэлгэрэнгүй тайлбар оруулна уу';

  @override
  String get ipsFeedbackStatusReviewing => 'Илгээгдсэн';

  @override
  String get ipsFeedbackStatusResolved => 'Шийдвэрлэсэн';

  @override
  String get ipsFeedbackStatusClosed => 'Хаагдсан';

  @override
  String get ipsRewardTitle => 'Таны амжилт';

  @override
  String get ipsRewardGoalTitle => 'Зорилтот зорилго';

  @override
  String get ipsRewardGoalProgress => 'Биелүүлэлт';

  @override
  String get ipsRewardStreakTitle => 'Тасралтгүй хөрөнгө оруулалт';

  @override
  String ipsRewardStreakMonths(int current, int total) {
    return '$current / $total сар';
  }

  @override
  String ipsRewardStreakNextReward(Object reward) {
    return 'Дараагийн урамшуулал: +$reward';
  }

  @override
  String get ipsRewardNextGoalTitle => 'Дараагийн зорилго';

  @override
  String get ipsRewardNextGoalBody =>
      '6 сар хүрэхэд таны хүү 2% нэмэгдэж, VIP боломжууд нээгдэнэ';

  @override
  String ipsRewardMilestoneMonths(int count) {
    return '$count Сар';
  }

  @override
  String get ipsStatementFilterTitle => 'Хуулга шүүх';

  @override
  String get ipsStatementFilterAmountTitle => 'Хуулганы унийн дүн';

  @override
  String get ipsStatementFilterDateTitle => 'Огноо';

  @override
  String get ipsStatementFilterToday => 'Өчигдөр';

  @override
  String get ipsStatementFilterWeek => '7 хоног';

  @override
  String get ipsStatementFilterMonth => '1 сар';

  @override
  String get ipsStatementFilter3Months => '3 сар';

  @override
  String get ipsStatementFilterClear => 'Цэвэрлэх';

  @override
  String ipsStatementFilterSearch(int count) {
    return 'Хайх ($count)';
  }

  @override
  String get ipsStatementTypeIncome => 'Орлого';

  @override
  String get ipsStatementTypeExpense => 'Зарлага';

  @override
  String get ipsStatementInvestment => 'Хөрөнгө оруулалт';

  @override
  String get commonSave => 'Хадгалах';

  @override
  String get commonSearch => 'Хайх';

  @override
  String get commonAll => 'Бүгд';

  @override
  String get ipsPortfolioFilterAll => 'Бүгд';

  @override
  String get ipsPortfolioFilterBonds => 'Бонд';

  @override
  String get ipsPortfolioFilterStocks => 'Хувьцаа';

  @override
  String get closedPrice => 'Хаалтын ханш';

  @override
  String get closedDate => 'Огноо';
}
