# API - Registro de Atividades Físicas

API REST em Node.js + Express conectada ao PostgreSQL.

## Rotas

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/atividades` | Lista todas as atividades |
| GET | `/api/atividades/:id` | Busca uma atividade por ID |
| POST | `/api/atividades` | Cadastra nova atividade |
| PUT | `/api/atividades/:id` | Atualiza atividade existente |
| DELETE | `/api/atividades/:id` | Remove atividade |

### Exemplo POST

```json
{
  "nome": "Corrida no parque",
  "tipo": "Cardio",
  "duracao_minutos": 45,
  "calorias": 350,
  "intensidade": "Moderada",
  "data": "10/06/2026"
}
```

## Execução local

```bash
cd api
npm install
cp .env.example .env
npm run dev
```

## Deploy no Render

1. Crie um **PostgreSQL** no Render e copie a `Internal Database URL`.
2. Crie um **Web Service** apontando para a pasta `api`.
3. Configure as variáveis:
   - `DATABASE_URL` = URL do PostgreSQL
   - `NODE_ENV` = `production`
4. Build Command: `npm install`
5. Start Command: `npm start`

Após o deploy, atualize a URL em `lib/config/api_config.dart` no app Flutter.
