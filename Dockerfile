ARG JDK_VERSION=16
FROM maven:3.6.3-openjdk-$JDK_VERSION-slim

# Without this, the ARG isn't available after the FROM
ARG JDK_VERSION

ADD . /javaupgrades
WORKDIR /javaupgrades

# Cache dependencies
RUN mvn test dependency:go-offline --fail-at-end

# Used to force Docker to always run the commands below the ARG instead of using the cache
ARG DISABLE_CACHE

RUN mvn test --offline --fail-at-end -Dmaven.compiler.release=$JDK_VERSION
