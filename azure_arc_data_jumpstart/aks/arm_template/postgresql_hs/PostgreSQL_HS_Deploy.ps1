Start-Transcript -Path C:\tmp\mssql_deploy.log

# Deploying Azure Arc Data Controller
start Powershell {kubectl get pods -n $env:ARC_DC_NAME -w}
azdata arc dc create -c azure-arc-aks-private-preview --namespace $env:ARC_DC_NAME --name $env:ARC_DC_NAME --subscription $env:ARC_DC_SUBSCRIPTION --resource-group $env:resourceGroup --location $env:ARC_DC_REGION --connectivity-mode indirect

# Deploying Azure Arc SQL Managed Instance
azdata login -n $env:ARC_DC_NAME
azdata postgres server create -n $env:POSTGRES_HS_NAME -ns $env:POSTGRES_HS_NAMESPACE -w $env:POSTGRES_HS_WORKER_NODE_COUNT --dataSizeMb $env:POSTGRES_HS_DATASIZE --serviceType $env:POSTGRES_HS_SERVICE_TYPE --subscription $env:ARC_DC_SUBSCRIPTION --resource-group $env:resourceGroup
azdata postgres server list -ns $env:POSTGRES_HS_NAMESPACE

# Cleaning MSSQL Instance connectivity details
Start-Process powershell -ArgumentList "C:\tmp\sql_connectivity.ps1" -WindowStyle Hidden -Wait

Stop-Transcript

# Starting Azure Data Studio
Start-Process -FilePath "C:\Program Files\Azure Data Studio - Insiders\azuredatastudio-insiders.exe" -WindowStyle Maximized
Stop-Process -Name kubectl -Force
Stop-Process -name powershell -Force
