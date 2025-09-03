function deploy_httpbin_injected() {
  local namespace=${1:-default}
  local injection=${2:-enabled}

  echo "Deploying httpbin in namespace $namespace with istio-injection=$injection"

  kubectl create ns $namespace
  kubectl label namespace $namespace istio-injection=$injection
  kubectl apply -f \
    https://raw.githubusercontent.com/istio/istio/master/samples/httpbin/httpbin.yaml \
    -n $namespace
}
