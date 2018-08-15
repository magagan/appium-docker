FROM openjdk:8-jdk

ARG APPIUM_VERSION=1.8.1
ARG NODEJS_DIST_URL="https://nodejs.org/dist/v9.9.0/node-v9.9.0-linux-x64.tar.xz"
ARG ANDROID_SDK_URL=http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz
ARG ANDROID_BUILD_TOOLS_VERSION=24.0.0

# Install Android tools + SDK
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${JAVA_HOME}/bin:${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y rinetd  && \
	apt-get autoremove && apt-get clean && rm -r /var/lib/apt/lists/* && \
	echo -n "" > /etc/rinetd.conf && \
	systemctl disable rinetd

RUN wget -qO- "$ANDROID_SDK_URL" | tar -zx -C /opt && \
	echo y | android update sdk --no-ui --all --filter platform-tools --force && \
	echo y | android update sdk --no-ui --all --filter build-tools-$ANDROID_BUILD_TOOLS_VERSION --force

# Appium Server
RUN wget -qO- "$NODEJS_DIST_URL" | tar --strip-components 1  -Jx -C /usr/local && \
	apt-get update && \
	yes | apt-get install build-essential && \
	npm install -g appium@${APPIUM_VERSION} -g --unsafe-perm

# Backwards compability
RUN mkdir /opt/apks

# Appium Server
EXPOSE 4723
