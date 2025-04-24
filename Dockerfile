# ---------- Stage 1: Build ----------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build

WORKDIR /app
    
# Copy pom and download dependencies (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline
    
# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests
    
# ---------- Stage 2: Run ----------
FROM eclipse-temurin:17-jre-alpine AS runtime

# Add non-root user
RUN addgroup -S spring && adduser -S spring -G spring

WORKDIR /app

# Copy only the final jar
COPY --from=build /app/target/*.jar app.jar
RUN chown spring:spring /app/app.jar

# Use non-root user
USER spring:spring

# Set JVM options
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp"

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]