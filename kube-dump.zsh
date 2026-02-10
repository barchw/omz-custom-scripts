function kube_dump() {
  set -x
  local destination=${1:-./dump}
  local namespace=${2}

  PATH="$(brew --prefix)/opt/gnu-getopt/bin:$PATH"

  mkdir -p $1
  if [[ "$namespace" != "" ]]; then
      kube-dump \
      dump -n $2 -d $1
  else
      kube-dump \
      dump -d $1
  fi
}

