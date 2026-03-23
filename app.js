// app.js
const express = require('express');
const app = express();

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', version: process.env.APP_VERSION || '1.0.0' });
});

app.get('/api/greet', (req, res) => {
  const name = req.query.name || 'World';
  res.json({ message: `Hello, ${name}!` });
});

module.exports = app;