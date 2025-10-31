# Quiz App Microservices

A microservices-based quiz application built with Spring Boot, featuring service discovery, API gateway, and distributed architecture.

## Architecture

This application consists of the following microservices:

- **Service Registry**: Eureka server for service discovery
- **API Gateway**: Gateway for routing requests to appropriate microservices
- **Question Service**: Manages quiz questions
- **Quiz Service**: Handles quiz creation and evaluation

## Technologies Used

- Spring Boot
- Spring Cloud (Eureka, Gateway)
- OpenFeign for inter-service communication
- PostgreSQL/MySQL for database
- Maven for dependency management

## Getting Started

### Prerequisites

- JDK 17 or higher
- Maven
- Database (PostgreSQL/MySQL)

### Running the Application

1. Start the Service Registry:
```bash
cd service-registry
./mvnw spring-boot:run
```

2. Start the API Gateway:
```bash
cd api-gateway
./mvnw spring-boot:run
```

3. Start the Question Service:
```bash
cd question-service
./mvnw spring-boot:run
```

4. Start the Quiz Service:
```bash
cd quiz-service
./mvnw spring-boot:run
```

### Database Setup

Run the SQL script to populate the question database:
```bash
question-table-data.sql
```

## API Endpoints

Access the services through the API Gateway at `http://localhost:8765`

## License

This project is open source and available under the MIT License.
