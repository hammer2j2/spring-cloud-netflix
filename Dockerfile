FROM maven:3.9-amazoncorretto-17-debian as BUILD

SHELL ["/bin/bash", "-c"]

ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto

RUN mkdir /app

WORKDIR /app

RUN apt-get update && apt-get install zip curl git -y

RUN curl -s "https://get.sdkman.io" | bash


RUN source /root/.sdkman/bin/sdkman-init.sh && sdk install springboot

# RUN apt-get install openjdk-8-jdk  -y

RUN git clone https://github.com/spring-cloud/spring-cloud-netflix.git --depth 1

RUN unset MAVEN_CONFIG && cd spring-cloud-netflix && ./mvnw install

# RUN spring initializr new \
#     --path demo \
#     --project gradle-project \
#     --language java \
#     --boot-version 2.7.0 \
#     --version 0.0.1-SNAPSHOT \
#     --group com.example \
#     --artifact demo \
#     --name demo \
#     --description "Demo project" \
#     --package-name com.example.demo \
#     --dependencies org.springframework.cloud:spring-cloud-starter-netflix-eureka-server \
#     --packaging jar \
#     --java-version 17   