import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import 'login_page.dart';
import '../widgets/clickable_text.dart';
import '../widgets/copyright_text.dart';
import '../widgets/auth_app_bar.dart';
import '../../presentation/blocs/auth_bloc.dart';
import '../../presentation/blocs/auth_event.dart';
import '../../presentation/blocs/auth_state.dart';

class CreateOrganizationPage extends StatefulWidget {
  const CreateOrganizationPage({super.key});
  static const String routeName = '/create-organization';

  @override
  State<CreateOrganizationPage> createState() => _CreateOrganizationPageState();
}

class _CreateOrganizationPageState extends State<CreateOrganizationPage> {
  late TextEditingController fullNameController;
  late TextEditingController organizationNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;

  String buildUsername() {
    final fullName = fullNameController.text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '');

    final organizationName = organizationNameController.text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '');

    return '$fullName@$organizationName';
  }

  void _showRegisterSuccessDialog(BuildContext context) {
    final username = buildUsername();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 56,
              ),
              const SizedBox(height: 16),
              const Text(
                'Registrasi Berhasil!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Simpan username Anda untuk login di kemudian hari.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: username));
                        SnackBarUtil.showSuccess(context, 'Username disalin');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacementNamed(
                        context, LoginPage.routeName);
                  },
                  child: const Text('Lanjut ke Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    organizationNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    organizationNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          _showRegisterSuccessDialog(context);
        } else if (state is AuthError) {
          SnackBarUtil.showError(context, state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AuthAppBar(title: 'FleetOps'),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: _inputCard(context, isLoading),
                  ),
                  CopyrightText(),
                ],
              ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buat Organisasi Anda',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            Text(
              'Daftarkan organisasi/perusahaan Anda untuk mengelola kendaraan.',
            ),
            SizedBox(height: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleLabel('Nama Lengkap', required: true),
                CustomTextField(
                  controller: fullNameController,
                  maxLines: 1,
                  hintText: 'Masukan Nama Lengkap',
                  prefixIcon: Icons.person_outline,
                  enabled: !isLoading,
                ),
                SizedBox(height: 8.0),
                titleLabel('Nama Organisasi', required: true),
                CustomTextField(
                  controller: organizationNameController,
                  maxLines: 1,
                  hintText: 'Masukan Nama Organisasi',
                  prefixIcon: Icons.business_rounded,
                  enabled: !isLoading,
                ),
                SizedBox(height: 8.0),
                titleLabel('Email', required: true),
                CustomTextField(
                  controller: emailController,
                  maxLines: 1,
                  hintText: 'Masukan Email',
                  prefixIcon: Icons.email_outlined,
                  enabled: !isLoading,
                  validator: AuthValidator.validateEmail,
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
                SizedBox(height: 8.0),
                titleLabel('Konfirmasi Kata Sandi', required: true),
                CustomTextField(
                  controller: passwordConfirmController,
                  maxLines: 1,
                  hintText: 'Konfirmasi Kata Sandi',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  enabled: !isLoading,
                ),
                SizedBox(height: 24.0),
                CustomButton(
                  text: isLoading ? 'Memproses...' : 'Daftar',
                  onPressed: isLoading
                      ? null
                      : () {
                          /// Validasi password match
                          if (passwordController.text !=
                              passwordConfirmController.text) {
                            SnackBarUtil.showError(
                              context,
                              'Kata sandi tidak cocok',
                            );
                            return;
                          }
                          context.read<AuthBloc>().add(
                                RegisterOrganizationEvent(
                                  organizationName:
                                      organizationNameController.text,
                                  fullName: fullNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                        },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?'),
                SizedBox(width: 4.0),
                ClickableText(
                  text: 'Masuk',
                  style: TextStyle(color: AppColors.primary),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
