# App Registro de Atividades Físicas

Aplicativo Flutter para registro e acompanhamento de atividades físicas, com persistência local (SQLite) e remota (API + PostgreSQL no Render).

## Identificação do projeto

```
Nome da temática do aplicativo: Registro de Atividades Físicas
Integrante 1: Hugo de Castro Rodrigues
Integrante 2 (se houver): Pablo Miguel Sousa Nóbrega
Integrante 3 (se houver): Vitor Siqueira Simeão
```

> Se o repositório for privado, adicione o professor: `@adrianoprof`

---

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x ou superior
- [Android Studio](https://developer.android.com/studio) com emulador configurado, **ou** dispositivo físico Android
- Node.js 18+ (para API local)
- Conta no [Render](https://render.com) (para deploy da API e PostgreSQL)

## Setup do app Flutter

```bash
git clone <url-do-repositorio>
cd app_registro_att
flutter pub get
flutter doctor
flutter run
```

### Fonte de dados no app

No menu do AppBar (ícone de nuvem/armazenamento), escolha:

- **SQLite (local)** — dados salvos no dispositivo
- **API (remota)** — dados salvos no PostgreSQL via API no Render

Para alterar a URL da API, edite `lib/config/api_config.dart` ou execute com:

```bash
flutter run --dart-define=API_BASE_URL=https://sua-api.onrender.com
```

---

## Estrutura do projeto

```
app_registro_att/
├── api/                               # API Node.js + Express + PostgreSQL
│   ├── routes/atividades.js           # Rotas CRUD
│   ├── db.js                          # Conexão PostgreSQL
│   ├── server.js                      # Servidor Express
│   └── README.md                      # Documentação da API
├── lib/
│   ├── main.dart                      # Entrada e tema Material 3
│   ├── config/api_config.dart         # URL base da API
│   ├── components/editor.dart         # Campo de texto reutilizável
│   ├── models/modelo_principal.dart   # Modelo Atividade
│   ├── db/database_helper.dart        # Persistência SQLite
│   ├── services/atividade_api_service.dart  # Comunicação HTTP com API
│   ├── repository/atividade_repository.dart # Escolha local vs remota
│   └── screens/funcionalidades/
│       ├── lista.dart                 # Listagem + resumo + CRUD
│       └── formulario.dart            # Cadastro e edição
└── render.yaml                        # Blueprint de deploy no Render
```

---

## Modelo de dados

| Campo | Tipo | Exemplo |
|---|---|---|
| id | inteiro | 1 |
| Nome | texto | "Corrida no parque" |
| Tipo | seleção | Cardio, Musculação, Natação... |
| Duração | minutos | 45 |
| Calorias | kcal | 350 |
| Intensidade | seleção | Leve, Moderada, Intensa |
| Data | dd/mm/aaaa | 10/06/2026 |

---

## API — Rotas (Render)

Base URL: `https://app-registro-att.onrender.com`

| Método | Rota | Parâmetros |
|---|---|---|
| GET | `/api/atividades` | — |
| GET | `/api/atividades/:id` | `id` na URL |
| POST | `/api/atividades` | Body JSON: `nome`, `tipo`, `duracao_minutos`, `calorias`, `intensidade`, `data` |
| PUT | `/api/atividades/:id` | `id` na URL + mesmo body do POST |
| DELETE | `/api/atividades/:id` | `id` na URL |

Exemplo de cadastro:

```bash
curl -X POST https://sua-api.onrender.com/api/atividades \
  -H "Content-Type: application/json" \
  -d '{"nome":"Corrida","tipo":"Cardio","duracao_minutos":30,"calorias":200,"intensidade":"Leve","data":"10/06/2026"}'
```

---

## Deploy no Render

1. Faça push do repositório para o GitHub.
2. No Render, crie um **Blueprint** usando o `render.yaml` ou crie manualmente:
   - **PostgreSQL** (plano free)
   - **Web Service** na pasta `api` com `npm install` e `npm start`
3. Vincule `DATABASE_URL` do PostgreSQL ao Web Service.
4. Copie a URL pública e atualize `lib/config/api_config.dart`.

---

## Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| Lista dinâmica | Cards com ícone por tipo e badge de intensidade |
| Resumo no topo | Total de atividades, minutos e calorias |
| CRUD completo | Cadastrar, editar e remover atividades |
| SQLite local | Dados persistem após fechar o app |
| API remota | Sincronização com PostgreSQL no Render |
| Camada repository | Telas não dependem diretamente de SQLite ou HTTP |
| Mensagens | SnackBars de sucesso e erro |

---

## Vídeo de demonstração

Grave um vídeo de até 5 minutos mostrando:

1. Abertura do app
2. Listagem de registros (modo local e remoto)
3. Cadastro de nova atividade
4. Atualização visual da lista
5. Edição e exclusão de um registro

---

## Tema

Material 3 com paleta laranja (`Colors.orange`). Para alterar, edite `seedColor` em `lib/main.dart`.
