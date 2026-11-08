const { env } = require('process');

// 🎯 Alvo vindo do Aspire (https tem prioridade)
const target =
    env['services__server__https__0'] ||
    env['services__server__http__0'];

if (!target) {
    throw new Error('Endpoint do serviço server não encontrado. Execute pelo Aspire.');
}

console.log(`[Angular Proxy] API target: ${target}`);

module.exports = [
    {
        context: ['/api'],   // 👉 mantém /api, pois o backend já usa /api
        target,              // 👉 ex.: https://server-...:7309 (sem /api no final)
        secure: false,       // 🔒 certificado de desenvolvimento
        changeOrigin: true,
        logLevel: 'debug',   // 🔍 mostra no terminal para onde cada chamada foi
    },
];