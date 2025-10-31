# Deploying Quiz App to Render

This guide will help you deploy the Quiz App Microservices to Render.

## Prerequisites

1. A Render account (sign up at https://render.com)
2. Your GitHub repository pushed and accessible
3. All Docker files in place (already included)

## Deployment Options

### Option 1: Deploy Using Render Dashboard (Recommended)

#### Step 1: Create PostgreSQL Database

1. Go to Render Dashboard
2. Click "New +" → "PostgreSQL"
3. Fill in:
   - Name: `quiz-postgres`
   - Database: `quizdb`
   - User: `postgres`
   - Region: Choose nearest to you
   - Plan: Free
4. Click "Create Database"
5. **Save the Internal Database URL** (you'll need this)

#### Step 2: Deploy Service Registry (Eureka)

1. Click "New +" → "Web Service"
2. Connect your GitHub repository
3. Fill in:
   - Name: `service-registry`
   - Region: Same as database
   - Branch: `main`
   - Root Directory: `service-registry`
   - Environment: `Docker`
   - Dockerfile Path: `service-registry/Dockerfile`
   - Plan: Free
4. Add environment variable:
   - `SPRING_PROFILES_ACTIVE` = `prod`
5. Click "Create Web Service"
6. Wait for deployment to complete
7. **Copy the service URL** (e.g., https://service-registry-xxxx.onrender.com)

#### Step 3: Deploy Question Service

1. Click "New +" → "Web Service"
2. Connect your repository
3. Fill in:
   - Name: `question-service`
   - Region: Same as previous
   - Branch: `main`
   - Root Directory: `question-service`
   - Environment: `Docker`
   - Dockerfile Path: `question-service/Dockerfile`
   - Plan: Free
4. Add environment variables:
   ```
   SPRING_DATASOURCE_URL = <Internal Database URL from Step 1>
   SPRING_DATASOURCE_USERNAME = postgres
   SPRING_DATASOURCE_PASSWORD = <Database password from Step 1>
   EUREKA_CLIENT_SERVICEURL_DEFAULTZONE = <Service Registry URL from Step 2>/eureka/
   SPRING_PROFILES_ACTIVE = prod
   ```
5. Click "Create Web Service"

#### Step 4: Deploy Quiz Service

1. Click "New +" → "Web Service"
2. Fill in:
   - Name: `quiz-service`
   - Root Directory: `quiz-service`
   - Environment: `Docker`
   - Dockerfile Path: `quiz-service/Dockerfile`
   - Plan: Free
3. Add the same environment variables as Question Service
4. Click "Create Web Service"

#### Step 5: Deploy API Gateway

1. Click "New +" → "Web Service"
2. Fill in:
   - Name: `api-gateway`
   - Root Directory: `api-gateway`
   - Environment: `Docker`
   - Dockerfile Path: `api-gateway/Dockerfile`
   - Plan: Free
3. Add environment variables:
   ```
   EUREKA_CLIENT_SERVICEURL_DEFAULTZONE = <Service Registry URL>/eureka/
   SPRING_PROFILES_ACTIVE = prod
   ```
4. Click "Create Web Service"
5. **Copy the API Gateway URL** (e.g., https://api-gateway-xxxx.onrender.com)

#### Step 6: Deploy Frontend

1. Click "New +" → "Static Site"
2. Connect your repository
3. Fill in:
   - Name: `quiz-frontend`
   - Branch: `main`
   - Build Command: `echo "No build needed"`
   - Publish Directory: `.`
4. Before deploying, **update index.html**:
   - Change `API_BASE_URL` from `http://localhost:8080` to your API Gateway URL
   
   Find this line (around line 164 and 647):
   ```javascript
   const API_BASE_URL = 'http://localhost:8080';
   ```
   
   Change to:
   ```javascript
   const API_BASE_URL = 'https://api-gateway-xxxx.onrender.com';
   ```
5. Commit and push the change
6. Click "Create Static Site"

### Option 2: Deploy Using Render Blueprint

1. Ensure `render.yaml` is in your repository root
2. Go to Render Dashboard
3. Click "New +" → "Blueprint"
4. Connect your GitHub repository
5. Render will automatically detect `render.yaml`
6. Click "Apply" to deploy all services at once
7. Update frontend `API_BASE_URL` as described in Option 1, Step 6

## Important Notes

### Free Tier Limitations

- Services on free tier spin down after 15 minutes of inactivity
- First request after spin down takes 30-60 seconds to wake up
- Database has limited storage (1GB)
- Consider upgrading for production use

### Service Discovery

Since services are deployed separately on Render:
- Each service has its own URL
- Update Eureka configuration to use Render URLs
- Services must register with Eureka using their Render URLs

### Database Initialization

1. After PostgreSQL is created, connect to it
2. Run the initialization script:
   ```bash
   psql -h <render-postgres-host> -U postgres -d quizdb -f question-table-data.sql
   ```

### CORS Configuration

Ensure your services have CORS enabled for the frontend domain:

In each service's `application.properties`:
```properties
spring.web.cors.allowed-origins=https://your-frontend-url.onrender.com
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
spring.web.cors.allowed-headers=*
```

### Health Checks

Render uses health check paths to determine if a service is ready:
- Make sure `/actuator/health` endpoint is accessible
- Add Spring Boot Actuator dependency if not present

## Troubleshooting

### Services won't start
- Check logs in Render dashboard
- Verify environment variables are set correctly
- Ensure database URL is the **Internal Database URL**

### Services can't communicate
- Verify Eureka URL is correct
- Check service registration in Eureka dashboard
- Ensure all services use internal URLs for communication

### Frontend can't reach API
- Verify API Gateway URL in `index.html`
- Check CORS configuration
- Ensure API Gateway is running

### Database connection failed
- Use **Internal Database URL** for services
- Verify username and password
- Check if database is active

## Testing Your Deployment

1. Open the frontend URL
2. Try creating a quiz
3. Add some questions
4. Take a quiz and submit
5. Check if scores are calculated correctly

## Monitoring

- View service logs in Render dashboard
- Monitor Eureka dashboard: `https://service-registry-xxxx.onrender.com`
- Check individual service health: `https://service-name-xxxx.onrender.com/actuator/health`

## Cost Optimization

- Use Render's free tier for development/testing
- Upgrade to paid plans for production use
- Consider using a single PostgreSQL instance for all services
- Set up auto-scaling based on traffic

## Support

If you encounter issues:
1. Check Render's documentation: https://render.com/docs
2. Review service logs for error messages
3. Verify all environment variables are set correctly
4. Test services locally first using Docker Compose

---

**Note**: Replace all placeholder URLs (xxxx) with your actual Render service URLs.
