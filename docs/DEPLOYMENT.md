# Deployment Guide

This guide covers deploying the Utility Customer Service Process API to various environments.

## 📋 Prerequisites

### System Requirements
- **MuleSoft Runtime**: 4.9.9 or higher
- **Java**: JDK 17 or higher
- **Maven**: 3.6 or higher
- **Database**: Oracle 12c or higher
- **Memory**: Minimum 2GB RAM for runtime

### Access Requirements
- **Anypoint Platform**: Account with deployment permissions
- **CloudHub**: Access to target environment
- **Database**: Connection credentials and privileges
- **External Services**: API keys and access credentials

## 🏗️ Build Process

### Local Build
```bash
# Clean and compile
mvn clean compile

# Run tests
mvn test

# Package application
mvn package

# The deployable JAR will be in target/ directory
```

### Build with Profiles
```bash
# Development build
mvn clean package -Pdev

# Production build
mvn clean package -Pprod

# Build with integration tests
mvn clean verify -Pintegration
```

## 🌍 Environment Configuration

### Development Environment
```bash
# Set development properties
export MULE_ENV=development
export HTTP_PORT=8081
export ORACLE_HOST=dev-oracle.utility.com
export OUTAGE_API_URL=https://dev-outage.utility.com
export AGENTFORCE_URL=https://dev-agentforce.salesforce.com
```

### Staging Environment
```bash
export MULE_ENV=staging
export HTTP_PORT=8081
export ORACLE_HOST=stage-oracle.utility.com
export OUTAGE_API_URL=https://stage-outage.utility.com
export AGENTFORCE_URL=https://stage-agentforce.salesforce.com
```

### Production Environment
```bash
export MULE_ENV=production
export HTTP_PORT=8081
export ORACLE_HOST=prod-oracle.utility.com
export OUTAGE_API_URL=https://prod-outage.utility.com
export AGENTFORCE_URL=https://prod-agentforce.salesforce.com
```

## ☁️ CloudHub Deployment

### Using Maven Plugin

#### Development Deployment
```bash
mvn clean package deploy -DmuleDeploy \
  -Dcloudhub.application.name=utility-customer-service-api-dev \
  -Dcloudhub.environment=development \
  -Dcloudhub.region=us-east-1 \
  -Dcloudhub.worker.type=Micro \
  -Dcloudhub.workers=1 \
  -Dcloudhub.objectstore.v2=true \
  -Dcloudhub.username=${ANYPOINT_USERNAME} \
  -Dcloudhub.password=${ANYPOINT_PASSWORD}
```

#### Production Deployment
```bash
mvn clean package deploy -DmuleDeploy \
  -Dcloudhub.application.name=utility-customer-service-api \
  -Dcloudhub.environment=production \
  -Dcloudhub.region=us-east-1 \
  -Dcloudhub.worker.type=Small \
  -Dcloudhub.workers=2 \
  -Dcloudhub.objectstore.v2=true \
  -Dcloudhub.username=${ANYPOINT_USERNAME} \
  -Dcloudhub.password=${ANYPOINT_PASSWORD}
```

### CloudHub Configuration

#### Worker Sizing Guidelines
- **Micro (0.1 vCores)**: Development and testing
- **Small (0.2 vCores)**: Small production loads
- **Medium (1 vCore)**: Medium production loads
- **Large (2 vCores)**: High production loads
- **xLarge (4 vCores)**: Very high production loads

#### Recommended Production Settings
```yaml
Application Name: utility-customer-service-api
Environment: production
Region: us-east-1
Worker Type: Small
Workers: 2
ObjectStore v2: Enabled
Persistent Queues: Enabled
Load Balancer: Dedicated (for high availability)
```

### Environment Properties

Set these properties in CloudHub:

```properties
# Database Configuration
oracle.billing.host=${secure::oracle.host}
oracle.billing.username=${secure::oracle.username}
oracle.billing.password=${secure::oracle.password}

# External Services
outage.management.apiKey=${secure::outage.api.key}
agentforce.apiKey=${secure::agentforce.api.key}
analytics.prediction.apiKey=${secure::analytics.api.key}

# Security
security.encryption.key=${secure::encryption.key}

# Monitoring
monitoring.metrics.enabled=true
logging.level=INFO
```

## 🐳 Docker Deployment

### Dockerfile
```dockerfile
FROM mulesoft/mule-runtime:4.9.9-java17

# Copy application JAR
COPY target/utility-customer-service-process-api-1.0.0-mule-application.jar /opt/mule/apps/

# Copy configuration
COPY docker/config.properties /opt/mule/conf/

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8081/health || exit 1
```

### Build and Run
```bash
# Build Docker image
docker build -t utility-customer-service-api:latest .

# Run container
docker run -d \
  --name utility-api \
  -p 8081:8081 \
  -e ORACLE_HOST=oracle.utility.com \
  -e ORACLE_USERNAME=user \
  -e ORACLE_PASSWORD=password \
  utility-customer-service-api:latest
```

