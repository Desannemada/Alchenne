/*
* Operações de integração com WS (API)
*/

import 'package:alchemy/core/services/api.dart';

class CustomAPI extends API {
  static CustomAPI _api;

  CustomAPI();

  static CustomAPI instance() {
    if (_api == null) {
      _api = CustomAPI();
    }

    return _api;
  }

  // Get all brands from WS
  // Future<dynamic> getIngredientsFromJson() async {
  //   try {
  //     var response = await client.get("$BASE_URL/ingredientes");
  //     if (response.statusCode == 200) {
  //       print(response.body == AllInfo().ingredientes.toString());
  //       print("RESPONSE: " + response.body + "\n");
  //       // print(AllInfo().ingredientes.toString());
  //       return ingredientesFromJson(response.body);
  //     } else {
  //       return response.statusCode;
  //     }
  //   } catch (exception, _) {
  //     return 400;
  //   }
  // }

  // Future<dynamic> getEffectsFromJson() async {
  //   try {
  //     var response = await client.get("$BASE_URL/efeitos");
  //     if (response.statusCode == 200) {
  //       return efeitosFromJson(response.body);
  //     } else {
  //       return response.statusCode;
  //     }
  //   } catch (exception, _) {
  //     return 400;
  //   }
  // }

  // Future<dynamic> getURLFromJson(String url) async {
  //   try {
  //     var response = await client.post(
  //       "$BASE_URL/ingredienteInfo",
  //       headers: {"Content-Type": "application/json"},
  //       body: urlToJson(Url(url: url)),
  //       encoding: Encoding.getByName("UTF-8"),
  //     );
  //     if (response.statusCode == 200) {
  //       return ingredienteInfoFromJson(response.body);
  //     } else {
  //       return response.statusCode;
  //     }
  //   } catch (exception, _) {
  //     return 400;
  //   }
  // }

  // Future<dynamic> getURL2FromJson(String url) async {
  //   try {
  //     var response = await client.post(
  //       "$BASE_URL/efeitoInfo",
  //       headers: {"Content-Type": "application/json"},
  //       body: urlToJson(Url(url: url)),
  //       encoding: Encoding.getByName("UTF-8"),
  //     );
  //     if (response.statusCode == 200) {
  //       return efeitoInfoFromJson(response.body);
  //     } else {
  //       return response.statusCode;
  //     }
  //   } catch (exception, _) {
  //     return 400;
  //   }
  // }
}
