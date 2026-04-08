class Atividade {
  final String nome;
  final String tipo;
  final int duracaoMinutos;
  final int calorias;
  final String intensidade;
  final String data;

  Atividade({
    required this.nome,
    required this.tipo,
    required this.duracaoMinutos,
    required this.calorias,
    required this.intensidade,
    required this.data,
  });

  @override
  String toString() {
    return 'Atividade{nome: $nome, tipo: $tipo, duracao: ${duracaoMinutos}min, calorias: $calorias kcal, intensidade: $intensidade, data: $data}';
  }
}
