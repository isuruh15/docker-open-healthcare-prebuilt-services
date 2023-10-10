FROM ballerina/jvm-runtime:1.0

RUN apk add --update --no-cache curl jq

RUN mkdir -p /home/ballerina

# Update the release tag when creating a new release
ARG RELEASE_TAG="v2tofhirr4-v1.0.1"

ARG RELEASE_URL="https://api.github.com/repos/wso2/open-healthcare-prebuilt-services/releases/tags/${RELEASE_TAG}"

# Download the Hl7v2ToFhirR4Service.jar from the release
RUN V2TOFHIR_URL=$(curl -sL "${RELEASE_URL}" | jq -r '.assets[] | select(.name == "Hl7v2ToFhirR4Service.jar") | .url') && \
    curl -sLJO -H "Accept: application/octet-stream" "${V2TOFHIR_URL}"

RUN cp Hl7v2ToFhirR4Service.jar /home/ballerina/Hl7v2ToFhirR4Service.jar

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 10014 \
    "choreo"

WORKDIR /home/ballerina

EXPOSE  9090
USER 10014

CMD java -jar 'Hl7v2ToFhirR4Service.jar'
