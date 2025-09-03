function busola_local(){
  set -e
  export DASHBOARD_IMAGE="europe-docker.pkg.dev/kyma-project/prod/busola:latest"

  function deploy_k3d (){
  echo "Provisioning k3d cluster"

  echo "Will remove existing k3d cluster and registry"
  echo "Proceed with deletion (Y/n)?"


  read -r response

  if [[ "$response" != "n" ]]; then
    k3d cluster delete kyma || true
    k3d registry delete registry.localhost || true
  fi

  k3d cluster create kyma --port 80:80@loadbalancer --port 443:443@loadbalancer --k3s-arg "--disable=traefik@server:0" --k3s-arg '--tls-san=host.docker.internal@server:*' --image 'rancher/k3s:v1.31.7-k3s1'

  export KUBECONFIG=$(k3d kubeconfig merge kyma)

  kubectl create ns kyma-system

  echo "Apply istio"
  kubectl apply -f https://github.com/kyma-project/istio/releases/latest/download/istio-manager.yaml
  kubectl apply -f https://github.com/kyma-project/istio/releases/latest/download/istio-default-cr.yaml

  echo "Apply api-gateway"
  kubectl apply -f https://github.com/kyma-project/api-gateway/releases/latest/download/api-gateway-manager.yaml
  kubectl apply -f https://github.com/kyma-project/api-gateway/releases/latest/download/apigateway-default-cr.yaml

  echo "Apply gardener resources"
  echo "Certificates"
  kubectl apply -f https://raw.githubusercontent.com/gardener/cert-management/master/pkg/apis/cert/crds/cert.gardener.cloud_certificates.yaml
  echo "DNS Providers"
  kubectl apply -f https://raw.githubusercontent.com/gardener/external-dns-management/master/pkg/apis/dns/crds/dns.gardener.cloud_dnsproviders.yaml
  echo "DNS Entries"
  kubectl apply -f https://raw.githubusercontent.com/gardener/external-dns-management/master/pkg/apis/dns/crds/dns.gardener.cloud_dnsentries.yaml
  echo "Issuers"
  kubectl apply -f https://raw.githubusercontent.com/gardener/cert-management/master/pkg/apis/cert/crds/cert.gardener.cloud_issuers.yaml
  }

  function build_and_run_busola() {
  echo "Create k3d registry..."
  k3d registry create registry.localhost

  docker kill kyma-dashboard || true
  echo "Running kyma-dashboard with image $DASHBOARD_IMAGE..."
  docker run -d --rm -e DOCKER_DESKTOP_CLUSTER=true --env ENVIRONMENT=prod -p 3001:3001 --name kyma-dashboard "$DASHBOARD_IMAGE"
  }

  echo 'Waiting for deploy_k3d_kyma and build_and_run_busola'
  deploy_k3d
  echo "K3D deployed"
  build_and_run_busola
  echo "Busola deployed. Available under :3001"
}
