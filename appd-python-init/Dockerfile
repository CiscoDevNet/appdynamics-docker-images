FROM alpine

WORKDIR /opt/appdynamics

COPY run-with-agent.sh .

RUN chmod +x run-with-agent.sh

CMD [ "echo", "Delivering the Python Agent Install script. Copy the script run-with-agent.sh from /opt/AppDynamics to the application container and override the application entry point to call the script" ]
