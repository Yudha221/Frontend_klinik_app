import 'package:dartz/dartz.dart';
import 'package:klinik_app/core/constants/variables.dart';
import 'package:klinik_app/data/datasources/auth_local_datasource.dart';
import 'package:klinik_app/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final url = Uri.parse('${Variables.baseUrl}/api/login');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      await AuthLocalDataSource()
          .saveAuthData(AuthResponseModel.fromJson(response.body));  
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return const Left('Gagal Login');
    }
  }

  Future<Either<String, String>> logout() async {
    final authDataModel = await AuthLocalDataSource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/logout');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer ${authDataModel?.token}',
    });

    if (response.statusCode == 200) {
      return const Right('Logout Berhasil');
    } else {
      return const Left('Logout Gagal');
    }
  }
}
