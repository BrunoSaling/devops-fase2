const express = require('express');
const os = require('os');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// ── Endpoint principal ──────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    message: 'DevOps Fase 2 — API em execução 🚀',
    version: process.env.APP_VERSION || '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString()
  });
});

// ── Health check (usado pelo Docker e Load Balancer) ────────
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// ── Informações do container ────────────────────────────────
app.get('/info', (req, res) => {
  res.json({
    hostname: os.hostname(),
    platform: process.platform,
    nodeVersion: process.version,
    memoryUsage: process.memoryUsage(),
    cpus: os.cpus().length
  });
});

app.listen(PORT, () => {
  console.log(`[${new Date().toISOString()}] Servidor rodando na porta ${PORT}`);
});

module.exports = app;
