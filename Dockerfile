# Stage 1: Build the application
FROM maven:3.9.4-eclipse-temurin-21-alpine AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -X -e -U -DskipTests package

# Stage 2: Run the application
FROM eclipse-temurin:21-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar dockerhello.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "dockerhello.jar"]
