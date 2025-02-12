import 'package:dion_app/core/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dion_app/features/authintication_feature/services/auth_service.dart';
import 'package:dion_app/features/authintication_feature/repository/auth_repository.dart';
import 'package:dion_app/features/home_screen/repository/loaning_repository.dart';
import 'package:dion_app/features/loans_list/domain/repostry/settling_reposotory.dart';
import 'package:dion_app/features/loans_list/domain/repostry/loans_repostry.dart';
import 'package:dion_app/features/reset_password/domain/reset_password_impl.dart';
import 'package:dion_app/features/profile_feature/data/repostry/profile_data_repostry_impl.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // تسجيل التبعيات كـ Lazy Singletons (يتم إنشاؤها عند الطلب)
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<DioService>(() => DioService());

  // تسجيل الـ repositories والخدمات الأخرى التي تعتمد على التبعيات السابقة
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<LoanRepository>(
    () => LoanRepository(authService: getIt<AuthService>()),
  );
  getIt.registerLazySingleton<LoaningRepository>(
    () => LoaningRepository(
      authService: getIt<AuthService>(),
      dioService: getIt<DioService>(),
    ),
  );
  getIt.registerLazySingleton<SettlingRepository>(
    () => SettlingRepository(authService: getIt<AuthService>()),
  );
  getIt.registerLazySingleton<ResetPasswordImpl>(() => ResetPasswordImpl());
  getIt.registerLazySingleton<ProfileDataRepostryImpl>(
    () => ProfileDataRepostryImpl(authService: getIt<AuthService>()),
  );
}
