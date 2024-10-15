include ../../../make.inc

# $CHALLENGIFY_BEGIN
build_docker_image:
	@echo "Building docker image..."
	@docker build -t $(DOCKER_IMAGE_NAME) .

run_docker_image:
	@echo "Running docker image..."
	@docker run -it --rm -p $(PORT):$(PORT) -e PORT=$(PORT) $(DOCKER_IMAGE_NAME)

push_docker_image:
	@echo "Pushing docker image..."
	@docker push $(DOCKER_IMAGE_NAME)

deploy_docker_image:
	@echo "Deploying docker image..."
	@gcloud run deploy first-app --image $(DOCKER_IMAGE_NAME) --region europe-west1

# $CHALLENGIFY_END
