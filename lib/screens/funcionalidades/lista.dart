import 'package:flutter/material.dart';
import '../../models/modelo_principal.dart';
import 'formulario.dart';

class ListaAtividades extends StatefulWidget {
  const ListaAtividades({super.key});

  @override
  State<ListaAtividades> createState() => _ListaAtividadesState();
}

class _ListaAtividadesState extends State<ListaAtividades> {
  final List<Atividade> _atividades = [];

  int get _totalCalorias => _atividades.fold(0, (soma, a) => soma + a.calorias);
  int get _totalMinutos => _atividades.fold(0, (soma, a) => soma + a.duracaoMinutos);

  void _abrirFormulario({Atividade? atividadeParaEditar, int? indice}) async {
    final resultado = await Navigator.push<Atividade>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioAtividade(atividadeParaEditar: atividadeParaEditar),
      ),
    );

    if (resultado != null) {
      setState(() {
        if (indice != null) {
          _atividades[indice] = resultado;
        } else {
          _atividades.add(resultado);
        }
      });
    }
  }

  void _removerAtividade(int indice) {
    setState(() => _atividades.removeAt(indice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Atividades'),
        bottom: _atividades.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(36),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${_atividades.length} atividade(s) · $_totalMinutos min · $_totalCalorias kcal',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ),
      ),
      body: _atividades.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma atividade registrada.\nToque em + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _atividades.length,
              itemBuilder: (context, indice) {
                return ItemAtividade(
                  atividade: _atividades[indice],
                  onEditar: () => _abrirFormulario(
                    atividadeParaEditar: _atividades[indice],
                    indice: indice,
                  ),
                  onRemover: () => _removerAtividade(indice),
                );
              },
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
            Text('${atividade.tipo} · ${atividade.duracaoMinutos} min · ${atividade.calorias} kcal'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: corIntensidade.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: corIntensidade, width: 1),
                  ),
                  child: Text(
                    atividade.intensidade,
                    style: TextStyle(fontSize: 11, color: corIntensidade, fontWeight: FontWeight.w600),
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
