FROM node:12.4

USER root

# Install Incremental Calculator (https://github.com/intuit/auto)
RUN cd /root && \
    wget https://github.com/intuit/auto/releases/download/v7.1.2/auto-linux.gz && \
    gzip -d auto-linux.gz && \
    mv auto-linux /usr/local/bin/auto && \
    chmod +x /usr/local/bin/auto

# Install SemVer Calculator (https://github.com/markchalloner/git-semver)
RUN cd /root && \
    git clone https://github.com/markchalloner/git-semver.git && \
    git-semver/install.sh

# Add Custom Script for calculating SemVer
RUN echo '#!/bin/bash \n\
CLEAN_BRANCH=$(echo $BRANCH_NAME | sed s/[[:punct:]]/_/g | tr "[:upper:]" "[:lower:]") \n\
SEMVER_ACTION=$(auto version --repo $GH_REPO --owner $GH_ORG) \n\
SEMVER_VERSION=$(git semver $SEMVER_ACTION --dryrun) \n\
if [ "$BRANCH_NAME" == "master" ]; then \n\
    echo "$SEMVER_VERSION" \n\
else \n\
    GIT_SHORT=$(git rev-parse --verify HEAD --short=8) \n\
    echo "$SEMVER_VERSION-$CLEAN_BRANCH.$GIT_SHORT" \n\
fi' > /usr/local/bin/calculate_semver
RUN chmod 777 /usr/local/bin/calculate_semver
