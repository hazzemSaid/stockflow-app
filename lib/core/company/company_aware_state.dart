import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'company_cubit.dart';
import 'company_state.dart';

mixin CompanyAwareState<T extends StatefulWidget> on State<T> {
  StreamSubscription? _companySubscription;
  String _companyId = '';

  String get companyId => _companyId;

  @override
  void initState() {
    super.initState();
    _companyId = _readCompanyId();
    _companySubscription = context.read<CompanyCubit>().stream.listen((state) {
      if (state is CompanySelected && mounted) {
        if (state.companyId == _companyId) return;
        _companyId = state.companyId;
        onCompanyChanged(state.companyId);
      }
    });
  }

  String _readCompanyId() {
    final state = context.read<CompanyCubit>().state;
    return state is CompanySelected ? state.companyId : '';
  }

  void onCompanyChanged(String companyId);

  @override
  void dispose() {
    _companySubscription?.cancel();
    super.dispose();
  }
}
