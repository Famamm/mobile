import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final TokenService tokenService;
  final HttpService httpService;

  AuthBloc(
      {required this.repository,
      required this.tokenService,
      required this.httpService})
      : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterOrganizationEvent>(_onRegisterOrganization);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<LogoutEvent>(_onLogout);
    on<LogoutAllDevicesEvent>(_onLogoutAllDevices);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final response = await repository.login(event.identity, event.password);

      await tokenService.saveToken(
        response.accessToken,
        response.user.email,
        response.user.fullName,
        refreshToken: response.refreshToken,
        driverId: response.user.driverId,
        organizationId: response.user.organizationId,
        roleName: response.user.roleName,
      );
      HttpService.setToken(response.accessToken);
      httpService.updateToken(response.accessToken);

      emit(
        AuthSuccess(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          fullName: response.user.fullName,
          email: response.user.email,
          roleName: response.user.roleName,
          driverId: response.user.driverId,
          organizationId: response.user.organizationId,
        ),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterOrganization(
    RegisterOrganizationEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      await repository.registerOrganization(
        event.organizationName,
        event.fullName,
        event.email,
        event.password,
      );

      emit(RegisterSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await repository.refreshToken(event.refreshToken);

      await tokenService.saveToken(
        response.accessToken,
        response.user.email,
        response.user.fullName,
        refreshToken: response.refreshToken,
        driverId: response.user.driverId,
        organizationId: response.user.organizationId,
        roleName: response.user.roleName,
      );
      HttpService.setToken(response.accessToken);

      emit(
        AuthSuccess(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          fullName: response.user.fullName,
          email: response.user.email,
          roleName: response.user.roleName,
          driverId: response.user.driverId,
          organizationId: response.user.organizationId,
        ),
      );
    } catch (e) {
      emit(AuthError(message: 'Failed to refresh token: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await repository.logout(event.refreshToken);
      await tokenService.clearToken();
      HttpService.setToken(null);
      emit(AuthInitial());
    } catch (e) {
      await tokenService.clearToken();
      HttpService.setToken(null);
      emit(AuthInitial());
    }
  }

  Future<void> _onLogoutAllDevices(
    LogoutAllDevicesEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.logoutAllDevices();
      await tokenService.clearToken();
      HttpService.setToken(null);
      emit(AuthInitial());
    } catch (e) {
      await tokenService.clearToken();
      HttpService.setToken(null);
      emit(AuthInitial());
    }
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = tokenService.getToken();
      if (token != null) {
        final email = tokenService.getUserEmail() ?? '';
        final fullName = tokenService.getUserName() ?? '';
        final refreshToken = tokenService.getRefreshToken() ?? '';
        final driverId = tokenService.getDriverId();
        final organizationId = tokenService.getOrganizationId();
        final roleName = tokenService.getRoleName() ?? 'driver';

        HttpService.setToken(token);
        emit(
          AuthSuccess(
            accessToken: token,
            refreshToken: refreshToken,
            fullName: fullName,
            email: email,
            roleName: roleName,
            driverId: driverId,
            organizationId: organizationId,
          ),
        );
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
