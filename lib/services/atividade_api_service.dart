import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/modelo_principal.dart';

class AtividadeApiService {
  final http.Client _client;

  AtividadeApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Atividade>> listar() async {
    final response = await _client.get(Uri.parse(ApiConfig.atividadesEndpoint));

    if (response.statusCode != 200) {
      throw Exception('Erro ao listar atividades: ${response.statusCode}');
    }

    final List<dynamic> dados = jsonDecode(response.body) as List<dynamic>;
    return dados
        .map((item) => Atividade.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Atividade> cadastrar(Atividade atividade) async {
    final response = await _client.post(
      Uri.parse(ApiConfig.atividadesEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(atividade.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar atividade: ${response.statusCode}');
    }

    return Atividade.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Atividade> atualizar(Atividade atividade) async {
    if (atividade.id == null) {
      throw ArgumentError('Atividade precisa de id para atualização remota.');
    }

    final response = await _client.put(
      Uri.parse('${ApiConfig.atividadesEndpoint}/${atividade.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(atividade.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar atividade: ${response.statusCode}');
    }

    return Atividade.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deletar(int id) async {
    final response = await _client.delete(
      Uri.parse('${ApiConfig.atividadesEndpoint}/$id'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar atividade: ${response.statusCode}');
    }
  }
}
