const AWS = require('aws-sdk');

let cachedSecretValue = null; // Variable to cache the secret value

// Function to retrieve secret value from AWS Secrets Manager
async function getSecretValue(secretName) {
    if (cachedSecretValue !== null) {
        // If cached secret value exists, return it immediately
        return cachedSecretValue;
    }

    const region = process.env.AWS_REGION; // Retrieve AWS region from environment variable

    // Configure AWS SDK with the retrieved region
    AWS.config.update({ region });

    const client = new AWS.SecretsManager();

    try {
        const data = await client.getSecretValue({ SecretId: secretName }).promise();

        if (data.SecretString) {
            try {
                // Attempt to parse as JSON
                cachedSecretValue = JSON.parse(data.SecretString);
            } catch (err) {
                // If parsing as JSON fails, store as plain string
                cachedSecretValue = data.SecretString;
            }
        } else {
            throw new Error("SecretString not found in AWS Secrets Manager response.");
        }

        return cachedSecretValue; // Return the cached secret value
    } catch (err) {
        console.error("Error retrieving secret from AWS Secrets Manager:", err);
        throw err;
    }
}

// Function to clear the cached secret value
function clearCache() {
    cachedSecretValue = null;
}

module.exports = { getSecretValue, clearCache };
