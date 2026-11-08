
const { env } = require('process');

console.log('\n========== ASPIRE ENVIRONMENT ==========');

for (const [key, value] of Object.entries(env)) {
    if (key.toLowerCase().includes('services__')) {
        console.log(`${key} = ${value}`);
    }
}

console.log('========================================\n');

const target =
    env['services__server__https__0'] ||
    env['services__server__http__0'];

if (!target) {
    console.error('Variáveis disponíveis:');

    console.error(
        Object.keys(env).filter(key =>
            key.toLowerCase().includes('server')
        )
    );

    throw new Error(
        'Endpoint do serviço server não encontrado.'
    );
}

console.log(`[Angular Proxy] API target: ${target}`);

const routes = [
    '/acesso',
    '/categoria',
    '/despesa',
    '/receita',
    '/lancamento',
    '/graficos',
    '/saldo',
    '/usuario',
    '/dashboard'
];

module.exports = Object.fromEntries(
    routes.map(route => [
        route,
        {
            target,
            secure: false,
            changeOrigin: true
        }
    ])
);
