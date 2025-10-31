# Quiz App Microservices

A microservices-based quiz application built with Spring Boot, featuring service discovery, API gateway, and distributed architecture.

## Architecture

This application consists of the following microservices:

- **Service Registry**: Eureka server for service discovery (Port 8761)
- **API Gateway**: Gateway for routing requests to appropriate microservices (Port 8765)
- **Question Service**: Manages quiz questions (Port 8080)
- **Quiz Service**: Handles quiz creation and evaluation (Port 8090)
- **Frontend**: Web interface served via Nginx (Port 8080)
- **PostgreSQL**: Database for storing questions and quizzes

## Technologies Used

- Spring Boot 3.1.x
- Spring Cloud (Eureka, Gateway)
- OpenFeign for inter-service communication
- PostgreSQL 15
- Docker & Docker Compose
- Nginx
- Maven for dependency management

## Getting Started

### Prerequisites

**Option 1: Using Docker (Recommended)**
- Docker
- Docker Compose

**Option 2: Manual Setup**
- JDK 17 or higher
- Maven
- PostgreSQL database

## Running with Docker (Recommended)

### Quick Start

1. Clone the repository:
```bash
git clone https://github.com/yaswanth65/quizApp_Microservices.git
cd quizApp_Microservices
```

2. Build and start all services:
```bash
docker-compose up --build
```

3. Access the application:
   - **Frontend**: http://localhost:8080
   - **API Gateway**: http://localhost:8765
   - **Service Registry (Eureka)**: http://localhost:8761
   - **PostgreSQL**: localhost:5432

4. To stop all services:
```bash
docker-compose down
```

5. To stop and remove all volumes (clean slate):
```bash
docker-compose down -v
```

### Docker Services

The `docker-compose.yml` file orchestrates the following containers:

- `postgres`: PostgreSQL database with auto-initialized schemas
- `service-registry`: Eureka service discovery server
- `question-service`: Question management microservice
- `quiz-service`: Quiz management microservice
- `api-gateway`: API Gateway for routing
- `frontend`: Nginx server hosting the web UI

### Healthchecks

All services include health checks to ensure proper startup order:
- PostgreSQL must be ready before the microservices start
- Service Registry must be healthy before other services register
- API Gateway waits for all services to be available

## Running Manually (Without Docker)

### Prerequisites
- PostgreSQL must be installed and running
- Create databases: `questiondb` and `quizdb`

### Steps

1. Start PostgreSQL and create databases:
```sql
CREATE DATABASE questiondb;
CREATE DATABASE quizdb;
```

2. Update application.properties in each service with your database credentials

3. Start the Service Registry:
```bash
cd service-registry
./mvnw spring-boot:run
```

4. Start the API Gateway:
```bash
cd api-gateway
./mvnw spring-boot:run
```

5. Start the Question Service:
```bash
cd question-service
./mvnw spring-boot:run
```

6. Start the Quiz Service:
```bash
cd quiz-service
./mvnw spring-boot:run
```

7. Serve the frontend (use any web server or open index.html in browser)

### Database Setup

Optionally load sample data:
```bash
psql -U postgres -d questiondb -f question-table-data.sql
```

## API Endpoints

All services are accessible through the API Gateway at `http://localhost:8765`

### Question Service
- `GET /question/allquestions` - Get all questions
- `GET /question/category/{category}` - Get questions by category
- `POST /question/addquestion` - Add a new question
- `GET /question/generate?category={category}&noq={number}` - Generate questions for a quiz
- `POST /question/getscore` - Get quiz score

### Quiz Service
- `GET /quiz/all` - Get all quizzes
- `POST /quiz/create?category={cat}&noq={num}&title={title}` - Create a quiz
- `GET /quiz/get/{id}` - Get quiz questions
- `POST /quiz/submit/{id}` - Submit quiz answers
- `DELETE /quiz/delete/{id}` - Delete a quiz

## Deploying to Render

### Deploy Using Docker

1. Create a new Web Service on Render
2. Connect your GitHub repository
3. Use the following settings:
   - **Environment**: Docker
   - **Dockerfile Path**: Choose the service to deploy
   - **Instance Type**: Free or paid based on your needs

4. Add environment variables for each service:
```
SPRING_DATASOURCE_URL=jdbc:postgresql://<render-postgres-host>:5432/<dbname>
SPRING_DATASOURCE_USERNAME=<username>
SPRING_DATASOURCE_PASSWORD=<password>
EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=<eureka-service-url>
```

5. Deploy each service separately in this order:
   - PostgreSQL Database
   - Service Registry
   - Question Service
   - Quiz Service
   - API Gateway
   - Frontend

### Deploy Using render.yaml (Blueprint)

Create a `render.yaml` file for automated deployment:

```yaml
services:
  - type: web
    name: service-registry
    env: docker
    dockerfilePath: ./service-registry/Dockerfile
    healthCheckPath: /actuator/health
    
  - type: web
    name: api-gateway
    env: docker
    dockerfilePath: ./api-gateway/Dockerfile
    
  - type: web
    name: question-service
    env: docker
    dockerfilePath: ./question-service/Dockerfile
    
  - type: web
    name: quiz-service
    env: docker
    dockerfilePath: ./quiz-service/Dockerfile
    
databases:
  - name: quiz-postgres
    databaseName: quizapp
    user: quizuser
```

## Project Structure

```
.
├── api-gateway/          # API Gateway service
├── question-service/     # Question management service
├── quiz-service/         # Quiz management service
├── service-registry/     # Eureka service registry
├── docker-compose.yml    # Docker compose configuration
├── init-db.sql          # Database initialization script
├── nginx.conf           # Nginx configuration
├── index.html           # Frontend application
└── README.md            # This file
```

## Features

- ✅ Create and manage quiz questions
- ✅ Organize questions by category and difficulty
- ✅ Create custom quizzes with selected categories
- ✅ Take quizzes with interactive UI
- ✅ Automatic scoring and result display
- ✅ Microservices architecture with service discovery
- ✅ API Gateway for unified access
- ✅ Containerized deployment with Docker
- ✅ Health checks and monitoring

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
