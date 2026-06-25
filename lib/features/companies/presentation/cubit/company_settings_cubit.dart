import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import 'package:stockflow/features/companies/domain/usecases/get_company_usecase.dart';
import 'package:stockflow/features/companies/domain/usecases/update_company_usecase.dart';

sealed class CompanySettingsState extends Equatable {
  const CompanySettingsState();

  @override
  List<Object?> get props => [];
}

final class CompanySettingsInitial extends CompanySettingsState {
  const CompanySettingsInitial();
}

final class CompanySettingsLoading extends CompanySettingsState {
  const CompanySettingsLoading();
}

sealed class CompanySettingsData extends CompanySettingsState {
  final Company company;
  final String? imagePath;

  const CompanySettingsData({required this.company, this.imagePath});

  @override
  List<Object?> get props => [company, imagePath];
}

final class CompanySettingsLoaded extends CompanySettingsData {
  const CompanySettingsLoaded({required super.company, super.imagePath});
}

final class CompanySettingsUpdating extends CompanySettingsData {
  const CompanySettingsUpdating({required super.company, super.imagePath});
}

final class CompanySettingsSuccess extends CompanySettingsState {
  final String message;

  const CompanySettingsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class CompanySettingsError extends CompanySettingsState {
  final String message;

  const CompanySettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CompanySettingsCubit extends Cubit<CompanySettingsState> {
  final GetCompanyUseCase _getCompanyUseCase;
  final UpdateCompanyUseCase _updateCompanyUseCase;
  final ImagePicker _picker;
  final SupabaseClient _supabase;

  CompanySettingsCubit({
    required GetCompanyUseCase getCompanyUseCase,
    required UpdateCompanyUseCase updateCompanyUseCase,
    ImagePicker? picker,
    SupabaseClient? supabase,
  })  : _getCompanyUseCase = getCompanyUseCase,
        _updateCompanyUseCase = updateCompanyUseCase,
        _picker = picker ?? ImagePicker(),
        _supabase = supabase ?? Supabase.instance.client,
        super(const CompanySettingsInitial());

  Future<void> loadCompany(String companyId) async {
    emit(const CompanySettingsLoading());
    final result = await _getCompanyUseCase.call(companyId);
    result.fold(
      (failure) => emit(CompanySettingsError(failure.message)),
      (company) => emit(CompanySettingsLoaded(company: company)),
    );
  }

  Future<void> pickImageFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null && state is CompanySettingsData) {
      final data = state as CompanySettingsData;
      emit(CompanySettingsLoaded(company: data.company, imagePath: file.path));
    }
  }

  Future<void> pickImageFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (file != null && state is CompanySettingsData) {
      final data = state as CompanySettingsData;
      emit(CompanySettingsLoaded(company: data.company, imagePath: file.path));
    }
  }

  void clearImage() {
    if (state is CompanySettingsData) {
      final data = state as CompanySettingsData;
      emit(CompanySettingsLoaded(company: data.company, imagePath: null));
    }
  }

  Future<void> updateCompany({
    required String companyId,
    required String name,
    String? address,
    String? phone,
  }) async {
    final currentState = state;
    if (currentState is! CompanySettingsData) return;

    final company = currentState.company;
    final imagePath = currentState.imagePath;

    emit(CompanySettingsUpdating(company: company, imagePath: imagePath));

    String? logoUrl;
    if (imagePath != null) {
      try {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_logo.jpg';
        final file = File(imagePath);
        await _supabase.storage.from('company-logos').upload(
              fileName,
              file,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: true,
              ),
            );
        logoUrl =
            _supabase.storage.from('company-logos').getPublicUrl(fileName);
      } on Exception {
        emit(CompanySettingsError(
          '${AppStrings.uploadLogoError}: تعذر رفع الشعار',
        ));
        return;
      }
    }

    final result = await _updateCompanyUseCase.call(
      companyId,
      name: name,
      address: address,
      phone: phone,
      logoUrl: logoUrl,
    );

    result.fold(
      (failure) => emit(CompanySettingsError(failure.message)),
      (_) => emit(const CompanySettingsSuccess(AppStrings.companyUpdated)),
    );
  }
}
