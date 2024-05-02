# Build app with a full JDK
FROM maven:3-eclipse-temurin-19-alpine AS build
RUN apk update && apk add binutils
RUN mkdir -p /app
WORKDIR /app
COPY pom.xml /app
COPY src /app/src
RUN mvn -B package --file pom.xml -DskipTests

# Create small run time image with only a Java JRE
FROM eclipse-temurin:17-jre-alpine
# Expose port 8088
EXPOSE 8081
# Add the jar file
COPY --from=build /app/target/*.jar devops-ci-demo-0.0.1-SNAPSHOT.jar
# Start the application
ENTRYPOINT ["java", "-jar", "/devops-ci-demo-0.0.1-SNAPSHOT.jar"]
