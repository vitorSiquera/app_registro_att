import '../db/database_helper.dart';
import '../models/modelo_principal.dart';
import '../services/atividade_api_service.dart';

enum FonteDados { local, remota }

class AtividadeRepository {
  final DatabaseHelper _databaseHelper;
  final AtividadeApiService _apiService;
  FonteDados fonteDados;

  AtividadeRepository({
    DatabaseHelper? databaseHelper,
    AtividadeApiService? apiService,
    this.fonteDados = FonteDados.local,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper(),
        _apiService = apiService ?? AtividadeApiService();

  Future<List<Atividade>> listar() async {
    if (fonteDados == FonteDados.local) {
      return _databaseHelper.listar();
    }
    return _apiService.listar();
  }

  Future<Atividade> salvar(Atividade atividade) async {
    if (fonteDados == FonteDados.local) {
      if (atividade.id == null) {
        return _databaseHelper.inserir(atividade);
      }
      return _databaseHelper.atualizar(atividade);
    }

    if (atividade.id == null) {
      return _apiService.cadastrar(atividade);
    }
    return _apiService.atualizar(atividade);
  }

  Future<void> deletar(int id) async {
    if (fonteDados == FonteDados.local) {
      await _databaseHelper.deletar(id);
      return;
    }
    await _apiService.deletar(id);
  }
}
