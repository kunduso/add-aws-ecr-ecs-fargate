const express = require('express');
const exphbs  = require('express-handlebars');
const app = express();
const os = require("os");
const morgan = require('morgan');

// Function to clear require cache and reload secrets.js
function clearSecretsCache() {
    delete require.cache[require.resolve('./secrets')];
    const { getSecretValue } = require('./secrets');
    return getSecretValue; // Return the refreshed function
}

// Initial require of secrets.js
let getSecretValue = clearSecretsCache();

app.engine('handlebars', exphbs({ defaultLayout: 'main' }));
app.set('view engine', 'handlebars');
app.use(express.static('static'));
app.use(morgan('combined'));
app.use('/healthcheck', require('./route/healthcheck'));

const port = process.env.PORT || 8080;
const message = process.env.MESSAGE || "Hello from the Docker container!";
const secretName = 'ecs_secret'; // Name of your AWS Secrets Manager secret

// Endpoint to force reload of secrets
app.get('/reload-secrets', async (req, res) => {
    try {
        getSecretValue = clearSecretsCache(); // Reload secrets
        const secretValue = await getSecretValue(secretName); // Retrieve new secret value
        res.status(200).json({ message: 'Secrets reloaded successfully', secretValue });
    } catch (err) {
        console.error("Failed to reload secrets:", err);
        res.status(500).json({ error: 'Failed to reload secrets' });
    }
});

// Retrieve secret value asynchronously
getSecretValue(secretName)
    .then(secretValue => {
        // Start the server after retrieving the secret value
        app.get('/', function (req, res) {
            res.render('home', {
                message: message,
                hostName: os.hostname(),
                secretValue: secretValue // Pass the secret value to the view
            });
        });
        app.listen(port, function () {
            console.log("Listening on: http://%s:%s", os.hostname(), port);
        });
    })
    .catch(err => {
        console.error("Failed to retrieve secret:", err);
        process.exit(1); // Exit the application if secret retrieval fails
    });

module.exports = app;