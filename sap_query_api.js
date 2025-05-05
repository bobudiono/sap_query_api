require('dotenv').config(); // Load environment variables from .env
const express = require('express');
const hana = require('@sap/hana-client');
const app = express();
const port = process.env.PORT || 3000;

const conn = hana.createConnection();

app.use(express.json());

// Create a route for querying SAP
app.get('/sapquery', (req, res) => {
  try {
    const connectionParams = {
      serverNode: `${process.env.address}:${process.env.port}`,
      uid: process.env.user,
      pwd: process.env.password,
      encrypt: 'true',         // ✅ Required for HANA Cloud
      sslValidateCertificate: 'false' // Optional: skip cert validation (e.g. for testing)
    };

    console.log('Connecting with:', connectionParams);

    conn.connect(connectionParams, (err) => {
      if (err) {
        console.error('Connection Error:', err);
        return res.status(500).json({ error: 'SAP HANA connection failed' });
      }

      // Run the query
      conn.exec(`SELECT * FROM TABLES WHERE SCHEMA_NAME = 'TEST_SPACE'`, (err, result) => {
        if (err) {
          console.error('Query Error:', err);
          return res.status(500).json({ error: 'Query failed' });
        }
        
        res.json(result);
        conn.disconnect(); // Close the connection after query
      });
    });
  } catch (error) {
    console.error('Unexpected Error:', error);
    res.status(500).json({ error: 'Failed to query SAP' });
  }
});

// Health check route
app.get('/', (req, res) => {
  res.send('SAP ODBC API is running.');
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
