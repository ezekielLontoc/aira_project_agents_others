FROM eclipse-temurin:26-jre

WORKDIR /app

COPY target/accelerator-evidence-0.1.0-SNAPSHOT.jar app.jar

EXPOSE 9093

ENV SPRING_PROFILES_ACTIVE=postgres

ENTRYPOINT ["java", "-jar", "/app/app.jar"]