import 'package:core/core.dart';

import '../models/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final HttpService httpService;

  UserRemoteDataSourceImpl({required this.httpService});

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await httpService.get(ApiConfig.adminGetAllUserEndpoint);

    final Map<String, dynamic> body = response is Map<String, dynamic>
        ? response
        : <String, dynamic>{};

    final List raw = body['users'] as List? ?? [];

    return raw
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
