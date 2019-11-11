import 'package:http/http.dart' as http;
import 'package:search_cep/models/result_cep.dart';

class ViaCepService {
  static Future<ResultCep> fetchCep({String cep}) async {
    try {
      final response = await http.get('https://viacep.com.br/ws/$cep/json/');
      if (response.statusCode == 200) {
        return ResultCep.fromJson(response.body);
      } else {
        return ResultCep.fromJson(
            '{ "cep": "Verifique o CEP digitado!",  "logradouro": "Verifique o CEP digitado!",  "complemento": "Verifique o CEP digitado!",  "bairro": "Verifique o CEP digitado!",  "localidade": "Verifique o CEP digitado!",  "uf": "Verifique o CEP digitado!",  "unidade": "Verifique o CEP digitado!",  "ibge": "Verifique o CEP digitado!",  "gia": "Verifique o CEP digitado!" }');
      }
    } catch (error) {
      return ResultCep.fromJson(
          '{ "cep": "Sem internet !",  "logradouro": "Sem internet !",  "complemento": "Sem internet !",  "bairro": "Sem internet !",  "localidade": "Sem internet !",  "uf": "Sem internet !",  "unidade": "Sem internet !",  "ibge": "Sem internet !",  "gia": "Sem internet !" }');
    }
  }
}
