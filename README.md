# Sdk builder
This repository hosts the Dockerfile to generate an image with the required dependencies to build application from Wirepas SDK.

# Dockerhub
Images are automatically built and uploaded to Dockerhub with the following strategy

## Tag logic
### Master branch
The docker image from top of master is published with the tag **edge**

### Tagged versions starting with v*
Any tag with the format v* will be pushed with the same tag.
Additionally the latest tag will have the tag **latest** in order to always follow the latest stable version.

In order to create such a tag, please create a release with the release tab.
