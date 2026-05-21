import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root screen for the IPS sell flow.
class SellScreen extends StatelessWidget {
  /// Creates the root sell flow screen.
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IpsSellCubit, IpsSellState>(
      listenWhen: (IpsSellState previous, IpsSellState current) {
        return (previous.message != current.message &&
                (current.message?.trim().isNotEmpty ?? false)) ||
            (previous.errorMessage != current.errorMessage &&
                (current.errorMessage?.trim().isNotEmpty ?? false)) ||
            (previous.refreshErrorMessage != current.refreshErrorMessage &&
                (current.refreshErrorMessage?.trim().isNotEmpty ?? false));
      },
      listener: (BuildContext context, IpsSellState state) {
        final String? errorMessage = state.errorMessage?.trim();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          MiniAppToast.showError(context, message: errorMessage);
          return;
        }

        final String? refreshErrorMessage = state.refreshErrorMessage?.trim();
        if (refreshErrorMessage != null && refreshErrorMessage.isNotEmpty) {
          MiniAppToast.showError(context, message: refreshErrorMessage);
          return;
        }

        final String? successMessage = state.message?.trim();
        if (successMessage != null && successMessage.isNotEmpty) {
          MiniAppToast.showSuccess(context, message: successMessage);
        }
      },
      builder: (BuildContext context, IpsSellState state) {
        if (state.isSuccess) {
          return SellSuccessView(state: state);
        }
        return SellRequestView(state: state);
      },
    );
  }
}
