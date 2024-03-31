FROM maven:3.9-amazoncorretto-17-debian as BUILD

SHELL ["/bin/bash", "-c"]

ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto

RUN mkdir /app

WORKDIR /app

RUN apt-get update && apt-get install zip curl git -y

RUN curl -s "https://get.sdkman.io" | bash


RUN source /root/.sdkman/bin/sdkman-init.sh && sdk install springboot

RUN git clone https://github.com/spring-cloud/spring-cloud-netflix.git --depth 1

RUN unset MAVEN_CONFIG && cd spring-cloud-netflix && ./mvnw install

COPY rest-server/eureka-server/ /app/eureka-server

RUN cd eureka-server && ./gradlew build -x test

COPY rest-server/application.yaml /app/eureka-server/src/main/resources 

FROM ubuntu:focal-20240216

RUN apt-get update && apt-get install -y wget gpg curl dnsutils inetutils-ping jq

RUN wget -O - https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
        echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" \
        | tee /etc/apt/sources.list.d/corretto.list

RUN apt-get update && apt-get install -y java-17-amazon-corretto-jdk

EXPOSE 8080

RUN mkdir /app

WORKDIR /app

COPY --from=BUILD /app/eureka-server/build/libs/eureka-server-0.0.1-SNAPSHOT.jar .

COPY --from=BUILD /app/eureka-server/src/main/resources/*.yaml .

COPY --chmod=755 startup.sh /app/

ENTRYPOINT ["./startup.sh"] 