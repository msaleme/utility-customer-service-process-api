# Utility Customer Service Process API

A comprehensive Mule 4 process API that integrates Oracle billing systems, outage management systems, and provides innovative AI-powered features for utility customers through AgentForce integration.

## 🚀 Overview

This process API serves as a central orchestration layer that connects various utility backend systems to provide:

- **Customer profile management**
- **Real-time usage data and analytics**
- **Billing information and payment management**
- **Outage tracking and notifications**
- **Predictive insights and recommendations**
- **AgentForce-powered natural language interactions**
- **Smart energy management recommendations**

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   AgentForce    │    │   Mobile/Web    │    │   Customer      │
│                 │    │   Applications  │    │   Portals       │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
          ┌─────────────────────────────────────────────────────┐
          │        Utility Customer Service Process API          │
          │                                                     │
          │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐   │
          │  │   Oracle    │ │   Outage    │ │ Predictive  │   │
          │  │  Billing    │ │ Management  │ │ Analytics   │   │
          │  │Integration  │ │Integration  │ │Service      │   │
          │  └─────────────┘ └─────────────┘ └─────────────┘   │
          └─────────────────────────────────────────────────────┘
                    │                │                │
          ┌─────────┴───────┐ ┌──────┴──────┐ ┌─────────┴────────┐
          │  Oracle DB      │ │  Outage     │ │  ML/Analytics    │
          │  (Billing &     │ │ Management  │ │  Service         │
          │   Usage Data)   │ │   System    │ │                  │
          └─────────────────┘ └─────────────┘ └──────────────────┘
```

## 🎯 Key Features

### Core Functionality
- **Customer Management**: Comprehensive customer profiles with energy usage patterns
- **Usage Analytics**: Real-time and historical energy consumption data
- **Billing Integration**: Current bills, payment history, and payment plan setup
- **Outage Management**: Real-time outage tracking and customer notifications

### Innovative Features
- **Predictive Analytics**: AI-powered usage forecasting and cost predictions
- **Smart Recommendations**: Personalized energy saving suggestions
- **Weather Integration**: Weather-aware usage predictions
- **Efficiency Scoring**: Benchmarking against similar homes
- **Solar Assessment**: Automated solar potential analysis
- **Time-of-Use Optimization**: Peak hour usage recommendations
- **Carbon Footprint Tracking**: Environmental impact insights

### AgentForce Integration
- **Natural Language Processing**: Intelligent query understanding
- **Contextual Responses**: Personalized responses based on customer data
- **Multi-Intent Handling**: Support for complex customer queries
- **Proactive Recommendations**: Automated suggestions and tips

## 📋 API Endpoints

### Customer Management
- `GET /api/v1/customers/{customerId}` - Get customer profile
- `GET /api/v1/customers/{customerId}/usage` - Get usage data
- `GET /api/v1/customers/{customerId}/usage/hourly` - Get hourly usage
- `GET /api/v1/customers/{customerId}/billing` - Get billing information
- `POST /api/v1/customers/{customerId}/billing/payment-plan` - Setup payment plan

### Predictive Analytics
- `GET /api/v1/customers/{customerId}/insights` - Get predictive insights
- `GET /api/v1/customers/{customerId}/insights/recommendations` - Get smart recommendations

### Outage Management
- `GET /api/v1/outages` - Get current outages
- `GET /api/v1/outages/{outageId}` - Get specific outage details

### Smart Features
- `GET /api/v1/energy-tips` - Get personalized energy saving tips
- `POST /api/v1/service-requests` - Create service request
- `GET /api/v1/service-requests/{requestId}` - Track service request

### AgentForce Integration
- `POST /api/v1/agentforce/query` - Process natural language queries

### Notifications
- `GET /api/v1/customers/{customerId}/notifications` - Get notification preferences
- `PUT /api/v1/customers/{customerId}/notifications` - Update preferences

## 🛠️ Configuration

### Environment Variables

```properties
# HTTP Configuration
http.port=8081

# Oracle Database
oracle.billing.host=your-oracle-host
oracle.billing.port=1521
oracle.billing.serviceName=your-service-name
oracle.billing.username=your-username
oracle.billing.password=your-password

# Outage Management System
outage.management.baseUrl=https://outage-api.utility.com
outage.management.apiKey=your-api-key
outage.management.timeout=30000

# AgentForce
agentforce.endpoint=https://agentforce.salesforce.com
agentforce.apiKey=your-agentforce-key
agentforce.model=gpt-4

# Analytics Service
analytics.prediction.baseUrl=https://analytics.utility.com
analytics.prediction.apiKey=your-analytics-key

