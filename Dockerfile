FROM maven:3.8.5-eclipse-temurin-17 AS build

WORKDIR /app

COPY sales/pom.xml .
RUN mvn -q -e -B dependency:go-offline

COPY . .

RUN mvn -q -e -B package -DskipTests


FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

