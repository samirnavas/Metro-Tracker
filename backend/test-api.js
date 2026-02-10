const http = require('http');

const testEndpoints = async () => {
    const endpoints = [
        '/api/routes',
        '/api/stations',
        '/api/stations/nearby?lat=10.0266&amp;lng=76.3088&amp;limit=3',
        '/api/vehicles'
    ];

    for (const endpoint of endpoints) {
        const options = {
            hostname: 'localhost',
            port: 8080,
            path: endpoint,
            method: 'GET'
        };

        await new Promise((resolve) => {
            const req = http.request(options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    console.log(`\n📍 ${endpoint}`);
                    console.log(`Status: ${res.statusCode}`);
                    try {
                        const json = JSON.parse(data);
                        if (json.success) {
                            const dataLength = Array.isArray(json.data) ? json.data.length : 1;
                            console.log(`✓ Success - ${dataLength} items`);
                            if (dataLength < 3 && Array.isArray(json.data)) {
                                console.log(JSON.stringify(json.data, null, 2));
                            }
                        } else {
                            console.log(`✗ Error: ${json.message}`);
                        }
                    } catch (e) {
                        console.log(`✗ Parse error:`, e.message);
                    }
                    resolve();
                });
            });

            req.on('error', (error) => {
                console.log(`\n📍 ${endpoint}`);
                console.log(`✗ Request failed:`, error.message);
                resolve();
            });

            req.end();
        });
    }

    console.log('\n✅ API test complete!');
    process.exit(0);
};

testEndpoints();
