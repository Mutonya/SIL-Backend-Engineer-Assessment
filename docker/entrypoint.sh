#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

echo "=== Debugging Information ==="
echo "Python path: $PYTHONPATH"
echo "App directory contents:"
ls -la /app/apps
echo "============================"

python docker/wait_for_db.py
python manage.py migrate
exec "$@"