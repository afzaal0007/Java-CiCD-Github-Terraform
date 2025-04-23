RELEASE_NAME=springapp
NAMESPACE=default
CHART_PATH=helm/springapp

deploy:
	helm upgrade --install $(RELEASE_NAME) $(CHART_PATH) --namespace $(NAMESPACE) --create-namespace