### Docker Compose
```yaml
version: '3.8'
services:
  utility-api:
    build: .
    ports:
      - "8081:8081"
    environment:
      - ORACLE_HOST=oracle
      - ORACLE_USERNAME=user
      - ORACLE_PASSWORD=password
    depends_on:
      - oracle
    networks:
      - utility-network

  oracle:
    image: gvenzl/oracle-xe:latest
    environment:
      - ORACLE_PASSWORD=password
    ports:
      - "1521:1521"
    networks:
      - utility-network

networks:
  utility-network:
    driver: bridge
```

## 🖥️ On-Premise Deployment

### Standalone Runtime

1. **Download Mule Runtime**
   ```bash
   # Download from MuleSoft website
   # Extract to desired location
   unzip mule-standalone-4.9.9.zip
   ```

2. **Deploy Application**
   ```bash
   # Copy JAR to apps directory
   cp target/utility-customer-service-process-api-1.0.0-mule-application.jar \
      $MULE_HOME/apps/
   
   # Start Mule
   $MULE_HOME/bin/mule start
   ```

3. **Configuration**
   ```bash
   # Create wrapper.conf
   echo "wrapper.java.additional.1=-Dmule.env=production" >> \
        $MULE_HOME/conf/wrapper.conf
   ```

### Mule Runtime Fabric

1. **Create Runtime Fabric**
2. **Configure Target**
3. **Deploy Application**

```bash
# Deploy to RTF
mvn clean package deploy -DmuleDeploy \
  -Drtf.target=production-rtf \
  -Drtf.replicas=2 \
  -Drtf.cores=1 \
  -Drtf.memory=1Gi
```

## 📊 Monitoring and Health Checks

### Health Check Endpoint
```http
GET /health
```

Response:
```json
{
  "status": "UP",
  "timestamp": "2024-12-19T10:30:00Z",
  "services": {
    "oracle-billing": {
      "status": "UP",
      "lastChecked": "2024-12-19T10:29:58Z"
    },
    "outage-management": {
      "status": "UP",
      "lastChecked": "2024-12-19T10:29:59Z"
    }
  }
}
```

### Monitoring Setup

#### CloudHub Monitoring
- Enable CloudHub Insights
- Configure custom dashboards
- Set up alerts for key metrics

#### External Monitoring
```bash
# Prometheus endpoint
curl http://your-app.cloudhub.io/metrics

# Health check monitoring
curl http://your-app.cloudhub.io/health
```

## 🔐 Security Configuration

### SSL/TLS Configuration
```properties
# HTTPS configuration
https.port=8443
https.keystore.path=keystore.jks
https.keystore.password=${secure::keystore.password}
https.truststore.path=truststore.jks
https.truststore.password=${secure::truststore.password}
```

### API Security
```properties
# API key validation
api.security.enabled=true
api.security.header.name=X-API-Key
api.security.whitelist=127.0.0.1,10.0.0.0/8
```

## 🚀 Blue-Green Deployment

### Strategy
1. **Deploy to Green Environment**
2. **Run Health Checks**
3. **Switch Traffic**
4. **Monitor**
5. **Rollback if Needed**

### Implementation
```bash
# Deploy to green slot
mvn deploy -Dcloudhub.application.name=utility-api-green

# Health check
curl https://utility-api-green.cloudhub.io/health

# Switch traffic (manual process)
# Update load balancer or DNS
```

## 📋 Post-Deployment Checklist

### Verification Steps
- [ ] Application status is STARTED
- [ ] Health check returns 200 OK
- [ ] Database connectivity verified
- [ ] External service connectivity verified
- [ ] API endpoints responding correctly
- [ ] Monitoring dashboards show green status
- [ ] Logs show no errors

### Performance Testing
```bash
# Basic load test
curl -X GET "https://your-app.cloudhub.io/api/v1/customers/CUST001"

# Load testing with Apache Bench
ab -n 1000 -c 10 https://your-app.cloudhub.io/api/v1/health
```

## 🔄 Rollback Procedures

### CloudHub Rollback
1. **Access Runtime Manager**
2. **Select Application**
3. **View Deployment History**
4. **Redeploy Previous Version**

### Manual Rollback
```bash
# Redeploy previous version
mvn deploy -DmuleDeploy \
  -Dcloudhub.application.name=utility-api \
  -Dcloudhub.version=1.0.0-previous
```

## 📞 Troubleshooting

### Common Issues

#### Application Won't Start
- Check CloudHub logs
- Verify configuration properties
- Check resource allocation
- Validate dependencies

#### Database Connection Issues
- Verify connection string
- Check credentials
- Test network connectivity
- Review security groups

#### External Service Timeouts
- Check service availability
- Verify API keys
- Review timeout settings
- Check circuit breaker status

### Log Analysis
```bash
# View CloudHub logs
tail -f cloudhub.log

# Check application logs
grep "ERROR\|WARN" application.log

# Monitor performance
grep "PERFORMANCE" application.log
```

### Support Contacts
- **CloudHub Support**: Submit ticket through Anypoint Platform
- **Database Issues**: Contact DBA team
- **External Services**: Check service status pages
- **Application Issues**: Create GitHub issue

---

For additional deployment assistance, please refer to the [MuleSoft documentation](https://docs.mulesoft.com/) or contact the development team.
