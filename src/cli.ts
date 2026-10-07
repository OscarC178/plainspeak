import { loadRules, resolve } from './rules';
const path = process.argv[2] ?? (await Bun.file('rules/rules.yaml').exists() ? 'rules/rules.yaml' : 'rules/rules.example.yaml');
try { const rules = await loadRules(path); console.log(JSON.stringify(resolve(rules, { app: process.argv[3] ?? 'Google Chrome', title: process.argv[4] ?? 'general - Workspace - Slack', mode: 'read' }), null, 2)); }
catch (e) { console.error(String(e)); process.exit(1); }
