import 'package:flutter/widgets.dart';

import '../../../l10n/sdk_localizations.dart';

extension SdkLocalizationsBuildContextX on BuildContext {
  SdkLocalizations get l10n => SdkLocalizations.of(this);
}
