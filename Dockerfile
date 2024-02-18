FROM eclipse-temurin:17-jdk-jammy AS base
WORKDIR /service
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src src

FROM base AS build
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy
WORKDIR /service
COPY --from=build /service/target/spring-petclinic-*.jar spring-petclinic.jar
CMD ["java", "-Dspring.profiles.active=postgres", "-jar", "/service/spring-petclinic.jar"]