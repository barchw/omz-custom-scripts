
function deploy_istio_api_gateway_no_cr(){
  echo "Deploying Istio and API Gateway from latest release without CR"

  kubectl create namespace kyma-system

  kubectl apply -f https://github.com/kyma-project/istio/releases/latest/download/istio-manager.yaml
  kubectl apply -f https://github.com/kyma-project/api-gateway/releases/latest/download/api-gateway-manager.yaml
}
