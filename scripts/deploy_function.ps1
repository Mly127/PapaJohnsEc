# ==============================================================================
# Script de Despliegue de Cloud Function & Cloud Scheduler (PowerShell)
# Proyecto: PapaJohnsEC
# ==============================================================================

$PROJECT_ID = "papajohnsec"
$REGION = "us-central1"
$FUNCTION_NAME = "extract-loyalty-sql-to-bq"
$SCHEDULER_JOB_NAME = "trigger-extract-loyalty-daily"
$SCHEDULE_CRON = "0 3 * * *" # Todos los días a las 03:00 AM (Hora local / UTC)

Write-Host "Configurando proyecto activo en gcloud..." -ForegroundColor Cyan
gcloud config set project $PROJECT_ID

Write-Host "Habilitando APIs requeridas de GCP..." -ForegroundColor Cyan
gcloud services enable `
    cloudfunctions.googleapis.com `
    cloudbuild.googleapis.com `
    artifactregistry.googleapis.com `
    run.googleapis.com `
    cloudscheduler.googleapis.com `
    bigquery.googleapis.com `
    secretmanager.googleapis.com

Write-Host "Desplegando Cloud Function Gen2 '$FUNCTION_NAME'..." -ForegroundColor Cyan
cd C:\Repositorios\PapaJohnsEc\functions\extract_loyalty

gcloud functions deploy $FUNCTION_NAME `
    --gen2 `
    --runtime python311 `
    --region $REGION `
    --source . `
    --entry-point sync_loyalty_data `
    --trigger-http `
    --no-allow-unauthenticated `
    --memory 1024MB `
    --timeout 540s `
    --set-env-vars GCP_PROJECT_ID=$PROJECT_ID,BQ_DATASET_ID=papajohns_loyalty_ec,SQL_SERVER=192.168.20.68,SQL_PORT=1433,SQL_DATABASE=SBPAPAJOHNS,SQL_USER=upapajohns,SQL_PASSWORD=Pla!npart17

Write-Host "Obteniendo URI de la Cloud Function..." -ForegroundColor Cyan
$FUNCTION_URI = (gcloud functions describe $FUNCTION_NAME --region $REGION --format='value(serviceConfig.uri)')
Write-Host "URI: $FUNCTION_URI" -ForegroundColor Green

Write-Host "Configurando Cloud Scheduler '$SCHEDULER_JOB_NAME' con cron '$SCHEDULE_CRON'..." -ForegroundColor Cyan
gcloud scheduler jobs create http $SCHEDULER_JOB_NAME `
    --location $REGION `
    --schedule "$SCHEDULE_CRON" `
    --time-zone "America/Guayaquil" `
    --uri "$FUNCTION_URI" `
    --http-method POST `
    --oidc-service-account-email "$PROJECT_ID@appspot.gserviceaccount.com" `
    --message-body '{"mode":"WRITE_TRUNCATE"}'

Write-Host "Despliegue y programación completados con éxito." -ForegroundColor Green
