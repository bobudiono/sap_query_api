FROM node:18

# Install unixODBC dependencies
RUN apt-get update && \
    apt-get install -y unixodbc unixodbc-dev libtool build-essential && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy project files
COPY . .

# Install Node.js dependencies
RUN npm install

# Expose port
EXPOSE 3000

# Start the app
npm start
