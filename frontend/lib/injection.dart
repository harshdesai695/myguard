import 'package:get_it/get_it.dart';
import 'package:myguard_frontend/core/firebase/auth_service.dart';
import 'package:myguard_frontend/core/network/auth_interceptor.dart';
import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/storage/prefs_service.dart';
import 'package:myguard_frontend/core/storage/secure_storage_service.dart';
import 'package:myguard_frontend/features/amenity/data/datasources/amenity_remote_datasource.dart';
import 'package:myguard_frontend/features/amenity/data/repositories/amenity_repository_impl.dart';
import 'package:myguard_frontend/features/amenity/domain/repositories/amenity_repository.dart';
import 'package:myguard_frontend/features/amenity/domain/usecases/book_amenity_usecase.dart';
import 'package:myguard_frontend/features/amenity/domain/usecases/cancel_booking_usecase.dart';
import 'package:myguard_frontend/features/amenity/domain/usecases/get_amenities_usecase.dart';
import 'package:myguard_frontend/features/amenity/domain/usecases/get_amenity_slots_usecase.dart';
import 'package:myguard_frontend/features/amenity/domain/usecases/get_my_bookings_usecase.dart';
import 'package:myguard_frontend/features/amenity/presentation/bloc/amenity_bloc.dart';
import 'package:myguard_frontend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:myguard_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:myguard_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:myguard_frontend/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:myguard_frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:myguard_frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/communication/data/datasources/communication_remote_datasource.dart';
import 'package:myguard_frontend/features/communication/data/repositories/communication_repository_impl.dart';
import 'package:myguard_frontend/features/communication/domain/repositories/communication_repository.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/get_notices_usecase.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/get_polls_usecase.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/vote_poll_usecase.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/notice_cubit.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/poll_bloc.dart';
import 'package:myguard_frontend/features/dailyhelp/data/datasources/dailyhelp_remote_datasource.dart';
import 'package:myguard_frontend/features/dailyhelp/data/repositories/dailyhelp_repository_impl.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/repositories/dailyhelp_repository.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/usecases/get_daily_helps_usecase.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/usecases/mark_attendance_usecase.dart';
import 'package:myguard_frontend/features/dailyhelp/presentation/bloc/dailyhelp_cubit.dart';
import 'package:myguard_frontend/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:myguard_frontend/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:myguard_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:myguard_frontend/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:myguard_frontend/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:myguard_frontend/features/emergency/data/datasources/emergency_remote_datasource.dart';
import 'package:myguard_frontend/features/emergency/data/repositories/emergency_repository_impl.dart';
import 'package:myguard_frontend/features/emergency/domain/repositories/emergency_repository.dart';
import 'package:myguard_frontend/features/emergency/domain/usecases/get_emergency_contacts_usecase.dart';
import 'package:myguard_frontend/features/emergency/domain/usecases/trigger_panic_usecase.dart';
import 'package:myguard_frontend/features/emergency/presentation/bloc/emergency_cubit.dart';
import 'package:myguard_frontend/features/guard/data/datasources/guard_remote_datasource.dart';
import 'package:myguard_frontend/features/guard/data/repositories/guard_repository_impl.dart';
import 'package:myguard_frontend/features/guard/domain/repositories/guard_repository.dart';
import 'package:myguard_frontend/features/guard/domain/usecases/get_checkpoints_usecase.dart';
import 'package:myguard_frontend/features/guard/domain/usecases/log_patrol_usecase.dart';
import 'package:myguard_frontend/features/guard/presentation/bloc/patrol_cubit.dart';
import 'package:myguard_frontend/features/helpdesk/data/datasources/helpdesk_remote_datasource.dart';
import 'package:myguard_frontend/features/helpdesk/data/repositories/helpdesk_repository_impl.dart';
import 'package:myguard_frontend/features/helpdesk/domain/repositories/helpdesk_repository.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/create_ticket_usecase.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/get_tickets_usecase.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/bloc/helpdesk_bloc.dart';
import 'package:myguard_frontend/features/marketplace/data/datasources/marketplace_remote_datasource.dart';
import 'package:myguard_frontend/features/marketplace/data/repositories/marketplace_repository_impl.dart';
import 'package:myguard_frontend/features/marketplace/domain/repositories/marketplace_repository.dart';
import 'package:myguard_frontend/features/marketplace/domain/usecases/get_listings_usecase.dart';
import 'package:myguard_frontend/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:myguard_frontend/features/material/data/datasources/material_remote_datasource.dart';
import 'package:myguard_frontend/features/material/data/repositories/material_repository_impl.dart';
import 'package:myguard_frontend/features/material/domain/repositories/material_repository.dart';
import 'package:myguard_frontend/features/material/domain/usecases/get_gatepasses_usecase.dart';
import 'package:myguard_frontend/features/material/presentation/bloc/material_cubit.dart';
import 'package:myguard_frontend/features/pet/data/datasources/pet_remote_datasource.dart';
import 'package:myguard_frontend/features/pet/data/repositories/pet_repository_impl.dart';
import 'package:myguard_frontend/features/pet/domain/repositories/pet_repository.dart';
import 'package:myguard_frontend/features/pet/domain/usecases/get_pets_usecase.dart';
import 'package:myguard_frontend/features/pet/presentation/bloc/pet_cubit.dart';
import 'package:myguard_frontend/features/society/data/datasources/society_remote_datasource.dart';
import 'package:myguard_frontend/features/society/data/repositories/society_repository_impl.dart';
import 'package:myguard_frontend/features/society/domain/repositories/society_repository.dart';
import 'package:myguard_frontend/features/society/domain/usecases/get_societies_usecase.dart';
import 'package:myguard_frontend/features/society/presentation/bloc/society_bloc.dart';
import 'package:myguard_frontend/features/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'package:myguard_frontend/features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'package:myguard_frontend/features/vehicle/domain/repositories/vehicle_repository.dart';
import 'package:myguard_frontend/features/vehicle/domain/usecases/get_vehicles_usecase.dart';
import 'package:myguard_frontend/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:myguard_frontend/features/visitor/data/datasources/visitor_remote_datasource.dart';
import 'package:myguard_frontend/features/visitor/data/repositories/visitor_repository_impl.dart';
import 'package:myguard_frontend/features/visitor/domain/repositories/visitor_repository.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/approve_visitor_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/get_visitors_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/pre_approve_visitor_usecase.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Core Services
  sl.registerLazySingleton<AuthService>(AuthService.new);
  sl.registerLazySingleton<SecureStorageService>(SecureStorageService.new);
  sl.registerLazySingleton<PrefsService>(
    () => PrefsService(prefs: sl<SharedPreferences>()),
  );

  // Network
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(authService: sl<AuthService>()),
  );
  sl.registerLazySingleton<DioClient>(
    () => DioClient(authInterceptor: sl<AuthInterceptor>()),
  );

  // === AUTH ===
  sl
    ..registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDatasource: sl<AuthRemoteDatasource>(),
        authService: sl<AuthService>(),
      ),
    )
    ..registerLazySingleton(() => LoginUseCase(repository: sl<AuthRepository>()))
    ..registerLazySingleton(() => RegisterUseCase(repository: sl<AuthRepository>()))
    ..registerLazySingleton(() => GetProfileUseCase(repository: sl<AuthRepository>()))
    ..registerFactory(
      () => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
        getProfileUseCase: sl<GetProfileUseCase>(),
        authService: sl<AuthService>(),
        secureStorage: sl<SecureStorageService>(),
      ),
    );

  // === VISITOR ===
  sl
    ..registerLazySingleton<VisitorRemoteDatasource>(
      () => VisitorRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<VisitorRepository>(
      () => VisitorRepositoryImpl(remoteDatasource: sl<VisitorRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetVisitorsUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => PreApproveVisitorUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => ApproveVisitorUseCase(repository: sl<VisitorRepository>()))
    ..registerFactory(
      () => VisitorBloc(
        getVisitorsUseCase: sl<GetVisitorsUseCase>(),
        preApproveVisitorUseCase: sl<PreApproveVisitorUseCase>(),
        approveVisitorUseCase: sl<ApproveVisitorUseCase>(),
      ),
    );

  // === DAILY HELP ===
  sl
    ..registerLazySingleton<DailyHelpRemoteDatasource>(
      () => DailyHelpRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<DailyHelpRepository>(
      () => DailyHelpRepositoryImpl(remoteDatasource: sl<DailyHelpRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetDailyHelpsUseCase(repository: sl<DailyHelpRepository>()))
    ..registerLazySingleton(() => MarkAttendanceUseCase(repository: sl<DailyHelpRepository>()))
    ..registerFactory(
      () => DailyHelpCubit(
        getDailyHelpsUseCase: sl<GetDailyHelpsUseCase>(),
        markAttendanceUseCase: sl<MarkAttendanceUseCase>(),
      ),
    );

  // === GUARD ===
  sl
    ..registerLazySingleton<GuardRemoteDatasource>(
      () => GuardRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<GuardRepository>(
      () => GuardRepositoryImpl(remoteDatasource: sl<GuardRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetCheckpointsUseCase(repository: sl<GuardRepository>()))
    ..registerLazySingleton(() => LogPatrolUseCase(repository: sl<GuardRepository>()))
    ..registerFactory(
      () => PatrolCubit(
        getCheckpointsUseCase: sl<GetCheckpointsUseCase>(),
        logPatrolUseCase: sl<LogPatrolUseCase>(),
      ),
    );

  // === COMMUNICATION ===
  sl
    ..registerLazySingleton<CommunicationRemoteDatasource>(
      () => CommunicationRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<CommunicationRepository>(
      () => CommunicationRepositoryImpl(remoteDatasource: sl<CommunicationRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetNoticesUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => GetPollsUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => VotePollUseCase(repository: sl<CommunicationRepository>()))
    ..registerFactory(
      () => NoticeCubit(getNoticesUseCase: sl<GetNoticesUseCase>()),
    )
    ..registerFactory(
      () => PollBloc(
        getPollsUseCase: sl<GetPollsUseCase>(),
        votePollUseCase: sl<VotePollUseCase>(),
      ),
    );

  // === AMENITY ===
  sl
    ..registerLazySingleton<AmenityRemoteDatasource>(
      () => AmenityRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<AmenityRepository>(
      () => AmenityRepositoryImpl(remoteDatasource: sl<AmenityRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetAmenitiesUseCase(repository: sl<AmenityRepository>()))
    ..registerLazySingleton(() => GetAmenitySlotsUseCase(repository: sl<AmenityRepository>()))
    ..registerLazySingleton(() => BookAmenityUseCase(repository: sl<AmenityRepository>()))
    ..registerLazySingleton(() => GetMyBookingsUseCase(repository: sl<AmenityRepository>()))
    ..registerLazySingleton(() => CancelBookingUseCase(repository: sl<AmenityRepository>()))
    ..registerFactory(
      () => AmenityBloc(
        getAmenitiesUseCase: sl<GetAmenitiesUseCase>(),
        getAmenitySlotsUseCase: sl<GetAmenitySlotsUseCase>(),
        bookAmenityUseCase: sl<BookAmenityUseCase>(),
        getMyBookingsUseCase: sl<GetMyBookingsUseCase>(),
        cancelBookingUseCase: sl<CancelBookingUseCase>(),
      ),
    );

  // === HELPDESK ===
  sl
    ..registerLazySingleton<HelpdeskRemoteDatasource>(
      () => HelpdeskRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<HelpdeskRepository>(
      () => HelpdeskRepositoryImpl(remoteDatasource: sl<HelpdeskRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetTicketsUseCase(repository: sl<HelpdeskRepository>()))
    ..registerLazySingleton(() => CreateTicketUseCase(repository: sl<HelpdeskRepository>()))
    ..registerFactory(
      () => HelpdeskBloc(
        getTicketsUseCase: sl<GetTicketsUseCase>(),
        createTicketUseCase: sl<CreateTicketUseCase>(),
      ),
    );

  // === VEHICLE ===
  sl
    ..registerLazySingleton<VehicleRemoteDatasource>(
      () => VehicleRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(remoteDatasource: sl<VehicleRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetVehiclesUseCase(repository: sl<VehicleRepository>()))
    ..registerFactory(
      () => VehicleCubit(getVehiclesUseCase: sl<GetVehiclesUseCase>()),
    );

  // === MATERIAL GATEPASS ===
  sl
    ..registerLazySingleton<MaterialRemoteDatasource>(
      () => MaterialRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<MaterialRepository>(
      () => MaterialRepositoryImpl(remoteDatasource: sl<MaterialRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetGatepassesUseCase(repository: sl<MaterialRepository>()))
    ..registerFactory(
      () => MaterialCubit(getGatepassesUseCase: sl<GetGatepassesUseCase>()),
    );

  // === EMERGENCY ===
  sl
    ..registerLazySingleton<EmergencyRemoteDatasource>(
      () => EmergencyRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<EmergencyRepository>(
      () => EmergencyRepositoryImpl(remoteDatasource: sl<EmergencyRemoteDatasource>()),
    )
    ..registerLazySingleton(() => TriggerPanicUseCase(repository: sl<EmergencyRepository>()))
    ..registerLazySingleton(
      () => GetEmergencyContactsUseCase(repository: sl<EmergencyRepository>()),
    )
    ..registerFactory(
      () => EmergencyCubit(
        triggerPanicUseCase: sl<TriggerPanicUseCase>(),
        getEmergencyContactsUseCase: sl<GetEmergencyContactsUseCase>(),
      ),
    );

  // === PET ===
  sl
    ..registerLazySingleton<PetRemoteDatasource>(
      () => PetRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<PetRepository>(
      () => PetRepositoryImpl(remoteDatasource: sl<PetRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetPetsUseCase(repository: sl<PetRepository>()))
    ..registerFactory(
      () => PetCubit(getPetsUseCase: sl<GetPetsUseCase>()),
    );

  // === MARKETPLACE ===
  sl
    ..registerLazySingleton<MarketplaceRemoteDatasource>(
      () => MarketplaceRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<MarketplaceRepository>(
      () => MarketplaceRepositoryImpl(remoteDatasource: sl<MarketplaceRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetListingsUseCase(repository: sl<MarketplaceRepository>()))
    ..registerFactory(
      () => MarketplaceBloc(getListingsUseCase: sl<GetListingsUseCase>()),
    );

  // === SOCIETY ===
  sl
    ..registerLazySingleton<SocietyRemoteDatasource>(
      () => SocietyRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<SocietyRepository>(
      () => SocietyRepositoryImpl(remoteDatasource: sl<SocietyRemoteDatasource>()),
    )
    ..registerLazySingleton(() => GetSocietiesUseCase(repository: sl<SocietyRepository>()))
    ..registerFactory(
      () => SocietyBloc(getSocietiesUseCase: sl<GetSocietiesUseCase>()),
    );

  // === DASHBOARD ===
  sl
    ..registerLazySingleton<DashboardRemoteDatasource>(
      () => DashboardRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(remoteDatasource: sl<DashboardRemoteDatasource>()),
    )
    ..registerLazySingleton(
      () => GetDashboardSummaryUseCase(repository: sl<DashboardRepository>()),
    )
    ..registerFactory(
      () => DashboardCubit(
        getDashboardSummaryUseCase: sl<GetDashboardSummaryUseCase>(),
      ),
    );
}
