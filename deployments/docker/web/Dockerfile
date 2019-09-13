ARG BUILDER_IMAGE_NAME=node
ARG BUILDER_IMAGE_TAG=8.16.1-alpine
ARG RELEASE_IMAGE_NAME=nginx
ARG RELEASE_IMAGE_TAG=1.17.3-alpine

FROM ${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_TAG} as builder
ARG REACT_APP_API_URL
WORKDIR /app/web
# COPY ./deploy/config/env/web-dev.env ./.env
COPY ./web ./
RUN yarn && yarn build

FROM ${RELEASE_IMAGE_NAME}:${RELEASE_IMAGE_TAG}
COPY --from=builder /app/web/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
