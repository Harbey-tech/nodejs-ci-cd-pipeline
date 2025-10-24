#!/bin/bash

# Navigate to deployment directory
cd /var/www/my-node-app || exit

# Pull latest changes
git pull origin main

# Install dependencies
npm install --production

# Restart Node.js app (using PM2)
pm2 restart my-node-app || pm2 start app.js --name "my-node-app"

echo "Deployment completed!"

