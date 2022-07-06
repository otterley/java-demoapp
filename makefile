# Used by `image`, `push` & `deploy` targets, override as required
IMAGE_REG ?= 749049578452.dkr.ecr.us-west-2.amazonaws.com
IMAGE_REPO ?= java-demoapp
IMAGE_TAG ?= latest

# Used by `deploy` target, sets AWS deployment defaults, override as required
AWS_REGION ?= us-west-2
AWS_STACK_NAME ?= demoapps
AWS_APP_NAME ?= java-demoapp

# Used by `test-api` target
TEST_HOST ?= localhost:8080

# Don't change
SRC_DIR := src

.PHONY: help lint lint-fix image push run deploy undeploy clean test test-api test-report .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help

help:  ## 💬 This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

lint:  ## 🔎 Lint & format, will not fix but sets exit code on error 
	./mvnw checkstyle:check

lint-fix:  ## 📜 Lint & format, will try to fix errors and modify code
	@echo "Lint auto fixing not implemented, Java support for this sucks"

image:  ## 🔨 Build container image from Dockerfile 
	docker build . --file build/Dockerfile \
	--tag $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG)

push:  ## 📤 Push container image to registry 
	docker push $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG)

run:  ## 🏃 Run BOTH components locally using Vue CLI and Go server backend
	./mvnw spring-boot:run

deploy: ## 🚀 Deploy to Amazon ECS
	@echo "### 🚫 Not implemented yet"
	@false
#   @echo "### 🚀 App deployed & available here: ... "

undeploy: ## 💀 Remove from AWS 
	@echo "### 🚫 Not implemented yet"
	@false
#   @echo "### WARNING! Going to delete $(AWS_STACK_NAME) 😲"

test:  ## 🎯 JUnit tests for application
	./mvnw test

test-report: test  ## 🎯 JUnit tests for application (with report output)

test-api: .EXPORT_ALL_VARIABLES  ## 🚦 Run integration API tests, server must be running 
	cd tests \
	&& npm install newman \
	&& ./node_modules/.bin/newman run ./postman_collection.json --env-var apphost=$(TEST_HOST)

clean:  ## 🧹 Clean up project
	rm -rf target/
