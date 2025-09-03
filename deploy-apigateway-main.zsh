function upgrade_apigateway_to_main(){
  echo "Building and deploying api-gateway from kyma/main branch"

  pushd ~/GolandProjects/api-gateway
  git checkout kyma/main
  IMG=api-gateway:main make docker-build
  k3d image import api-gateway:main -c kyma
  IMG=api-gateway:main make deploy
  sleep 30
  popd
}
