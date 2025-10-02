Hice una API pequeña con FastAPI que guarda usuarios en una lista en memoria. Cada usuario tiene id, username, password, email y is_active. También escribí un script para hacer un ataque de fuerza bruta controlado contra el endpoint /login. La idea fue crear un entorno de prueba: crear usuarios desde la propia página de la API y luego, si la contraseña está en el archivo passwords.txt, el script la encontrará y registrará los intentos.

 Por qué funciona así

La API recibe JSON en los endpoints y responde JSON. POST /users crea usuarios y guarda la contraseña tal cual en texto para mantenerlo simple. POST /login compara el username y password y devuelve un mensaje si coincide. El script de brute force lee contraseñas de passwords.txt, intenta cada una contra /login y guarda tiempos y códigos en results.csv.

 Cómo usarlo, pasos lógicos

Abrir la carpeta del proyecto en VS Code.

Crear y activar un entorno virtual.

Instalar FastAPI y uvicorn.

Ejecutar la API y dejarla corriendo.

Crear usuarios desde http://127.0.0.1:8000/docs
 usando POST /users.

En otra terminal ejecutar el script de fuerza bruta apuntando al usuario que creaste.

Revisar results.csv para ver intentos y si hubo éxito.

 Comandos exactos

Preparar entorno en VS Code terminal usando PowerShell

cd C:\Users\marti\Desktop\ExamenPractico2
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install fastapi uvicorn


Arrancar la API y dejar la terminal abierta

python -m uvicorn app:app --reload --host 127.0.0.1 --port 8000


Crear usuario desde la interfaz
Abrir en el navegador la dirección
http://127.0.0.1:8000/docs

Ir a POST /users, activar Try it out, poner JSON con username password email y ejecutar Execute

Probar login manual desde PowerShell

$body = @{ username="user1"; password="pass1" } | ConvertTo-Json
Invoke-RestMethod -Uri "http://127.0.0.1:8000/login" -Method Post -Body $body -ContentType "application/json"


Ejecutar brute force usando Git Bash en otra terminal

cd /c/Users/marti/Desktop/ExamenPractico2
chmod +x brute_force.sh
./brute_force.sh http://127.0.0.1:8000 user1 passwords.txt 0.5


Ejecutar brute force usando PowerShell con el script ps1

cd C:\Users\marti\Desktop\ExamenPractico2
& .\brute_force.ps1 -ApiUrl "http://127.0.0.1:8000" -User "user1" -PwFile "passwords.txt" -Delay 0.5


Ver resultados

Get-Content results.csv -Tail 20
