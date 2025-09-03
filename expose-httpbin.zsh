function expose_httpbin() {
  local name=${1:-httpbin}
  local namespace=${2:-default}
  local host=${3:-httpbin}

  echo "# Applying configuration:
apiVersion: gateway.kyma-project.io/v2
kind: APIRule
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  gateway: kyma-system/kyma-gateway
  hosts: ["httpbin"]
  service:
    name: httpbin
    port: 8000
  rules:
    - path: /*
      methods: ["GET","POST"]
      noAuth: true
"

  echo "
    apiVersion: gateway.kyma-project.io/v2
    kind: APIRule
    metadata:
      name: ${name}
      namespace: ${namespace}
    spec:
      gateway: kyma-system/kyma-gateway
      hosts: ["httpbin"]
      service:
        name: httpbin
        port: 8000
      rules:
        - path: /*
          methods: ["GET","POST"]
          noAuth: true
    " | kubectl apply  -f -
}
