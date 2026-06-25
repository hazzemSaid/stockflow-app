import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/companies/domain/usecases/create_company_full_usecase.dart';

enum CreateCompanyStatus { initial, loading, success, error }

class CreateCompanyState extends Equatable {
  final CreateCompanyStatus status;
  final String? imagePath;
  final String? errorMessage;

  const CreateCompanyState({
    this.status = CreateCompanyStatus.initial,
    this.imagePath,
    this.errorMessage,
  });

  CreateCompanyState copyWith({
    CreateCompanyStatus? status,
    String? imagePath,
    String? errorMessage,
  }) {
    return CreateCompanyState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, imagePath, errorMessage];
}

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  final CreateCompanyFullUseCase _createCompanyFullUseCase;
  final CompanyCubit _companyCubit;
  final ImagePicker _picker;
  final SupabaseClient _supabase;

  CreateCompanyCubit({
    required CreateCompanyFullUseCase createCompanyFullUseCase,
    required CompanyCubit companyCubit,
    required ImagePicker picker,
    required SupabaseClient supabase,
  })  : _createCompanyFullUseCase = createCompanyFullUseCase,
        _companyCubit = companyCubit,
        _picker = picker,
        _supabase = supabase,
        super(const CreateCompanyState());

  Future<void> pickImageFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      emit(state.copyWith(imagePath: file.path, errorMessage: null));
    }
  }

  Future<void> pickImageFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (file != null) {
      emit(state.copyWith(imagePath: file.path, errorMessage: null));
    }
  }

  void clearImage() {
    emit(state.copyWith(imagePath: null));
  }

  Future<bool> createCompany({
    required String name,
    String? businessType,
    String? phone,
    String? address,
  }) async {
    if (name.trim().isEmpty) {
      emit(state.copyWith(
        status: CreateCompanyStatus.error,
        errorMessage: AppStrings.businessNameRequired,
      ));
      return false;
    }

    emit(state.copyWith(
      status: CreateCompanyStatus.loading,
      errorMessage: null,
    ));

    String? logoUrl;
    if (state.imagePath != null) {
      try {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_logo.jpg';
        final file = File(state.imagePath!);
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
        emit(state.copyWith(
          status: CreateCompanyStatus.error,
          errorMessage: AppStrings.uploadLogoError,
        ));
        return false;
      }
    }

    final result = await _createCompanyFullUseCase.call(
      name: name.trim(),
      businessType: businessType,
      phone: phone?.trim().isEmpty == true ? null : phone?.trim(),
      address: address?.trim().isEmpty == true ? null : address?.trim(),
      logoUrl: logoUrl,
    );

    return await result.fold(
      (failure) async {
        emit(state.copyWith(
          status: CreateCompanyStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (company) async {
        try {
          await _companyCubit.switchCompany(company);
          emit(state.copyWith(status: CreateCompanyStatus.success));
          return true;
        } catch (e) {
          emit(state.copyWith(
            status: CreateCompanyStatus.error,
            errorMessage: e.toString(),
          ));
          return false;
        }
      },
    );
  }

  void resetStatus() {
    emit(const CreateCompanyState());
  }
}
