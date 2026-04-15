import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/core/firebase/auth_service.dart';
import 'package:myguard_frontend/core/storage/secure_storage_service.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:myguard_frontend/features/auth/domain/usecases/login_usecase.dart';
import 'package:myguard_frontend/features/auth/domain/usecases/register_usecase.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GetProfileUseCase getProfileUseCase,
    required AuthService authService,
    required SecureStorageService secureStorage,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _getProfileUseCase = getProfileUseCase,
        _authService = authService,
        _secureStorage = secureStorage,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final AuthService _authService;
  final SecureStorageService _secureStorage;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    if (!_authService.isAuthenticated) {
      emit(const AuthUnauthenticated());
      return;
    }

    final result = await _getProfileUseCase();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (UserEntity user) async {
        await _secureStorage.saveUserRole(user.role);
        if (user.societyId != null) {
          await _secureStorage.saveSocietyId(user.societyId!);
        }
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (UserEntity user) async {
        await _secureStorage.saveUserRole(user.role);
        if (user.societyId != null) {
          await _secureStorage.saveSocietyId(user.societyId!);
        }
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _registerUseCase(
      name: event.name,
      email: event.email,
      phone: event.phone,
      password: event.password,
      role: event.role,
      societyId: event.societyId,
      flatNumber: event.flatNumber,
      flatId: event.flatId,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (UserEntity user) async {
        await _secureStorage.saveUserRole(user.role);
        if (user.societyId != null) {
          await _secureStorage.saveSocietyId(user.societyId!);
        }
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.signOut();
    await _secureStorage.clearAll();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authService.sendPasswordResetEmail(email: event.email);
      emit(const AuthPasswordResetSent());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
