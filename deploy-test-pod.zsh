function create_test_deployment(){
  echo "Creating a deployment for testing in ns $1"
  cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: $1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: app
        image: nginx
        command: ["sleep"]
        args: ["infinity"]
EOF
}
