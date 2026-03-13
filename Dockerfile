FROM gradle:8.6.0-jdk17 AS builder

WORKDIR /home/gradle/project

COPY build.gradle .
COPY settings.gradle .
COPY src src

RUN gradle --no-daemon bootJar

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app
ENV JAVA_TOOL_OPTIONS="-Xms256m -Xmx512m"

COPY --from=builder /home/gradle/project/build/libs/*.jar app.jar

VOLUME /tmp
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
