# First stage: Build stage
FROM oraclelinux:8 AS build
RUN yum install -y git

# Use a base image with JDK 17 for the main build stage
FROM openjdk:17-jdk

# Set the working directory
WORKDIR /app

COPY --from=build /usr/bin/git /usr/bin/git

# Copy the project files into the container
COPY . .

# Make the Maven wrapper executable
RUN chmod +x mvnw 

# Convert Maven wrapper file to Unix format
RUN sed -i 's/\r$//' mvnw

# Run Maven build command
CMD ["./mvnw", "clean", "install", "-B", "-Pdocs", "-DskipTests", "-fae"]