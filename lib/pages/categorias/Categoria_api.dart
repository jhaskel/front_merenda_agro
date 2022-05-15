import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/utils/api_response.dart';
import 'package:merenda_escolar/utils/http_helper.dart' as http;


class CategoriaApi {



  static Future<List<Categoria>> get(context,) async {
    String url = "$BASE_URL/categorias";
    print("GET2 > $url");

    final response = await http.get(context, url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Categoria> favoritos = list.map<Categoria>((map) =>
        Categoria.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<List<Categoria>> getId(context,int id) async {
    String url = "$BASE_URL/categorias/id/$id";
    print("GET2 > $url");
    final response = await http.get(context,url);
    print("resp ${response.body}");
    String json = response.body;
    List list = convert.json.decode(json);
    List<Categoria> favoritos = list.map<Categoria>((map) =>
        Categoria.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }
  static Future<List<Categoria>> getAtivo(context) async {
    String url = "$BASE_URL/categorias/ativo";

    print("GET2 > $url");

    final response = await http.get(context, url);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Categoria> favoritos = list.map<Categoria>((map) =>
        Categoria.fromMap(map)).toList();
    print("jsonfaavo${json}");
    return favoritos;
  }

  static Future<ApiResponse<bool>> save(context, Categoria c) async {
    try {
      var url = "$BASE_URL/categorias";
      if (c.id != null) {
        url += "/${c.id}";
      }

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      print("POST > $url");

      String json = c.toJson();

      print("JSON > $json");


      var response = await (c.id == null
          ? http.post(context, url, body: json)
          : http.put(context, url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Categoria categoria = Categoria.fromMap(mapResponse);

        print("Categoria salvo: ${categoria.id}");

        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error(msg: "Não foi possível salvar o categoria");
    }
  }


  static Future<ApiResponse> delete(context, Categoria c) async {
    try {
      String url = "$BASE_URL/categoria/${c.id}";

      print("DELETE > $url");

      var response = await http.delete(context, url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        return ApiResponse.ok(msg: mapResponse["msg"]);
      }
    } catch (e) {
      print(e);
    }

    return ApiResponse.error(msg: "Não foi possível deletar o categoria");
  }



}
