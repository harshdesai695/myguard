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
import 'package:myguard_frontend/features/auth/domain/usecases/admin_user_usecases.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/user_management_cubit.dart';
import 'package:myguard_frontend/features/communication/data/datasources/communication_remote_datasource.dart';
import 'package:myguard_frontend/features/communication/data/repositories/communication_repository_impl.dart';
import 'package:myguard_frontend/features/communication/domain/repositories/communication_repository.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/get_notices_usecase.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/get_polls_usecase.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/vote_poll_usecase.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/communication_usecases.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/notice_cubit.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/poll_bloc.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/community_group_cubit.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/document_cubit.dart';
import 'package:myguard_frontend/features/dailyhelp/data/datasources/dailyhelp_remote_datasource.dart';
import 'package:myguard_frontend/features/dailyhelp/data/repositories/dailyhelp_repository_impl.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/repositories/dailyhelp_repository.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/usecases/get_daily_helps_usecase.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/usecases/mark_attendance_usecase.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/usecases/dailyhelp_usecases.dart';
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
import 'package:myguard_frontend/features/emergency/domain/usecases/emergency_usecases.dart';
import 'package:myguard_frontend/features/emergency/presentation/bloc/emergency_cubit.dart';
import 'package:myguard_frontend/features/guard/data/datasources/guard_remote_datasource.dart';
import 'package:myguard_frontend/features/guard/data/repositories/guard_repository_impl.dart';
import 'package:myguard_frontend/features/guard/domain/repositories/guard_repository.dart';
import 'package:myguard_frontend/features/guard/domain/usecases/get_checkpoints_usecase.dart';
import 'package:myguard_frontend/features/guard/domain/usecases/log_patrol_usecase.dart';
import 'package:myguard_frontend/features/guard/domain/usecases/guard_usecases.dart';
import 'package:myguard_frontend/features/guard/presentation/bloc/patrol_cubit.dart';
import 'package:myguard_frontend/features/helpdesk/data/datasources/helpdesk_remote_datasource.dart';
import 'package:myguard_frontend/features/helpdesk/data/repositories/helpdesk_repository_impl.dart';
import 'package:myguard_frontend/features/helpdesk/domain/repositories/helpdesk_repository.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/create_ticket_usecase.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/get_tickets_usecase.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/helpdesk_usecases.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/helpdesk_admin_usecases.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/bloc/helpdesk_bloc.dart';
import 'package:myguard_frontend/features/marketplace/data/datasources/marketplace_remote_datasource.dart';
import 'package:myguard_frontend/features/marketplace/data/repositories/marketplace_repository_impl.dart';
import 'package:myguard_frontend/features/marketplace/domain/repositories/marketplace_repository.dart';
import 'package:myguard_frontend/features/marketplace/domain/usecases/get_listings_usecase.dart';
import 'package:myguard_frontend/features/marketplace/domain/usecases/marketplace_usecases.dart';
import 'package:myguard_frontend/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:myguard_frontend/features/material/data/datasources/material_remote_datasource.dart';
import 'package:myguard_frontend/features/material/data/repositories/material_repository_impl.dart';
import 'package:myguard_frontend/features/material/domain/repositories/material_repository.dart';
import 'package:myguard_frontend/features/material/domain/usecases/get_gatepasses_usecase.dart';
import 'package:myguard_frontend/features/material/domain/usecases/material_usecases.dart';
import 'package:myguard_frontend/features/material/presentation/bloc/material_cubit.dart';
import 'package:myguard_frontend/features/pet/data/datasources/pet_remote_datasource.dart';
import 'package:myguard_frontend/features/pet/data/repositories/pet_repository_impl.dart';
import 'package:myguard_frontend/features/pet/domain/repositories/pet_repository.dart';
import 'package:myguard_frontend/features/pet/domain/usecases/get_pets_usecase.dart';
import 'package:myguard_frontend/features/pet/domain/usecases/pet_usecases.dart';
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
import 'package:myguard_frontend/features/vehicle/domain/usecases/vehicle_usecases.dart';
import 'package:myguard_frontend/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:myguard_frontend/features/visitor/data/datasources/visitor_remote_datasource.dart';
import 'package:myguard_frontend/features/visitor/data/repositories/visitor_repository_impl.dart';
import 'package:myguard_frontend/features/visitor/domain/repositories/visitor_repository.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/approve_visitor_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/get_visitors_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/pre_approve_visitor_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/visitor_usecases.dart';
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
    ..registerLazySingleton(() => GetUsersUseCase(repository: sl<AuthRepository>()))
    ..registerLazySingleton(() => GetUserByIdUseCase(repository: sl<AuthRepository>()))
    ..registerLazySingleton(() => ChangeUserRoleUseCase(repository: sl<AuthRepository>()))
    ..registerLazySingleton(() => ChangeUserStatusUseCase(repository: sl<AuthRepository>()))
    ..registerFactory(
      () => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
        getProfileUseCase: sl<GetProfileUseCase>(),
        authService: sl<AuthService>(),
        secureStorage: sl<SecureStorageService>(),
      ),
    )
    ..registerFactory(
      () => UserManagementCubit(
        getUsersUseCase: sl<GetUsersUseCase>(),
        getUserByIdUseCase: sl<GetUserByIdUseCase>(),
        changeUserRoleUseCase: sl<ChangeUserRoleUseCase>(),
        changeUserStatusUseCase: sl<ChangeUserStatusUseCase>(),
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
    ..registerLazySingleton(() => RejectVisitorUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => LogVisitorEntryUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => MarkVisitorExitUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => GetPreApprovalsUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => DeletePreApprovalUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => CreateGuestInviteUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => VerifyVisitorCodeUseCase(repository: sl<VisitorRepository>()))
    ..registerLazySingleton(() => GetVisitorByIdUseCase(repository: sl<VisitorRepository>()))
    ..registerFactory(
      () => VisitorBloc(
        getVisitorsUseCase: sl<GetVisitorsUseCase>(),
        preApproveVisitorUseCase: sl<PreApproveVisitorUseCase>(),
        approveVisitorUseCase: sl<ApproveVisitorUseCase>(),
        rejectVisitorUseCase: sl<RejectVisitorUseCase>(),
        logVisitorEntryUseCase: sl<LogVisitorEntryUseCase>(),
        markVisitorExitUseCase: sl<MarkVisitorExitUseCase>(),
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
    ..registerLazySingleton(() => CreateDailyHelpUseCase(repository: sl<DailyHelpRepository>()))
    ..registerLazySingleton(() => UpdateDailyHelpUseCase(repository: sl<DailyHelpRepository>()))
    ..registerLazySingleton(() => DeleteDailyHelpUseCase(repository: sl<DailyHelpRepository>()))
    ..registerFactory(
      () => DailyHelpCubit(
        getDailyHelpsUseCase: sl<GetDailyHelpsUseCase>(),
        markAttendanceUseCase: sl<MarkAttendanceUseCase>(),
        createDailyHelpUseCase: sl<CreateDailyHelpUseCase>(),
        updateDailyHelpUseCase: sl<UpdateDailyHelpUseCase>(),
        deleteDailyHelpUseCase: sl<DeleteDailyHelpUseCase>(),
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
    ..registerLazySingleton(() => GetShiftsUseCase(repository: sl<GuardRepository>()))
    ..registerLazySingleton(() => CreateShiftUseCase(repository: sl<GuardRepository>()))
    ..registerLazySingleton(() => SendIntercomUseCase(repository: sl<GuardRepository>()))
    ..registerLazySingleton(() => GetPatrolsUseCase(repository: sl<GuardRepository>()))
    ..registerFactory(
      () => PatrolCubit(
        getCheckpointsUseCase: sl<GetCheckpointsUseCase>(),
        logPatrolUseCase: sl<LogPatrolUseCase>(),
        getShiftsUseCase: sl<GetShiftsUseCase>(),
        createShiftUseCase: sl<CreateShiftUseCase>(),
        sendIntercomUseCase: sl<SendIntercomUseCase>(),
        getPatrolsUseCase: sl<GetPatrolsUseCase>(),
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
    ..registerLazySingleton(() => CreateNoticeUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => DeleteNoticeUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => CreatePollUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => GetGroupsUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => GetMessagesUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => SendMessageUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => GetDocumentsUseCase(repository: sl<CommunicationRepository>()))
    ..registerLazySingleton(() => UploadDocumentUseCase(repository: sl<CommunicationRepository>()))
    ..registerFactory(
      () => NoticeCubit(
        getNoticesUseCase: sl<GetNoticesUseCase>(),
        repository: sl<CommunicationRepository>(),
      ),
    )
    ..registerFactory(
      () => PollBloc(
        getPollsUseCase: sl<GetPollsUseCase>(),
        votePollUseCase: sl<VotePollUseCase>(),
      ),
    )
    ..registerFactory(
      () => CommunityGroupCubit(
        getGroupsUseCase: sl<GetGroupsUseCase>(),
        getMessagesUseCase: sl<GetMessagesUseCase>(),
        sendMessageUseCase: sl<SendMessageUseCase>(),
      ),
    )
    ..registerFactory(
      () => DocumentCubit(
        getDocumentsUseCase: sl<GetDocumentsUseCase>(),
        uploadDocumentUseCase: sl<UploadDocumentUseCase>(),
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
        repository: sl<AmenityRepository>(),
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
    ..registerLazySingleton(() => AddCommentUseCase(repository: sl<HelpdeskRepository>()))
    ..registerLazySingleton(() => RateTicketUseCase(repository: sl<HelpdeskRepository>()))
    ..registerLazySingleton(() => UpdateTicketStatusUseCase(repository: sl<HelpdeskRepository>()))
    ..registerLazySingleton(() => GetTicketByIdUseCase(repository: sl<HelpdeskRepository>()))
    ..registerFactory(
      () => HelpdeskBloc(
        getTicketsUseCase: sl<GetTicketsUseCase>(),
        createTicketUseCase: sl<CreateTicketUseCase>(),
        addCommentUseCase: sl<AddCommentUseCase>(),
        rateTicketUseCase: sl<RateTicketUseCase>(),
        updateTicketStatusUseCase: sl<UpdateTicketStatusUseCase>(),
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
    ..registerLazySingleton(() => RegisterVehicleUseCase(repository: sl<VehicleRepository>()))
    ..registerLazySingleton(() => UpdateVehicleUseCase(repository: sl<VehicleRepository>()))
    ..registerLazySingleton(() => DeleteVehicleUseCase(repository: sl<VehicleRepository>()))
    ..registerLazySingleton(() => LookupVehicleUseCase(repository: sl<VehicleRepository>()))
    ..registerFactory(
      () => VehicleCubit(
        getVehiclesUseCase: sl<GetVehiclesUseCase>(),
        registerVehicleUseCase: sl<RegisterVehicleUseCase>(),
        updateVehicleUseCase: sl<UpdateVehicleUseCase>(),
        deleteVehicleUseCase: sl<DeleteVehicleUseCase>(),
        lookupVehicleUseCase: sl<LookupVehicleUseCase>(),
      ),
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
    ..registerLazySingleton(() => CreateGatepassUseCase(repository: sl<MaterialRepository>()))
    ..registerLazySingleton(() => ApproveGatepassUseCase(repository: sl<MaterialRepository>()))
    ..registerLazySingleton(() => VerifyGatepassUseCase(repository: sl<MaterialRepository>()))
    ..registerFactory(
      () => MaterialCubit(
        getGatepassesUseCase: sl<GetGatepassesUseCase>(),
        createGatepassUseCase: sl<CreateGatepassUseCase>(),
        approveGatepassUseCase: sl<ApproveGatepassUseCase>(),
        verifyGatepassUseCase: sl<VerifyGatepassUseCase>(),
        repository: sl<MaterialRepository>(),
      ),
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
    ..registerLazySingleton(() => GetPanicAlertsUseCase(repository: sl<EmergencyRepository>()))
    ..registerLazySingleton(() => ResolvePanicUseCase(repository: sl<EmergencyRepository>()))
    ..registerLazySingleton(() => CreateEmergencyContactUseCase(repository: sl<EmergencyRepository>()))
    ..registerLazySingleton(() => UpdateEmergencyContactUseCase(repository: sl<EmergencyRepository>()))
    ..registerLazySingleton(() => DeleteEmergencyContactUseCase(repository: sl<EmergencyRepository>()))
    ..registerFactory(
      () => EmergencyCubit(
        triggerPanicUseCase: sl<TriggerPanicUseCase>(),
        getEmergencyContactsUseCase: sl<GetEmergencyContactsUseCase>(),
        getPanicAlertsUseCase: sl<GetPanicAlertsUseCase>(),
        resolvePanicUseCase: sl<ResolvePanicUseCase>(),
        createEmergencyContactUseCase: sl<CreateEmergencyContactUseCase>(),
        updateEmergencyContactUseCase: sl<UpdateEmergencyContactUseCase>(),
        deleteEmergencyContactUseCase: sl<DeleteEmergencyContactUseCase>(),
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
    ..registerLazySingleton(() => RegisterPetUseCase(repository: sl<PetRepository>()))
    ..registerLazySingleton(() => UpdatePetUseCase(repository: sl<PetRepository>()))
    ..registerLazySingleton(() => DeletePetUseCase(repository: sl<PetRepository>()))
    ..registerLazySingleton(() => AddVaccinationUseCase(repository: sl<PetRepository>()))
    ..registerLazySingleton(() => GetVaccinationsUseCase(repository: sl<PetRepository>()))
    ..registerFactory(
      () => PetCubit(
        getPetsUseCase: sl<GetPetsUseCase>(),
        registerPetUseCase: sl<RegisterPetUseCase>(),
        updatePetUseCase: sl<UpdatePetUseCase>(),
        deletePetUseCase: sl<DeletePetUseCase>(),
        addVaccinationUseCase: sl<AddVaccinationUseCase>(),
        getVaccinationsUseCase: sl<GetVaccinationsUseCase>(),
      ),
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
    ..registerLazySingleton(() => CreateListingUseCase(repository: sl<MarketplaceRepository>()))
    ..registerLazySingleton(() => UpdateListingUseCase(repository: sl<MarketplaceRepository>()))
    ..registerLazySingleton(() => DeleteListingUseCase(repository: sl<MarketplaceRepository>()))
    ..registerLazySingleton(() => MarkSoldUseCase(repository: sl<MarketplaceRepository>()))
    ..registerLazySingleton(() => ExpressInterestUseCase(repository: sl<MarketplaceRepository>()))
    ..registerFactory(
      () => MarketplaceBloc(
        getListingsUseCase: sl<GetListingsUseCase>(),
        createListingUseCase: sl<CreateListingUseCase>(),
        updateListingUseCase: sl<UpdateListingUseCase>(),
        deleteListingUseCase: sl<DeleteListingUseCase>(),
        markSoldUseCase: sl<MarkSoldUseCase>(),
        expressInterestUseCase: sl<ExpressInterestUseCase>(),
      ),
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
      () => SocietyBloc(
        getSocietiesUseCase: sl<GetSocietiesUseCase>(),
        repository: sl<SocietyRepository>(),
      ),
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
