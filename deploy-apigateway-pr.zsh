function deploy_apigateway_from_pr() {
  local pr=${1:-1777}
  echo "Building and deploying api-gateway from PR #$pr"

  pushd ~/GolandProjects/api-gateway
  gh pr checkout $pr
  IMG=api-gateway:PR-$pr make docker-build
  k3d image import api-gateway:PR-$pr -c kyma
  IMG=api-gateway:PR-$pr make deploy
  sleep 30
  popd
}
