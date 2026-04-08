# App Registro de Atividades Físicas

Aplicativo Flutter para registro e acompanhamento de atividades físicas, com lista dinâmica, formulário de cadastro e navegação entre telas.

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
│   └── modelo_principal.dart          # Modelo de dados Atividade
└── screens/
    └── funcionalidades/
        ├── lista.dart                 # Tela principal com lista dinâmica
        └── formulario.dart            # Tela de cadastro/edição de atividade
```

## Modelo de dados

Cada atividade registrada contém:

| Campo | Tipo | Exemplo |
|---|---|---|
| Nome | texto | "Corrida no parque" |
| Tipo | seleção | Cardio, Musculação, Natação... |
| Duração | minutos | 45 |
| Calorias | kcal | 350 |
| Intensidade | seleção | Leve, Moderada, Intensa |
| Data | dd/mm/aaaa | 08/04/2026 |

## Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| Lista dinâmica | Exibe atividades em cards com ícone por tipo e badge de intensidade |
| Resumo no topo | Total de atividades, minutos e calorias acumulados |
| Cadastrar atividade | Formulário com validação abre via `Navigator.push()` |
| Editar atividade | Ícone de edição pré-preenche o formulário com os dados existentes |
| Remover atividade | Ícone de lixeira exclui o item da lista |
| Atualização automática | Lista atualiza via `setState()` ao retornar do formulário |

## Tema

O app utiliza **Material 3** (`useMaterial3: true`) com paleta laranja (`Colors.orange`). Para alterar a cor, edite o `seedColor` em `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
```
