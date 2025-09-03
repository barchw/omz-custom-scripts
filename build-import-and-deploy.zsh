function build_import_and_deploy(){
  echo "Building image $1 importing to k3d and deploying"

  IMG=$1 make docker-build
  k3d image import $1 -c kyma
  IMG=$1 make deploy
}
