function deploy_istio_api_gateway(){
  echo "Deploying Istio and API Gateway from latest release"

  kubectl create namespace kyma-system

  kubectl apply -f https://github.com/kyma-project/istio/releases/latest/download/istio-manager.yaml
  kubectl apply -f https://github.com/kyma-project/istio/releases/latest/download/istio-default-cr.yaml

  kubectl apply -f https://github.com/kyma-project/api-gateway/releases/latest/download/api-gateway-manager.yaml
  kubectl apply -f https://github.com/kyma-project/api-gateway/releases/latest/download/apigateway-default-cr.yaml
}
