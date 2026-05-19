import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IpsSellCubit, IpsSellState>(
      listenWhen: (IpsSellState previous, IpsSellState current) {
        return previous.refreshErrorMessage != current.refreshErrorMessage && (current.refreshErrorMessage?.trim().isNotEmpty ?? false);
      },
      listener: (BuildContext context, IpsSellState state) {
        final String? message = state.refreshErrorMessage?.trim();
        if (message == null || message.isEmpty) {
          return;
        }
        MiniAppToast.showError(context, message: message);
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
