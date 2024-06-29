const AWS = require('aws-sdk');

// Function to retrieve secret value from AWS Secrets Manager
async function getSecretValue(secretName) {
    const region = process.env.AWS_REGION; // Retrieve AWS region from environment variable

    // Configure AWS SDK with the retrieved region
    AWS.config.update({ region });

    const client = new AWS.SecretsManager();

    try {
        const data = await client.getSecretValue({ SecretId: secretName }).promise();

        if (data.SecretString) {
            try {
                // Attempt to parse as JSON
                return JSON.parse(data.SecretString);
            } catch (err) {
                // If parsing as JSON fails, return the plain string value
                return data.SecretString;
            }
        } else {
            throw new Error("SecretString not found in AWS Secrets Manager response.");
        }
    } catch (err) {
        console.error("Error retrieving secret from AWS Secrets Manager:", err);
        throw err;
    }
}

module.exports = { getSecretValue };
