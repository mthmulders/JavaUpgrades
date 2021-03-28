ARG JDK_VERSION=15
ARG DOCKER_IMAGE=maven:3.6.3-openjdk
FROM $DOCKER_IMAGE-$JDK_VERSION

# Docker image for 10: maven:3.6-jdk-10

# Without this, the ARG isn't available after the FROM
ARG JDK_VERSION

ADD . /javaupgrades
WORKDIR /javaupgrades

# Cache dependencies
RUN mvn dependency:go-offline

# Used to force Docker to always run the commands below the ARG
ARG DISABLE_CACHE

RUN mvn compile --fail-at-end -Dmaven.compiler.release=$JDK_VERSION