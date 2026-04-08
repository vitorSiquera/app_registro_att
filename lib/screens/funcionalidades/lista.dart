import 'package:flutter/material.dart';
import '../../models/modelo_principal.dart';
import 'formulario.dart';

class ListaPedidos extends StatefulWidget {
  const ListaPedidos({super.key});

  @override
  State<ListaPedidos> createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  final List<Pedido> _pedidos = [];

  void _abrirFormulario({Pedido? pedidoParaEditar, int? indice}) async {
    final resultado = await Navigator.push<Pedido>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioPedido(pedidoParaEditar: pedidoParaEditar),
      ),
    );

    if (resultado != null) {
      setState(() {
        if (indice != null) {
          _pedidos[indice] = resultado;
        } else {
          _pedidos.add(resultado);
        }
      });
    }
  }

  void _removerPedido(int indice) {
    setState(() {
      _pedidos.removeAt(indice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Pedidos'),
      ),
      body: _pedidos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum pedido registrado.\nToque em + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _pedidos.length,
              itemBuilder: (context, indice) {
                return ItemPedido(
                  pedido: _pedidos[indice],
                  onEditar: () => _abrirFormulario(pedidoParaEditar: _pedidos[indice], indice: indice),
                  onRemover: () => _removerPedido(indice),
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

class ItemPedido extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  const ItemPedido({
    super.key,
    required this.pedido,
    required this.onEditar,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.shopping_bag, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          pedido.descricao,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${pedido.categoria} · Qtd: ${pedido.quantidade} · R\$ ${pedido.valor.toStringAsFixed(2)}',
        ),
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
