const express = require('express');
const exphbs = require('express-handlebars');
const app = express();
const os = require("os");
const morgan = require('morgan');
const { getSecretValue } = require('./secrets'); // Import getSecretValue function

// Configure Express and middleware
app.engine('handlebars', exphbs({ defaultLayout: 'main' }));
app.set('view engine', 'handlebars');
app.use(express.static('static'));
app.use(morgan('combined'));
app.use('/healthcheck', require('./route/healthcheck'));

const port = process.env.PORT || 8080;
const message = process.env.MESSAGE || "Hello from the Docker container!";
const secretName = 'ecs_secret'; // Name of your AWS Secrets Manager secret

// Retrieve secret value asynchronously
app.get('/', async (req, res) => {
    try {
        const secretValue = await getSecretValue(secretName); // Retrieve secret value from AWS Secrets Manager
        res.render('home', {
            message: message,
            hostName: os.hostname(),
            secretValue: secretValue // Pass the secret value to the view
        });
    } catch (err) {
        console.error("Failed to retrieve secret:", err);
        res.status(500).send("Failed to retrieve secret from AWS Secrets Manager");
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Listening on: http://${os.hostname()}:${port}`);
});

module.exports = app;