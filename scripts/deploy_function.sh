#!/usr/bin/env bash
# ==============================================================================
# Script de Despliegue de Cloud Function & Cloud Scheduler (Bash)
# Proyecto: PapaJohnsEC
# ==============================================================================

set -e

PROJECT_ID="papajohnsec"
REGION="us-central1"
FUNCTION_NAME="extract-loyalty-sql-to-bq"
SCHEDULER_JOB_NAME="trigger-extract-loyalty-daily"
SCHEDULE_CRON="0 3 * * *" # Todos los días a las 03:00 AM (America/Guayaquil)

echo "Configurando proyecto activo en gcloud: $PROJECT_ID..."
gcloud config set project "$PROJECT_ID"

echo "Habilitando APIs necesarias..."
gcloud services enable \
    cloudfunctions.googleapis.com \
    cloudbuild.googleapis.com \
    artifactregistry.googleapis.com \
    run.googleapis.com \
    cloudscheduler.googleapis.com \
    bigquery.googleapis.com \
    secretmanager.googleapis.com

echo "Desplegando Cloud Function Gen2 '$FUNCTION_NAME'..."
cd "$(dirname "$0")/../functions/extract_loyalty"

gcloud functions deploy "$FUNCTION_NAME" \
    --gen2 \
    --runtime python311 \
    --region "$REGION" \
    --source . \
    --entry-point sync_loyalty_data \
    --trigger-http \
    --no-allow-unauthenticated \
    --memory 1024MB \
    --timeout 540s \
    --set-env-vars GCP_PROJECT_ID="$PROJECT_ID",BQ_DATASET_ID="papajohns_loyalty_ec",SQL_SERVER="192.168.20.68",SQL_PORT="1433",SQL_DATABASE="SBPAPAJOHNS",SQL_USER="upapajohns",SQL_PASSWORD="Pla!npart17"

FUNCTION_URI=$(gcloud functions describe "$FUNCTION_NAME" --region "$REGION" --format='value(serviceConfig.uri)')
echo "URI obtenida: $FUNCTION_URI"

echo "Configurando Cloud Scheduler '$SCHEDULER_JOB_NAME'..."
gcloud scheduler jobs create http "$SCHEDULER_JOB_NAME" \
    --location "$REGION" \
    --schedule "$SCHEDULE_CRON" \
    --time-zone "America/Guayaquil" \
    --uri "$FUNCTION_URI" \
    --http-method POST \
    --oidc-service-account-email "${PROJECT_ID}@appspot.gserviceaccount.com" \
    --message-body '{"mode":"WRITE_TRUNCATE"}'

echo "Despliegue y programación completados exitosamente."
