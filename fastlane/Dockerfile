FROM openjdk:slim

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

ENV ANDROID_HOME "/android-sdk"
ENV ANDROID_COMPILE_SDK "29"
ENV ANDROID_BUILD_TOOLS "29.0.2"
ENV ANDROID_CLI_TOOLS "6609375"
ENV PATH "$PATH:${ANDROID_HOME}/platform-tools"

RUN apt update && \
    apt install -y --no-install-recommends \
        git \
        bash \
        build-essential \
        curl \
        wget \
        zip \
        unzip \
        ruby \
        ruby-dev \
        openssh-client \
        ca-certificates && \
    apt clean autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
        
RUN gem install fastlane -v 2.152.0 -NV

RUN curl https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CLI_TOOLS}_latest.zip -o cmdtools-linux.zip && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    unzip cmdtools-linux.zip -d ${ANDROID_HOME}/cmdline-tools && \
    rm cmdtools-linux.zip && \
    export PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools/bin && \
    echo y | sdkmanager "platform-tools" "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"

CMD ["fastlane"]

