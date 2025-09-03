function print_apirule_in_all_versions() {
  local name=${1:-"v1beta1"}
  local namespace=${2:-"httpbin"}

  echo "Printing all versions for APIRule $name in $namespace namespace"

  kubectl get apirules.v1beta1.gateway.kyma-project.io \
    -n $namespace $name -o yaml
  kubectl get apirules.v2alpha1.gateway.kyma-project.io \
    -n $namespace $name -o yaml
  kubectl get apirules.gateway.kyma-project.io \
    -n $namespace $name -o yaml
}
