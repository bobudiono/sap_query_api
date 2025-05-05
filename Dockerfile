# Use the official Node.js image
FROM node:18

# Install necessary system dependencies for ODBC (if needed for other tools)
RUN apt-get update && apt-get install -y \
    unixodbc \
    curl \
    gnupg2 \
    lsb-release \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory for your Node.js application
WORKDIR /app

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install npm dependencies, including @sap/hana-client
RUN npm install

# Copy the rest of your application files
COPY . .

# Expose the app's port (3000 by default)
EXPOSE 3000

# Start the Node.js app
CMD ["npm", "start"]
