import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../../../dashboard/presentation/pages/fleet_dashboard_page.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import '../pages/create_organization_page.dart';
import '../widgets/clickable_text.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/copyright_text.dart';

import '../../../navigation/presentation/pages/main_page.dart';
import '../../../dashboard/presentation/pages/admin_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          SnackBarUtil.showSuccess(context, 'Login berhasil');

          if (state.roleName == 'Admin') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AdminDashboardPage.routeName,
              (route) => false,
            );
          } else if (state.roleName == 'FleetManager') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              FleetDashboardPage.routeName,
              (route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainPage.routeName,
              (route) => false,
            );
          }
        } else if (state is AuthError) {
          SnackBarUtil.showError(context, state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AuthAppBar(title: 'FleetOps'),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 0.0,
                      ),
                      child: _inputCard(context, isLoading),
                    ),
                  ),
                ),
                CopyrightText(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _inputCard(BuildContext context, bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang Kembali',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Text('Masuk untuk melanjutkan'),
              SizedBox(height: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleLabel('Username', required: true),
                  CustomTextField(
                    controller: usernameController,
                    maxLines: 1,
                    hintText: 'Masukan Username',
                    prefixIcon: Icons.email_outlined,
                    enabled: !isLoading,
                  ),
                  SizedBox(height: 8.0),
                  titleLabel('Kata Sandi', required: true),
                  CustomTextField(
                    controller: passwordController,
                    maxLines: 1,
                    hintText: 'Masukan Kata Sandi',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    enabled: !isLoading,
                    validator: AuthValidator.validatePassword,
                  ),
                  SizedBox(height: 24.0),
                  CustomButton(
                    text: isLoading ? 'Memproses...' : 'Masuk',
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  identity: usernameController.text,
                                  password: passwordController.text,
                                ),
                              );
                            }
                          },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Belum punya akun?'),
                  SizedBox(width: 4.0),
                  ClickableText(
                    text: 'Daftar',
                    style: TextStyle(color: AppColors.primary),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        CreateOrganizationPage.routeName,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
