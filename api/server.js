require('dotenv').config();

const express = require('express');
const cors = require('cors');
const { initDatabase } = require('./db');
const atividadesRoutes = require('./routes/atividades');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    mensagem: 'API Registro de Atividades Físicas',
    rotas: {
      listar: 'GET /api/atividades',
      buscar: 'GET /api/atividades/:id',
      cadastrar: 'POST /api/atividades',
      atualizar: 'PUT /api/atividades/:id',
      deletar: 'DELETE /api/atividades/:id',
    },
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api/atividades', atividadesRoutes);

async function start() {
  try {
    await initDatabase();
    app.listen(PORT, () => {
      console.log(`API rodando na porta ${PORT}`);
    });
  } catch (error) {
    console.error('Erro ao iniciar a API:', error);
    process.exit(1);
  }
}

start();
