# Use the Node.js base image
FROM node:18

# Install necessary system dependencies for ODBC
RUN apt-get update && apt-get install -y \
    unixodbc \
    curl \
    gnupg2 \
    lsb-release \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Copy pre-downloaded SAP HANA ODBC client zip into the container
COPY ./saphana-client.zip /tmp/saphana-client.zip

# Install SAP HANA ODBC Client
RUN unzip /tmp/saphana-client.zip -d /tmp && \
    cd /tmp/hana-client && \
    ./install.sh && \
    rm -rf /tmp/saphana-client.zip /tmp/hana-client

# Set up ODBC driver for SAP HANA
RUN echo "[HDBODBC]\n\
Description=SAP HANA ODBC Driver\n\
Driver=/usr/sap/hana/client/hdbodbc.so" >> /etc/odbcinst.ini

# Optionally, add any other ODBC configurations (modify as per your actual connection details)
RUN echo "[SAP_HANA]\n\
Driver=HDBODBC\n\
ServerNode=$SAP_HANA_SERVER_NODE\n\
UID=$SAP_HANA_USER_ID\n\
PWD=$SAP_HANA_PASSWORD" >> /etc/odbc.ini

# Set environment variables for ODBC
ENV LD_LIBRARY_PATH="/usr/sap/hana/client:$LD_LIBRARY_PATH"

# Set the working directory for your Node.js application
WORKDIR /app

# Copy the package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of your application files
COPY . .

# Expose the app's port (3000 by default)
EXPOSE 3000

# Start the Node.js app
CMD ["npm", "start"]
