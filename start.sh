#!/bin/bash

echo "======================================"
echo "Quiz App Microservices - Docker Setup"
echo "======================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Build and start services
echo "🚀 Building and starting all services..."
echo "This may take a few minutes on first run..."
echo ""

docker-compose up --build -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo ""
echo "📊 Service Status:"
echo "-------------------"
docker-compose ps

echo ""
echo "✅ Application is starting up!"
echo ""
echo "🌐 Access the application at:"
echo "   - Frontend:        http://localhost:8080"
echo "   - API Gateway:     http://localhost:8765"
echo "   - Eureka Dashboard: http://localhost:8761"
echo ""
echo "📝 To view logs:"
echo "   docker-compose logs -f [service-name]"
echo ""
echo "🛑 To stop all services:"
echo "   docker-compose down"
echo ""
echo "🗑️  To remove all data and start fresh:"
echo "   docker-compose down -v"
echo ""
