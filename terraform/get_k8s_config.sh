#!/bin/bash

WS=$(terraform workspace show)
IPK8S=$(terraform output -json control_plane_public_ip | jq -j)

echo -e "\n##################################################################"
echo -e "# Копируем .kube/config с ControlPlane на локальную машину для использования с kubectl"
echo -e "####################################################################\n"
ssh -o "StrictHostKeyChecking no" etozhemikhail@$IPK8S -i ~/.ssh/id_rsa "sudo cp /root/.kube/config /home/etozhemikhail/config; sudo chown etozhemikhail /home/etozhemikhail/config"
rm -rf /home/etozhemikhail/.kube/config.$WS
scp -i ~/.ssh/yc/yc etozhemikhail@$IPK8S:/home/etozhemikhail/config "/home/etozhemikhail/.kube/config.${WS}"
sed -i "s/lb-apiserver.kubernetes.local/${IPK8S}/g" "/home/etozhemikhail/.kube/config.${WS}"
#sed -i "s/cluster.local/${WS}.k8s.yc/g" "/home/etozhemikhail/.kube/config.${WS}"
cp "/home/etozhemikhail/.kube/config.${WS}" "/home/etozhemikhail/.kube/config"
export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config.$WS
