 #!/bin/sh

echo Start

. ./scripts/load_azd_env.sh

# if [ -z "$AZURE_USE_AUTHENTICATION" ]; then
#   exit 0
# fi

. ./scripts/load_python_env.sh

./scripts/.venv/bin/python ./scripts/blob_update.py --appid "$AUTH_APP_ID" --uri "$BACKEND_URI"
