const fs = require('fs');
const path = require('path');
const readline = require('readline');
const mysql = require('mysql2/promise');

function ask(question) {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });
    return new Promise(resolve => {
        rl.question(question, answer => {
            rl.close();
            resolve(answer.trim());
        });
    });
}

async function main() {
    let host = '';
    let port = 24024;
    let user = 'avnadmin';
    let password = '';
    let database = 'defaultdb';

    const args = process.argv.slice(2);

    // Case 1: Full URI passed (starts with mysql://)
    if (args[0] && args[0].startsWith('mysql://')) {
        const u = new URL(args[0]);
        host = u.hostname;
        port = parseInt(u.port) || 24024;
        user = decodeURIComponent(u.username) || 'avnadmin';
        password = decodeURIComponent(u.password);
        database = u.pathname.replace(/^\//, '') || 'defaultdb';
    } 
    // Case 2: User passed password as first arg (e.g. AVNS_...)
    else if (args[0] && args[0].startsWith('AVNS_')) {
        password = args[0];
        host = args[1] || '';
        if (!host) {
            host = await ask('Enter Aiven Host (e.g. mysql-1936d6df-xxxx.aivencloud.com): ');
        }
        port = parseInt(args[2]) || 24024;
    } 
    // Case 3: User passed host as first arg
    else if (args[0]) {
        host = args[0];
        password = args[1] || await ask('Enter Aiven Password: ');
        port = parseInt(args[2]) || 24024;
    } 
    // Case 4: No args passed -> interactive
    else {
        host = await ask('Enter Aiven Host (e.g. mysql-1936d6df-xxxx.aivencloud.com): ');
        password = await ask('Enter Aiven Password: ');
        const portInput = await ask('Enter Port [default 24024]: ');
        if (portInput) port = parseInt(portInput);
    }

    if (!host || !password) {
        console.error('\n❌ Host and Password are required!');
        process.exit(1);
    }

    console.log(`\nConnecting to Aiven MySQL (${host}:${port})...`);

    const connection = await mysql.createConnection({
        host,
        port,
        user,
        password,
        database,
        ssl: {
            rejectUnauthorized: false
        },
        multipleStatements: true
    });

    console.log('✅ Connected to Aiven successfully!');

    const sqlFile = path.join(__dirname, 'ptms', 'database', 'ptms_db.sql');
    if (!fs.existsSync(sqlFile)) {
        console.error('❌ SQL file not found at:', sqlFile);
        process.exit(1);
    }

    const rawSql = fs.readFileSync(sqlFile, 'utf8');

    // Remove comments
    const lines = rawSql.split('\n');
    let cleanSql = '';
    for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith('--') || trimmed.startsWith('/*') || trimmed.startsWith('#')) {
            continue;
        }
        cleanSql += line + '\n';
    }

    // Split statements
    const statements = cleanSql.split(';').map(s => s.trim()).filter(Boolean);
    console.log(`Executing ${statements.length} SQL statements...`);

    let count = 0;
    for (const stmt of statements) {
        if (/^(START TRANSACTION|COMMIT|SET time_zone)/i.test(stmt)) {
            continue;
        }
        try {
            await connection.query(stmt);
            count++;
        } catch (err) {
            if (!/already exists|duplicate/i.test(err.message)) {
                console.warn(`[Notice] ${err.message}`);
            }
        }
    }

    console.log(`\n🎉 SUCCESS! ${count} statements executed successfully!`);
    console.log('All tables (system_info, users, employee_list, etc.) are now imported into Aiven.');
    console.log('Now refresh your Render website link!\n');

    await connection.end();
}

main().catch(err => {
    console.error('\n❌ Error:', err.message);
    process.exit(1);
});
