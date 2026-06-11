const express = require('express');
const { pool } = require('../db');

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM atividades ORDER BY id DESC'
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar atividades:', error);
    res.status(500).json({ erro: 'Erro ao listar atividades.' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM atividades WHERE id = $1', [
      id,
    ]);

    if (result.rows.length === 0) {
      return res.status(404).json({ erro: 'Atividade não encontrada.' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao buscar atividade:', error);
    res.status(500).json({ erro: 'Erro ao buscar atividade.' });
  }
});

router.post('/', async (req, res) => {
  const { nome, tipo, duracao_minutos, calorias, intensidade, data } = req.body;

  if (!nome || !tipo || !duracao_minutos || !calorias || !intensidade || !data) {
    return res.status(400).json({ erro: 'Todos os campos são obrigatórios.' });
  }

  try {
    const result = await pool.query(
      `INSERT INTO atividades (nome, tipo, duracao_minutos, calorias, intensidade, data)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [nome, tipo, duracao_minutos, calorias, intensidade, data]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao cadastrar atividade:', error);
    res.status(500).json({ erro: 'Erro ao cadastrar atividade.' });
  }
});

router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { nome, tipo, duracao_minutos, calorias, intensidade, data } = req.body;

  if (!nome || !tipo || !duracao_minutos || !calorias || !intensidade || !data) {
    return res.status(400).json({ erro: 'Todos os campos são obrigatórios.' });
  }

  try {
    const result = await pool.query(
      `UPDATE atividades
       SET nome = $1, tipo = $2, duracao_minutos = $3, calorias = $4,
           intensidade = $5, data = $6
       WHERE id = $7
       RETURNING *`,
      [nome, tipo, duracao_minutos, calorias, intensidade, data, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ erro: 'Atividade não encontrada.' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar atividade:', error);
    res.status(500).json({ erro: 'Erro ao atualizar atividade.' });
  }
});

router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const result = await pool.query(
      'DELETE FROM atividades WHERE id = $1 RETURNING id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ erro: 'Atividade não encontrada.' });
    }

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar atividade:', error);
    res.status(500).json({ erro: 'Erro ao deletar atividade.' });
  }
});

module.exports = router;
