const AWS = require('aws-sdk');

// Configure AWS SDK with your region
AWS.config.update({ region: 'your-aws-region' });

// Function to retrieve secret value from AWS Secrets Manager
async function getSecretValue(secretName) {
    const client = new AWS.SecretsManager();

    try {
        const data = await client.getSecretValue({ SecretId: secretName }).promise();

        if (data.SecretString) {
            return JSON.parse(data.SecretString);
        } else {
            throw new Error("SecretString not found in AWS Secrets Manager response.");
        }
    } catch (err) {
        console.error("Error retrieving secret from AWS Secrets Manager:", err);
        throw err;
    }
}

module.exports = { getSecretValue };
