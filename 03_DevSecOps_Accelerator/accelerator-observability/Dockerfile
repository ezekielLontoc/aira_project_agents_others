FROM eclipse-temurin:26-jre

WORKDIR /app

COPY target/accelerator-observability-0.1.0-SNAPSHOT.jar app.jar

EXPOSE 9095

ENV SPRING_PROFILES_ACTIVE=postgres

ENTRYPOINT ["java", "-jar", "/app/app.jar"]