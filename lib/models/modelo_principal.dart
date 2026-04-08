class Pedido {
  final String descricao;
  final int quantidade;
  final double valor;
  final String categoria;

  Pedido(this.descricao, this.quantidade, this.valor, this.categoria);

  @override
  String toString() {
    return 'Pedido{descricao: $descricao, quantidade: $quantidade, valor: $valor, categoria: $categoria}';
  }
}
