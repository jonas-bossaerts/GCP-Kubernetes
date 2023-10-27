#!/bin/bash
echo "Deploy Elasticsearch"
echo "========================"
kubectl apply -f namespace.yaml
kubectl apply -f es-master.yaml
kubectl apply -f es-data.yaml
kubectl apply -f es-client-configmap.yaml
kubectl apply -f es-client.yaml
kubectl get all -n es
#kubectl exec -it $(kubectl get pods -n es | grep es-client | sed -n 1p | awk '{print $1}') -n es -- bin/elasticsearch-setup-passwords auto -b
# vul hier het passwoord in dat door het vorige commando aangemaakt wordt
# kubectl create secret generic es-pw-elastic -n es --from-literal password=Vds4wsbzfMqaIZ5m3nIE
# kubectl apply -f kibana.yaml
# kubectl get all -n es
# als je alles opnieuw opstart, niet vergeten het wachtwoord in deze file aan te passen
## kubectl apply -f analytics.yaml

# dit enkel doen als de cluster voor de eerste keer wordt aangemaakt
## kubectl create secret docker-registry kibana-secret --docker-server=registry.gitlab.com --namespace es --docker-username=gitlab+deploy-token-677637 --docker-password=kpdUm2dgx5WCnJaXq2RW

