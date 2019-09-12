SERVER_PATH := ./server/
PROTO_PATH := ./proto/
WEB_PATH := ./web/
WEB_PROTO_LIB_PATH := $(WEB_PATH)src/lib/

# Used by gsed to insert a /* eslint-disabled */ on the top of the generated files
#		as a work around for the generated proto files
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

add.eslint-header: 
	@for filename in $(shell ls $(WEB_PROTO_LIB_FILES) ); do\
		sed -i '' "1s/^/\/\* eslint-disable \*\/`echo \\\r`/g" $${filename}; \
	done\

generate.proto-files: execute.proto-files add.eslint-header
	@echo "Done generating proto files and adding a eslint fix..."

# go mod
update.server-vendor:
	cd $(SERVER_PATH) && \
		GO111MODULE=on go mod tidy && \
		GO111MODULE=on go mod vendor

# docker
build.docker-server:
	docker build -f ./deploy/docker/goserver/Dockerfile . -t grpc-exam-server

