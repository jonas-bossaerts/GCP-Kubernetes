Write-Host "Start van deployment"
Write-Host "Connecteren met de cluster"
gcloud container clusters get-credentials monopoly-cluster-prod --region europe-west1 --project monopoly-332608
if ($?){
    Write-Host "Connectie geslaagd!" -ForegroundColor Green
}
else {
    Write-Host "Connectie gefaald, kijk zeker na of deze up en running is!" -ForegroundColor Red
}

Write-Host "Starten van yaml files"
if ($args[0] -eq "-d"){
Write-Host "Deleting backend & frontend services & deployment" -ForegroundColor Yellow
kubectl delete -f yaml/frontend.yaml
Write-Host "Deletion of backend & frontend services & deployment completed" -ForegroundColor Green

Write-Host "Deleting ingress service" -ForegroundColor Yellow
kubectl delete -f yaml/ingress.yaml
Write-Host "Deletion of ingress service completed" -ForegroundColor Green

#Write-Host "Deleting horizontal scaler for all services" -ForegroundColor Yellow
#kubectl delete -f yaml/scaler.yaml
#Write-Host "Deletion of horizontal scaler for all services completed" -ForegroundColor Green

Write-Host "Deleting frontendconfig" -ForegroundColor Yellow
kubectl delete -f yaml/frontendconfig.yaml
Write-Host "Deletion of frontendconfig completed" -ForegroundColor Green

Write-Host "Deleting managed certificate" -ForegroundColor Yellow
kubectl delete -f yaml/managed-cert.yaml
Write-Host "Deletion of managed certificate completed" -ForegroundColor Green

Write-Host "Deleting MySql" -ForegroundColor Yellow
kubectl delete -f yaml/mysql.yaml
Write-Host "Deletion of MySql completed" -ForegroundColor Green

}
else{
    Write-Host "Secretkey aanmaken"
    kubectl create secret docker-registry secretkey --docker-server=registry.gitlab.com --docker-username=gitlab+deploy-token-677637 --docker-password=kpdUm2dgx5WCnJaXq2RW
    if ($?){
        Write-Host "Secretkey aangemaakt!" -ForegroundColor Green
    }
    else {
        Write-Host "Secretkey is reeds al aangemaakt." -ForegroundColor Red
    }
    Write-Host "Creating MySql" -ForegroundColor Yellow
    kubectl apply -f yaml/mysql.yaml
    Write-Host "Creation of MySql completed" -ForegroundColor Green

    Write-Host "Creating backend & frontend services & deployment" -ForegroundColor Yellow
    kubectl apply -f yaml/frontend.yaml
    Write-Host "Creation of backend & frontend services & deployment completed" -ForegroundColor Green
    
    Write-Host "Creating ingress service" -ForegroundColor Yellow
    kubectl apply -f yaml/ingress.yaml
    Write-Host "Creation of ingress service completed" -ForegroundColor Green

    #Write-Host "Creating horizontal scaler for all services" -ForegroundColor Yellow
    #kubectl apply -f yaml/scaler.yaml
    #Write-Host "Creation of horizontal scaler for all services completed" -ForegroundColor Green

    Write-Host "Creating backendconfig" -ForegroundColor Yellow
    kubectl apply -f yaml/backend-config.yaml
    Write-Host "Creation of backendconfig completed" -ForegroundColor Green

    Write-Host "Creating frontendconfig" -ForegroundColor Yellow
    kubectl apply -f yaml/frontendconfig.yaml
    Write-Host "Creation of frontendconfig completed" -ForegroundColor Green

    Write-Host "Creating managed certificate" -ForegroundColor Yellow
    kubectl apply -f yaml/managed-cert.yaml
    Write-Host "Creation of managed certificate completed" -ForegroundColor Green
}


