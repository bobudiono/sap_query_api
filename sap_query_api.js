require('dotenv').config(); // Load environment variables from .env
const express = require('express');
const odbc = require('odbc');
const app = express();
const port = process.env.PORT || 3000; // Use Railway’s dynamic port or default to 3000

// Set up body parsing middleware for handling incoming JSON requests (if necessary)
app.use(express.json());

// Create a route for querying SAP
app.get('/query-sap', async (req, res) => {
  try {
    // Construct the SAP connection string from environment variables
    const connectionString = `Driver={HDBODBC};ServerNode=${process.env.address}:${process.env.port};UID=${process.env.user};PWD=${process.env.password}`;

    // Connect to SAP using ODBC (with credentials from .env)
    const connection = await odbc.connect(connectionString);

    // Run the query (replace with your SAP table)
    const result = await connection.query('SELECT * FROM <SAP_TABLE>'); // Replace <SAP_TABLE> with your SAP table name

    // Send the result as JSON response
    res.json(result);

    // Close the connection
    await connection.close();
  } catch (error) {
    console.error('Error querying SAP:', error);
    res.status(500).json({ error: 'Failed to query SAP' });
  }
});

// Start the Express server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

