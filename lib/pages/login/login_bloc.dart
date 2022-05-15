import 'dart:async';
import 'dart:convert' as convert;

import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/login/login_api.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';

import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/bloc.dart';

class LoginInput {
  String login;
  String senha;
  bool checkManterLogado = false;

  String toJson() {
    return convert.json.encode({
      "username": login,
      "password": senha,
    });
  }
}

class LoginBloc {
  final checkManterLogado = BooleanBloc();
  final progress = BooleanBloc();

  Future<ApiResponse<Usuario>> login(context, LoginInput loginInput) async {
    progress.set(true);

    ApiResponse<Usuario> response = await LoginApi.login(loginInput);

    if (response.ok) {
      Usuario user = response.result;


      if(loginInput.checkManterLogado) {
        // Somente salva nas prefs se marcou o checkbox
        user.save();
      }

      print("User API $user");

      // Salva no app model
      AppModel app = AppModel.get(context);
      app.setUser(user);
    }

    progress.set(false);

    return response;
  }

  void dispose() {
    progress.dispose();
    checkManterLogado.dispose();
  }
}
