SERVER_PATH := ./api/
PROTO_PATH := ./config/proto/
WEB_PATH := ./web/
WEB_PROTO_LIB_PATH := $(WEB_PATH)src/lib/

WEB_PROTO_LIB_FILES := $(WEB_PROTO_LIB_PATH)$(PROTO_NAME)pb/*.js

clean.proto-folder:
	@rm -fr $(WEB_PROTO_LIB_PATH)$(PROTO_NAME)pb && rm -fr $(SERVER_PATH)$(PROTO_NAME)pb

create.proto-folder: clean.proto-folder
	@mkdir $(WEB_PROTO_LIB_PATH)$(PROTO_NAME)pb && mkdir $(SERVER_PATH)$(PROTO_NAME)pb

execute.proto-files: create.proto-folder
	@protoc -I=$(PROTO_PATH) $(PROTO_PATH)/$(PROTO_NAME).proto \
		--js_out=import_style=commonjs:$(WEB_PROTO_LIB_PATH)$(PROTO_NAME)pb/ \
		--grpc-web_out=import_style=commonjs,mode=grpcwebtext:$(WEB_PROTO_LIB_PATH)$(PROTO_NAME)pb/ \
		--go_out=plugins=grpc:$(SERVER_PATH)$(PROTO_NAME)pb/

# Insert a /* eslint-disabled */ on the top of the generated files
#	  as a work around for the generated proto files
add.eslint-header: 
	@for filename in $(shell ls $(WEB_PROTO_LIB_FILES) ); do\
		sed -i '' "1s/^/\/\* eslint-disable \*\/`echo \\\r`/g" $${filename}; \
	done\

# Generate proto files for both web and api
#  `make generatate.proto-files PROTO_NAME="echo"`
generate.proto-files: execute.proto-files add.eslint-header
	@echo "Done generating proto files and adding a eslint fix..."

# go mod
update.server-vendor:
	cd $(SERVER_PATH) && \
		GO111MODULE=on go mod tidy && \
		GO111MODULE=on go mod vendor

# building docker images
#  `make build.docker-grpc-exam SERVICE_NAME="api"`
#  `make build.docker-grpc-exam SERVICE_NAME="envoy"`
#  `make build.docker-grpc-exam SERVICE_NAME="web"`
build.docker-grpc-exam:
	docker build -f ./deployments/docker/$(SERVICE_NAME)/Dockerfile . -t grpc-exam-$(SERVICE_NAME)
