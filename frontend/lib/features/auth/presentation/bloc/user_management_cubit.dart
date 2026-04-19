import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/domain/usecases/admin_user_usecases.dart';

// States
sealed class UserManagementState extends Equatable {
  const UserManagementState();
  @override
  List<Object?> get props => [];
}

class UserManagementInitial extends UserManagementState {
  const UserManagementInitial();
}

class UserManagementLoading extends UserManagementState {
  const UserManagementLoading();
}

class UsersLoaded extends UserManagementState {
  const UsersLoaded({
    required this.users,
    required this.hasMore,
    required this.page,
  });
  final List<UserEntity> users;
  final bool hasMore;
  final int page;

  @override
  List<Object> get props => [users, hasMore, page];
}

class UserDetailLoaded extends UserManagementState {
  const UserDetailLoaded(this.user);
  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class UserActionSuccess extends UserManagementState {
  const UserActionSuccess(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class UserManagementError extends UserManagementState {
  const UserManagementError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

// Cubit
class UserManagementCubit extends Cubit<UserManagementState> {
  UserManagementCubit({
    required GetUsersUseCase getUsersUseCase,
    required GetUserByIdUseCase getUserByIdUseCase,
    required ChangeUserRoleUseCase changeUserRoleUseCase,
    required ChangeUserStatusUseCase changeUserStatusUseCase,
  })  : _getUsersUseCase = getUsersUseCase,
        _getUserByIdUseCase = getUserByIdUseCase,
        _changeUserRoleUseCase = changeUserRoleUseCase,
        _changeUserStatusUseCase = changeUserStatusUseCase,
        super(const UserManagementInitial());

  final GetUsersUseCase _getUsersUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;
  final ChangeUserRoleUseCase _changeUserRoleUseCase;
  final ChangeUserStatusUseCase _changeUserStatusUseCase;

  final List<UserEntity> _users = [];

  Future<void> loadUsers({int page = 0, String? role}) async {
    if (page == 0) {
      _users.clear();
      emit(const UserManagementLoading());
    }
    final result = await _getUsersUseCase(page: page, role: role);
    if (result.isLeft()) {
      result.fold((f) => emit(UserManagementError(f.message)), (_) {});
      return;
    }
    final paginated = result.getOrElse(() => throw StateError('unreachable'));
    _users.addAll(paginated.content);
    emit(UsersLoaded(
      users: List.unmodifiable(_users),
      hasMore: paginated.hasNext,
      page: paginated.page,
    ));
  }

  Future<void> loadUserDetail(String uid) async {
    emit(const UserManagementLoading());
    final result = await _getUserByIdUseCase(uid);
    if (result.isLeft()) {
      result.fold((f) => emit(UserManagementError(f.message)), (_) {});
      return;
    }
    final user = result.getOrElse(() => throw StateError('unreachable'));
    emit(UserDetailLoaded(user));
  }

  Future<void> changeRole(String uid, String role) async {
    final result = await _changeUserRoleUseCase(uid, role);
    if (result.isLeft()) {
      result.fold((f) => emit(UserManagementError(f.message)), (_) {});
      return;
    }
    emit(const UserActionSuccess('Role updated successfully'));
  }

  Future<void> changeStatus(String uid, String status) async {
    final result = await _changeUserStatusUseCase(uid, status);
    if (result.isLeft()) {
      result.fold((f) => emit(UserManagementError(f.message)), (_) {});
      return;
    }
    emit(UserActionSuccess('User ${status == 'ACTIVE' ? 'activated' : 'deactivated'} successfully'));
  }
}
