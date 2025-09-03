function delete_k3d(){
  echo "Proceed with deletion of k3d cluster (Y/n)?"
  read -r answer
  if [[ $answer == "n" || $answer == "N" ]]; then
    echo "Aborting redeploying k3d cluster"
    return
  fi

  k3d cluster delete kyma
}
