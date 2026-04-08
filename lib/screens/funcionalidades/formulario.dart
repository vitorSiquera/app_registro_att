import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/modelo_principal.dart';

const _intensidades = ['Leve', 'Moderada', 'Intensa'];

const _tipos = [
  'Cardio',
  'Musculação',
  'Natação',
  'Ciclismo',
  'Yoga',
  'Artes Marciais',
  'Esporte Coletivo',
  'Outro',
];

class FormularioAtividade extends StatefulWidget {
  final Atividade? atividadeParaEditar;

  const FormularioAtividade({super.key, this.atividadeParaEditar});

  @override
  State<FormularioAtividade> createState() => _FormularioAtividadeState();
}

class _FormularioAtividadeState extends State<FormularioAtividade> {
  final _controladorNome = TextEditingController();
  final _controladorDuracao = TextEditingController();
  final _controladorCalorias = TextEditingController();
  final _controladorData = TextEditingController();
  String _tipoSelecionado = _tipos.first;
  String _intensidadeSelecionada = _intensidades.first;

  @override
  void initState() {
    super.initState();
    final a = widget.atividadeParaEditar;
    if (a != null) {
      _controladorNome.text = a.nome;
      _controladorDuracao.text = a.duracaoMinutos.toString();
      _controladorCalorias.text = a.calorias.toString();
      _controladorData.text = a.data;
      _tipoSelecionado = _tipos.contains(a.tipo) ? a.tipo : _tipos.first;
      _intensidadeSelecionada = _intensidades.contains(a.intensidade) ? a.intensidade : _intensidades.first;
    } else {
      final hoje = DateTime.now();
      _controladorData.text =
          '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}';
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorDuracao.dispose();
    _controladorCalorias.dispose();
    _controladorData.dispose();
    super.dispose();
  }

  void _salvar() {
    final nome = _controladorNome.text.trim();
    final duracao = int.tryParse(_controladorDuracao.text.trim());
    final calorias = int.tryParse(_controladorCalorias.text.trim());
    final data = _controladorData.text.trim();

    if (nome.isEmpty || duracao == null || calorias == null || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    final atividade = Atividade(
      nome: nome,
      tipo: _tipoSelecionado,
      duracaoMinutos: duracao,
      calorias: calorias,
      intensidade: _intensidadeSelecionada,
      data: data,
    );
    Navigator.pop(context, atividade);
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.atividadeParaEditar == null ? 'Nova Atividade' : 'Editar Atividade';

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Editor(
              controlador: _controladorNome,
              rotulo: 'Nome da atividade',
              dica: 'Ex: Corrida no parque',
              icone: Icons.fitness_center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                initialValue: _tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _tipos
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _tipoSelecionado = v!),
              ),
            ),
            Editor(
              controlador: _controladorDuracao,
              rotulo: 'Duração (minutos)',
              dica: '30',
              icone: Icons.timer_outlined,
              tipoTeclado: TextInputType.number,
            ),
            Editor(
              controlador: _controladorCalorias,
              rotulo: 'Calorias gastas (kcal)',
              dica: '200',
              icone: Icons.local_fire_department_outlined,
              tipoTeclado: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                initialValue: _intensidadeSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Intensidade',
                  prefixIcon: Icon(Icons.speed_outlined),
                ),
                items: _intensidades
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (v) => setState(() => _intensidadeSelecionada = v!),
              ),
            ),
            Editor(
              controlador: _controladorData,
              rotulo: 'Data (dd/mm/aaaa)',
              dica: '01/01/2025',
              icone: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
