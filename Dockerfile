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
    
    WORKDIR /app
    
    # Copy only the final jar
    COPY --from=build /app/target/*.jar app.jar
    
    EXPOSE 8080
    
    ENTRYPOINT ["java", "-jar", "app.jar"]
    