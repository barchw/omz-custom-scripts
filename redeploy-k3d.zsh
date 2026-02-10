function redeploy_k3d(){
  echo "Proceed with redeploying k3d cluster (Y/n)?"
  set -x
  read -r answer
  if [[ $answer == "n" || $answer == "N" ]]; then
    echo "Aborting redeploying k3d cluster"
    return
  fi

  k3d cluster delete kyma
  k3d cluster create kyma --port 80:80@loadbalancer \
    --port 443:443@loadbalancer --port 2379:2379 \
    --k3s-arg "--disable=traefik@server:0" --agents 0 \
    --k3s-arg '--tls-san=host.docker.internal@server:0' \
    --k3s-arg "--kubelet-arg=seccomp-default=false@all" \
    --servers-memory=8g --image docker.io/rancher/k3s:v1.33.3-k3s1
}

