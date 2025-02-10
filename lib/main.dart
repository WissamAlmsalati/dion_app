import 'package:dion_app/app.dart';
import 'package:dion_app/features/authintication_feature/repository/auth_repository.dart';
import 'package:dion_app/features/profile_feature/data/repostry/profile_data_repostry_impl.dart';
import 'package:dion_app/features/profile_feature/presentatioon/cubit/profile_cubit.dart';
import 'package:dion_app/features/reset_password/domain/reset_password_impl.dart';
import 'package:dion_app/features/reset_password/presentation/cubit/reset_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/authintication_feature/services/auth_service.dart';
import 'features/authintication_feature/viewmodel/auth_bloc.dart';
import 'features/home_screen/viewmodel/loaning_bloc.dart';
import 'features/loaning_feature/repository/loaning_repository.dart';
import 'features/settling_feature/reposittory/settling_reposotory.dart';
import 'features/settling_feature/viewmodel/settle_loan_bloc.dart';
import 'features/loans_list/domain/repostry/loans_repostry.dart';
import 'features/loans_list/viewmodel/get_list_loan/get_list_of_loans_bloc.dart';
import 'route.dart';

void main() {
  final AuthService authService = AuthService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final loaningRepository = LoaningRepository(authService: authService);

  runApp(MyApp(
      authService: authService,
      storage: secureStorage,
      loaningRepository: loaningRepository));
}

