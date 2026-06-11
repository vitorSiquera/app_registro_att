class Atividade {
  final int? id;
  final String nome;
  final String tipo;
  final int duracaoMinutos;
  final int calorias;
  final String intensidade;
  final String data;

  Atividade({
    this.id,
    required this.nome,
    required this.tipo,
    required this.duracaoMinutos,
    required this.calorias,
    required this.intensidade,
    required this.data,
  });

  Atividade copyWith({
    int? id,
    String? nome,
    String? tipo,
    int? duracaoMinutos,
    int? calorias,
    String? intensidade,
    String? data,
  }) {
    return Atividade(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      duracaoMinutos: duracaoMinutos ?? this.duracaoMinutos,
      calorias: calorias ?? this.calorias,
      intensidade: intensidade ?? this.intensidade,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'duracao_minutos': duracaoMinutos,
      'calorias': calorias,
      'intensidade': intensidade,
      'data': data,
    };
  }

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      tipo: map['tipo'] as String,
      duracaoMinutos: map['duracao_minutos'] as int,
      calorias: map['calorias'] as int,
      intensidade: map['intensidade'] as String,
      data: map['data'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'tipo': tipo,
      'duracao_minutos': duracaoMinutos,
      'calorias': calorias,
      'intensidade': intensidade,
      'data': data,
    };
  }

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      duracaoMinutos: json['duracao_minutos'] as int,
      calorias: json['calorias'] as int,
      intensidade: json['intensidade'] as String,
      data: json['data'] as String,
    );
  }

  @override
  String toString() {
    return 'Atividade{id: $id, nome: $nome, tipo: $tipo, duracao: ${duracaoMinutos}min, calorias: $calorias kcal, intensidade: $intensidade, data: $data}';
  }
}
