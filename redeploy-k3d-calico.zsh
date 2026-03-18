function redeploy_k3d_calico(){
  source common.sh

  echo "Proceed with redeploying k3d cluster (Y/n)?"
  set -x
  read -r answer
  if [[ $answer == "n" || $answer == "N" ]]; then
    echo "Aborting redeploying k3d cluster"
    return
  fi

  k3d cluster delete kyma
  k3d cluster create kyma --port 80:80@loadbalancer \
    --port 443:443@loadbalancer \
    --k3s-arg "--flannel-backend=none@all" \
    --k3s-arg "--disable=traefik@server:0" \
    --k3s-arg '--tls-san=host.docker.internal@server:*'
  log_header "Installing Calico CNI"

  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.3/manifests/operator-crds.yaml
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.3/manifests/tigera-operator.yaml
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.3/manifests/custom-resources.yaml

  # Wait until CoreDNS is ready
  kubectl rollout status -n kube-system deployment coredns

  # Patch the CNI config to make sure it is set up same as with the default Flannel backend
  kubectl patch installation default --type=merge -p '{"spec":{"cni":{"binDir":"/var/lib/rancher/k3s/data/cni", "confDir":"/var/lib/rancher/k3s/agent/etc/cni/net.d"}}}'
}

