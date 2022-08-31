FROM maven:3.6.3-jdk-8 AS appserver
WORKDIR /usr/src/demo
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests

FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY --from=appserver /usr/src/demo/target/demo-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "/app/demo-0.0.1-SNAPSHOT.jar"]
CMD ["--spring.profiles.active=postgres"]
