import 'package:flutter/material.dart';

import '../../models/modelo_principal.dart';
import '../../repository/atividade_repository.dart';
import 'formulario.dart';

class ListaAtividades extends StatefulWidget {
  const ListaAtividades({super.key});

  @override
  State<ListaAtividades> createState() => _ListaAtividadesState();
}

class _ListaAtividadesState extends State<ListaAtividades> {
  final AtividadeRepository _repository = AtividadeRepository();
  List<Atividade> _atividades = [];
  bool _carregando = true;

  int get _totalCalorias =>
      _atividades.fold(0, (soma, a) => soma + a.calorias);
  int get _totalMinutos =>
      _atividades.fold(0, (soma, a) => soma + a.duracaoMinutos);

  @override
  void initState() {
    super.initState();
    _carregarAtividades();
  }

  Future<void> _carregarAtividades() async {
    setState(() => _carregando = true);
    try {
      final atividades = await _repository.listar();
      if (!mounted) return;
      setState(() {
        _atividades = atividades;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      _mostrarMensagem('Erro ao carregar atividades: $e', sucesso: false);
    }
  }

  void _mostrarMensagem(String mensagem, {required bool sucesso}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: sucesso ? Colors.green.shade700 : Colors.red.shade700,
      ),
    );
  }

  void _alterarFonteDados(FonteDados novaFonte) {
    if (_repository.fonteDados == novaFonte) return;
    setState(() => _repository.fonteDados = novaFonte);
    _carregarAtividades();
  }

  Future<void> _abrirFormulario({Atividade? atividadeParaEditar}) async {
    final resultado = await Navigator.push<Atividade>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FormularioAtividade(atividadeParaEditar: atividadeParaEditar),
      ),
    );

    if (resultado == null) return;

    try {
      await _repository.salvar(resultado);
      await _carregarAtividades();
      _mostrarMensagem(
        atividadeParaEditar == null
            ? 'Atividade cadastrada com sucesso!'
            : 'Atividade atualizada com sucesso!',
        sucesso: true,
      );
    } catch (e) {
      _mostrarMensagem('Erro ao salvar atividade: $e', sucesso: false);
    }
  }

  Future<void> _removerAtividade(Atividade atividade) async {
    if (atividade.id == null) return;

    try {
      await _repository.deletar(atividade.id!);
      await _carregarAtividades();
      _mostrarMensagem('Atividade removida com sucesso!', sucesso: true);
    } catch (e) {
      _mostrarMensagem('Erro ao remover atividade: $e', sucesso: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fonteLocal = _repository.fonteDados == FonteDados.local;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Atividades'),
        actions: [
          PopupMenuButton<FonteDados>(
            icon: Icon(fonteLocal ? Icons.storage : Icons.cloud),
            tooltip: 'Fonte de dados',
            onSelected: _alterarFonteDados,
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: FonteDados.local,
                checked: fonteLocal,
                child: const Text('SQLite (local)'),
              ),
              CheckedPopupMenuItem(
                value: FonteDados.remota,
                checked: !fonteLocal,
                child: const Text('API (remota)'),
              ),
            ],
          ),
        ],
        bottom: _atividades.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(36),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${_atividades.length} atividade(s) · $_totalMinutos min · $_totalCalorias kcal · ${fonteLocal ? 'Local' : 'Remota'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _atividades.isEmpty
              ? Center(
                  child: Text(
                    'Nenhuma atividade registrada.\nToque em + para adicionar.\nFonte: ${fonteLocal ? 'SQLite local' : 'API remota'}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarAtividades,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _atividades.length,
                    itemBuilder: (context, indice) {
                      final atividade = _atividades[indice];
                      return ItemAtividade(
                        atividade: atividade,
                        onEditar: () =>
                            _abrirFormulario(atividadeParaEditar: atividade),
                        onRemover: () => _removerAtividade(atividade),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ItemAtividade extends StatelessWidget {
  final Atividade atividade;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  const ItemAtividade({
    super.key,
    required this.atividade,
    required this.onEditar,
    required this.onRemover,
  });

  Color _corIntensidade(BuildContext context) {
    return switch (atividade.intensidade) {
      'Leve' => Colors.green.shade600,
      'Moderada' => Colors.orange.shade700,
      'Intensa' => Colors.red.shade600,
      _ => Theme.of(context).colorScheme.primary,
    };
  }

  IconData _iconeTipo() {
    return switch (atividade.tipo) {
      'Cardio' => Icons.directions_run,
      'Musculação' => Icons.fitness_center,
      'Natação' => Icons.pool,
      'Ciclismo' => Icons.directions_bike,
      'Yoga' => Icons.self_improvement,
      'Artes Marciais' => Icons.sports_martial_arts,
      'Esporte Coletivo' => Icons.sports_soccer,
      _ => Icons.sports,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final corIntensidade = _corIntensidade(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(_iconeTipo(), color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          atividade.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${atividade.tipo} · ${atividade.duracaoMinutos} min · ${atividade.calorias} kcal',
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: corIntensidade.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: corIntensidade, width: 1),
                  ),
                  child: Text(
                    atividade.intensidade,
                    style: TextStyle(
                      fontSize: 11,
                      color: corIntensidade,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  atividade.data,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEditar,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemover,
              tooltip: 'Remover',
            ),
          ],
        ),
      ),
    );
  }
}
