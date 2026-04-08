# App Registro de Pedidos

Aplicativo Flutter para registro e exibição de pedidos, desenvolvido com lista dinâmica, formulário de cadastro e navegação entre telas.

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x ou superior
- [Android Studio](https://developer.android.com/studio) com emulador configurado, **ou** dispositivo físico Android com USB debugging ativo
- Dart SDK (incluído no Flutter)

## Setup

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd app_registro_att
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Verifique o ambiente

```bash
flutter doctor
```

Todos os itens devem aparecer com `[✓]`.

## Executando o app

### Emulador Android (Android Studio)

```bash
# Listar emuladores disponíveis
flutter emulators

# Iniciar o emulador (ex: Pixel_9a)
flutter emulators --launch Pixel_9a

# Rodar o app
flutter run
```

### Windows Desktop

```bash
flutter run -d windows
```

### Chrome (Web)

```bash
flutter run -d chrome
```

## Estrutura do projeto

```
lib/
├── main.dart                          # Ponto de entrada e configuração de tema
├── components/
│   └── editor.dart                    # Componente reutilizável de campo de texto
├── models/
│   └── modelo_principal.dart          # Modelo de dados Pedido
└── screens/
    └── funcionalidades/
        ├── lista.dart                 # Tela principal com lista dinâmica
        └── formulario.dart            # Tela de cadastro/edição de pedido
```

## Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| Lista dinâmica | Exibe pedidos em cards com descrição, categoria, quantidade e valor |
| Cadastrar pedido | Formulário com validação abre via `Navigator.push()` |
| Editar pedido | Toca no ícone de edição para pré-preencher o formulário |
| Remover pedido | Toca no ícone de lixeira para excluir o item da lista |
| Atualização automática | A lista atualiza via `setState()` após retorno do formulário |

## Tema

O app utiliza **Material 3** (`useMaterial3: true`) com paleta roxa (`Colors.deepPurple`). Para alterar a cor, edite o `seedColor` em `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
```
