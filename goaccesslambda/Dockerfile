# Define function directory
ARG FUNCTION_DIR="/function"

FROM --platform=linux/aarch64 ubuntu:latest

WORKDIR /apps

COPY execute.sh /apps/
COPY app.py ./

RUN apt update && apt upgrade -y && \
    apt install wget gpg-agent lsb-release curl unzip gzip python3 python3-pip -y && \
    wget -O - https://deb.goaccess.io/gnugpg.key | gpg --dearmor | tee /usr/share/keyrings/goaccess.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/goaccess.gpg arch=$(dpkg --print-architecture)] https://deb.goaccess.io/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/goaccess.list && \
    apt update && \
    apt install goaccess -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "./awscliv2.zip" && \ 
    unzip /apps/awscliv2.zip -d /apps/ && rm -f /apps/awscliv2.zip && /apps/aws/install && rm -fr /apps/aws

# Install the runtime interface client
RUN pip3 install awslambdaric

ENTRYPOINT [ "/usr/bin/python3", "-m", "awslambdaric" ]
CMD ["app.lambda_handler"]
