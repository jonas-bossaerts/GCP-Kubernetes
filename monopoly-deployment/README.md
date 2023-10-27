# monopoly.deployment

All the deployment files will be stored here.

## Terraform
Om ons cluster op Google Cloud te starten beginnen we met ons te navigeren naar de TerraformV2 map en hierin gaan we volgende commando's uitvoeren om te starten.

Als dit je eerste keer is dat je terraform wilt opstarten, start je best met:
```
terraform init
```

Hierna gaan we onze terraform laten starten met:
```
terraform apply
```
Hierna gaat die alles controleren en uiteindelijk typen we yes in om terraform te starten.

Als je uiteindelijk alles terug wilt down halen van cluster moet je:
```
terraform destroy
```
Hierna gaan we weer op het einde yes typen.

## Deployment microservices with yaml
Voor het deployen, connecteren en een secret key aan te maken hebben wij een script voorzien voor alles eenvoudiger te maken en automatiseren. Dit script wordt opgestart met ./script-ps1, je kan ook parameter -d meegeven als je alles wilt verwijderen van Google Cloud.
```
./script-ps1 (-d)
```

Wij maken voor elke microservice een workload die kan autoscalen (met als uitzondering de mysql pods) en een service waar enkel de UI en gateway een nodeport service zijn en al de andere ClusterIP. 

Wij hebben ook een static IP meegegeven aan onze ingress die gekoppeld staat aan volgend domein: (www.)monopoly-ip.be.

## Kibana
Om Kibana te starten ga je een werkende kuberenetes cluster nodig hebben van het type "e2-standard-4"
Je gaat ook een linux omgeving nodig hebben, aangezien sommige commando's linux bash zijn. 
In de file deploy.sh in de map "Kibana" vindt je een script om de elasticsearch op te starten. 
Hierin staan ook een aantal commando's die in commentaar zijn geplaatst. Dit komt omdat je deze achteraf manueel moet uitvoeren. 


Als je voor de eerste keer gebruik maakt van de cluster, voer je dit commando uit. Dit zorgt ervoor dat je de image kan pullen van de private container registry:
```
kubectl create secret docker-registry kibana-secret --docker-server=registry.gitlab.com --namespace es --docker-username=gitlab+deploy-token-677637 --docker-password=kpdUm2dgx5WCnJaXq2RW
``` 

deploy.sh uitvoeren:
```
sudo ./deploy.sh
```
Hierna gaan we het paswoord voor de elastic user genereren. Bij het tweede commando geef je het paswoord dat gegenereerd is mee als variabelen:
```
kubectl exec -it $(kubectl get pods -n es | grep es-client | sed -n 1p | awk '{print $1}') -n es -- bin/elasticsearch-setup-passwords auto -b
kubectl create secret generic es-pw-elastic -n es --from-literal password=....
```
Hierna start je de kibana op:
```
kubectl apply -f kibana.yaml
```
Als laatste starten we de microservice op: 
```
kubectl apply -f analytics.yaml
```
### kubectl commando's
Handige commando's die je kan gebruiken
```
# handig om alle pods, services, deployments van de namespace te bekijken (es is de namespace die we gebruiken voor de elasticsearch en kibana)
kubectl get all -n es

