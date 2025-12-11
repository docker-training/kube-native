#!/bin/bash

# Purpose: Students will run script to "break" something in their Kubernetes cluster

cmd=$1
issue=$2
ns=myapp

# Function to get SSH password from hosts.ini
get_ssh_password() {
  local hosts_file="$HOME/hosts.ini"

  if [[ -f "$hosts_file" ]]; then
    # Extract password from hosts.ini (format: ansible_ssh_pass=PASSWORD)
    grep "ansible_ssh_pass" "$hosts_file" | cut -d'=' -f2
  fi
}

# Function to get IP address for a hostname from hosts.ini
get_host_ip() {
  local hostname=$1
  local hosts_file="$HOME/hosts.ini"

  if [[ -f "$hosts_file" ]]; then
    # Extract IP from hosts.ini (format: hostname ansible_host=IP)
    grep "^${hostname} " "$hosts_file" | awk '{print $2}' | cut -d'=' -f2
  fi
}

# Function to run SSH with password if needed
ssh_exec() {
  local password=$(get_ssh_password)

  if [[ -n "$password" ]] && command -v sshpass >/dev/null 2>&1; then
    sshpass -p "$password" ssh "$@"
  else
    ssh "$@"
  fi
}

# Function to ensure hostname is in /etc/hosts and SSH config
ensure_host_config() {
  local hostname=$1
  local ip=$(get_host_ip "$hostname")

  if [[ -z "$ip" ]]; then
    echo "Warning: Could not find IP for $hostname in ~/hosts.ini"
    return 1
  fi

  # Add to /etc/hosts if not present
  if ! grep -q "$hostname" /etc/hosts 2>/dev/null; then
    echo "$ip $hostname" | sudo tee -a /etc/hosts > /dev/null
  fi

  # Add to known_hosts for SSH
  ssh-keygen -R "$hostname" > /dev/null 2>&1
  ssh-keygen -R "$ip" > /dev/null 2>&1
  ssh-keyscan -t rsa -H "$hostname" 2>/dev/null >> ~/.ssh/known_hosts
  ssh-keyscan -t rsa -H "$ip" 2>/dev/null >> ~/.ssh/known_hosts
}

initial_msg () {

  echo "Breaking something..."
}

lab_setup () {

  echo "Creating lab components..."
  # Creating namespace
  kubectl create namespace $ns

  # Creating components

  cat > temp.yaml <<- "EOF"
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: mysql
  name: mysql
spec:
  containers:
  - env:
    - name: MYSQL_ROOT_PASSWORD
      value: supersecret
    image: mysql:5.6
    name: mysql
    ports:
    - containerPort: 3306
      protocol: TCP

---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  ports:
  - port: 3306
    protocol: TCP
    targetPort: 3306
  selector:
    name: mysql

---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    name: webapp
  name: webapp
spec:
  replicas: 1
  selector:
    matchLabels:
      name: webapp
  template:
    metadata:
      labels:
        name: webapp
      name: webapp
    spec:
      containers:
      - env:
        - name: DB_Host
          value: mysql-service
        - name: DB_User
          value: root
        - name: DB_Password
          value: supersecret
        image: mirantistraining/amazo-app:1.0
        name: webapp
        ports:
        - containerPort: 8080
          protocol: TCP

---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  ports:
  - nodePort: 30081
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    name: webapp
  type: NodePort
EOF

  kubectl -n $ns apply -f temp.yaml
  rm temp.yaml
  sleep 15
  echo "Done!"


}

destroy_ns () {

    echo "Cleaning up lab components. Could take about a minute..."
    kubectl delete namespace $ns
    echo "Done."
}

app_change_svc_label () {

   initial_msg

   cat > temp.yaml <<- "EOF"
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  ports:
  - port: 3306
    protocol: TCP
    targetPort: 3306
  selector:
    name: postgres
EOF

   kubectl -n $ns delete svc mysql-service > /dev/null 2>&1
   kubectl -n $ns create -f temp.yaml > /dev/null 2>&1
   rm temp.yaml
}

app_change_svc_nodeport () {

  initial_msg

  cat > temp.yaml <<- "EOF"
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  ports:
  - nodePort: 30681
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    name: webapp
  type: NodePort
EOF

   kubectl -n $ns delete svc web-service > /dev/null 2>&1
   kubectl -n $ns create -f temp.yaml > /dev/null 2>&1
   rm temp.yaml
}

app_change_env_var_mysql () {

   initial_msg

   cat > temp.yaml <<- "EOF"
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: mysql
  name: mysql
spec:
  containers:
  - env:
    - name: MYSQL_ROOT_PASSWORD
      value: sup3rsecr3t
    image: mysql:5.6
    name: mysql
    ports:
    - containerPort: 3306
      protocol: TCP
EOF

   kubectl -n $ns delete pod mysql > /dev/null 2>&1
   kubectl -n $ns create -f temp.yaml > /dev/null 2>&1
   rm temp.yaml

}

