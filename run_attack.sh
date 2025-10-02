#!/bin/bash
# run_attack.sh - editar SOLO estas dos variables arriba

# --- EDITA AQUÍ ---
USER="alice"       
MAX_LEN=7          
PY_SCRIPT="attacker_api_cli.py"  
PYTHON_CMD="python3" 
# --------------------

# Comprobaciones mínimas
if [ ! -f "$PY_SCRIPT" ]; then
  echo "Error: no se encontró $PY_SCRIPT en el directorio actual."
  exit 2
fi

# Ejecutar el script pasando los parámetros
exec $PYTHON_CMD "$PY_SCRIPT" "$USER" --max-len "$MAX_LEN"