# Notifications
notifications.email.provider=sendgrid
notifications.email.apiKey=your-sendgrid-key
notifications.sms.provider=twilio
notifications.sms.apiKey=your-twilio-key
```

### Database Schema

The API expects the following Oracle database tables:

```sql
-- Core tables (see database-schema.sql for complete schema)
CUSTOMERS
USAGE_DATA
HOURLY_USAGE
BILLS
PAYMENTS
PAYMENT_PLANS
SERVICE_REQUESTS
NOTIFICATION_PREFERENCES
ENERGY_PROFILES
WEATHER_DATA
```

## 🚀 Deployment

### Prerequisites
- MuleSoft Runtime 4.9.9+
- JDK 17+
- Oracle Database 12c+
- Access to external services (Outage Management, Analytics)

### Local Development

1. **Clone and Configure**
   ```bash
   cd utility-customer-service-process-api
   cp src/main/resources/config.properties.example src/main/resources/config.properties
   # Edit config.properties with your settings
   ```

2. **Run Locally**
   ```bash
   mvn clean compile
   mvn mule:run
   ```

3. **Test API**
   ```bash
   curl http://localhost:8081/api/v1/customers/12345
   ```

### CloudHub Deployment

```bash
mvn clean package deploy -DmuleDeploy \
  -Dcloudhub.application.name=utility-customer-service-api \
  -Dcloudhub.environment=production \
  -Dcloudhub.worker.type=Micro \
  -Dcloudhub.workers=2
```

## 💡 Innovative Use Cases

### 1. Predictive Bill Management
- Forecast next month's bill based on weather and usage patterns
- Alert customers before high usage months
- Suggest optimal payment plans

### 2. Smart Home Integration
- IoT device recommendations based on usage patterns
- Automated demand response participation
- Smart thermostat optimization suggestions

### 3. Community Energy Programs
- Neighborhood energy challenges
- Peer comparison analytics
- Group solar installation opportunities

### 4. Proactive Customer Service
- Predict service issues before they occur
- Automated outage notifications with personalized impact assessment
- Preventive maintenance scheduling based on usage patterns

### 5. Environmental Impact Tracking
- Carbon footprint monitoring
- Renewable energy recommendations
- Environmental impact comparisons

## 🔒 Security Features

- **API Key Authentication** for external service access
- **Customer Data Encryption** at rest and in transit
- **Rate Limiting** to prevent abuse
- **Input Validation** for all endpoints
- **Audit Logging** for compliance
- **Circuit Breakers** for service resilience

## 📊 Monitoring & Analytics

### Health Checks
- `GET /health` - Overall service health
- Individual service connectivity monitoring
- Database connection health

### Metrics
- Request/response times
- Error rates by endpoint
- External service availability
- Customer usage patterns

### Alerts
- Service degradation notifications
- High error rate alerts
- External service connectivity issues

## 🔄 Error Handling

Comprehensive error handling with:
- **Graceful Degradation**: Partial functionality when services are down
- **Retry Logic**: Automatic retry for transient failures
- **Circuit Breakers**: Prevent cascading failures
- **Meaningful Error Messages**: User-friendly error responses
- **Logging**: Detailed error logging for troubleshooting

## 🧪 Testing

### Unit Tests
```bash
mvn test
```

### Integration Tests
```bash
mvn verify -Dtest.env=integration
```

### Load Testing
```bash
# Using JMeter or similar tools
# Test plans available in src/test/performance/
```

## 📈 Performance Optimizations

- **Caching**: Redis-based caching for frequently accessed data
- **Connection Pooling**: Optimized database connections
- **Asynchronous Processing**: Non-blocking operations where possible
- **Data Pagination**: Large dataset handling
- **Compression**: Response compression for better performance

## 🔮 Future Enhancements

### Phase 2 Features
- **Real-time IoT Integration**: Smart meter real-time data
- **Blockchain Integration**: Peer-to-peer energy trading
- **AR/VR Capabilities**: Virtual energy audits
- **Voice Integration**: Alexa/Google Home support

### Advanced Analytics
- **Machine Learning Models**: Custom ML models for each customer
- **Anomaly Detection**: Unusual usage pattern alerts
- **Demand Forecasting**: Grid-level demand predictions
- **Optimization Algorithms**: Automated energy optimization

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For technical support or questions:
- **Email**: api-support@utility.com
- **Documentation**: https://docs.utility.com/api
- **Status Page**: https://status.utility.com

---

## 🌟 Why This API is Innovative

This API goes beyond traditional utility APIs by providing:

1. **Predictive Intelligence**: Uses AI to forecast usage and costs
2. **Personalized Recommendations**: Tailored energy saving suggestions
3. **Natural Language Interface**: AgentForce integration for conversational interactions
4. **Holistic View**: Combines billing, usage, outages, and recommendations
5. **Proactive Service**: Anticipates customer needs
6. **Environmental Impact**: Tracks and reduces carbon footprint
7. **Community Features**: Enables peer comparisons and community programs
8. **Modern Architecture**: Cloud-native, microservices-ready design

This makes utility data more useful to consumers by transforming raw usage data into actionable insights, predictions, and personalized recommendations that help customers save money, reduce environmental impact, and improve their overall energy experience.