app_change_user () {

  initial_msg

  cat > temp.yaml <<- "EOF"
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    name: webapp
  name: webapp
spec:
  replicas: 1
  selector:
    matchLabels:
      name: webapp
  template:
    metadata:
      labels:
        name: webapp
      name: webapp
    spec:
      containers:
      - env:
        - name: DB_Host
          value: mysql-service
        - name: DB_User
          value: roooot
        - name: DB_Password
          value: supersecret
        image: pghobrial/webapp
        name: webapp
        ports:
        - containerPort: 8080
          protocol: TCP
EOF

  kubectl -n $ns delete deploy webapp > /dev/null 2>&1
  kubectl -n $ns apply -f temp.yaml > /dev/null 2>&1
  rm temp.yaml
}

app_break_combo () {

  initial_msg

  app_change_svc_nodeport
  app_change_env_var_mysql

  cat > temp.yaml <<- "EOF"
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
spec:
  ports:
  - port: 3306
    protocol: TCP
    targetPort: 8080
  selector:
    name: mysql
EOF

  kubectl -n $ns delete svc mysql-service > /dev/null 2>&1
  kubectl -n $ns create -f temp.yaml > /dev/null 2>&1
  rm temp.yaml

}

cluster_break_scheduler () {

  initial_msg
  for node in control0 control1 control2
  do
    ensure_host_config "$node"
    ssh_exec -o StrictHostKeyChecking=no -q $node sudo "sed -i 's/- kube-scheduler/- kube-schedulerrr/' /etc/kubernetes/manifests/kube-scheduler.yaml"
  done

  sleep 15
  kubectl -n $ns scale deploy webapp --replicas 3 > /dev/null
}

cluster_break_controller () {

  initial_msg

  for node in control0 control1 control2
  do
    ensure_host_config "$node"
    ssh_exec -o StrictHostKeyChecking=no -q $node "sudo sed -i 's --kubeconfig=/etc/kubernetes/controller-manager.conf --kubeconfig=/etc/kubernetes/controller-config.conf ' /etc/kubernetes/manifests/kube-controller-manager.yaml"
  done

  sleep 15
  kubectl -n $ns scale deploy webapp --replicas 1 > /dev/null
}

cluster_break_controller2 () {

  initial_msg
  for node in control0 control1 control2
  do
    ensure_host_config "$node"
    ssh_exec -o StrictHostKeyChecking=no -q $node "sudo sed -zi 's /etc/kubernetes/ssl /etc/kubernetes/WRONGDIR 8 ' /etc/kubernetes/manifests/kube-controller-manager.yaml"
  done

  sleep 15
  kubectl create deploy es --image k8s.gcr.io/echoserver:1.4 --replicas 3 > /dev/null

}

node_stop_kubelet () {

  initial_msg
  ensure_host_config "node0"
  ssh_exec -o StrictHostKeyChecking=no -q node0 "sudo systemctl stop kubelet"
  sleep 15
}

node_break_CA () {

  initial_msg
  ensure_host_config "node1"
  ssh_exec -o StrictHostKeyChecking=no -q node1 "sudo sed -i 's/ssl/WRONGDIR/' /etc/kubernetes/kubelet-config.yaml && \
                sudo systemctl daemon-reload && \
                sudo systemctl restart kubelet"
  sleep 25

}

node_break_api () {

  initial_msg
  ensure_host_config "control1"
  ssh_exec -o StrictHostKeyChecking=no -q control1 "sudo sed -i 's/6443/6444/' /etc/kubernetes/kubelet.conf && \
                  sudo systemctl restart kubelet"
  sleep 25
}

network_break_proxy () {

  initial_msg
  kubectl -n kube-system get ds kube-proxy -o yaml > temp.yaml
  sed -i 's/config.conf/configuration.conf/' temp.yaml
  kubectl -n kube-system delete ds kube-proxy > /dev/null
  kubectl -n kube-system apply -f temp.yaml > /dev/null
  rm temp.yaml

  kubectl -n $ns get svc mysql-service -o yaml > temp.yaml
  kubectl -n $ns delete -f temp.yaml > /dev/null
  kubectl -n $ns create -f temp.yaml > /dev/null
  rm temp.yaml

  sleep 15

}

network_remove_coredns () {

  initial_msg

  kubectl delete -f /etc/kubernetes/coredns-deployment.yml > /dev/null
  sleep 15

}

case $cmd:$issue in

    setup:*)
        lab_setup
    ;;

    done:*)
       destroy_ns
    ;;

    app:one)
      app_change_svc_label
    ;;

    app:two)
      app_change_svc_nodeport
    ;;

    app:three)
      app_change_env_var_mysql
    ;;

    app:four)
      app_change_user
    ;;

    app:five)
      app_break_combo
    ;;

    cluster:one)
      cluster_break_scheduler
    ;;

    cluster:two)
      cluster_break_controller
    ;;

    cluster:practice)
      cluster_break_controller2
    ;;

    cluster:three)
      node_stop_kubelet
    ;;

    cluster:four)
      node_break_CA
    ;;

    cluster:five)
      node_break_api
    ;;

    network:one)
      network_break_proxy
    ;;

    network:two)
      network_remove_coredns
    ;;

    *:*)
        echo "Unknown command.  Refer to the student guide for available commands."
    ;;

esac
