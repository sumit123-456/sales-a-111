# ================================================
# 1. Build the Spring Boot JAR using Maven Wrapper
# ================================================
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copy all project files
COPY . .

# Give permission to mvnw (important for Linux)
RUN chmod +x mvnw

# Build the application
RUN ./mvnw -B -DskipTests clean package

# ================================================
# 2. Run Stage (Render Production Container)
# ================================================
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the Render default port
EXPOSE 8080

# Spring Boot runs on Render’s PORT environment variable
ENV PORT=8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
