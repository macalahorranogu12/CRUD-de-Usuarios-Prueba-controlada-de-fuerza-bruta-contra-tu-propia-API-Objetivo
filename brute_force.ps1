
USER="alice"       
MAX_LEN=7          
PY_SCRIPT="attacker_api_cli.py"  
PYTHON_CMD="python3" 

if [ ! -f "$PY_SCRIPT" ]; then
  echo "Error: no se encontró $PY_SCRIPT en el directorio actual."
  exit 2
fi

exec $PYTHON_CMD "$PY_SCRIPT" "$USER" --max-len "$MAX_LEN"


