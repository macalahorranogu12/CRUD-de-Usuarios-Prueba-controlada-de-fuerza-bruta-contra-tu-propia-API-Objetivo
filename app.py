from fastapi import FastAPI, HTTPException

app = FastAPI()

USERS = []
NEXT_ID = 1

# Crear usuario
@app.post("/users")
def create_user(payload: dict):
    global NEXT_ID
    if not payload.get("username") or "password" not in payload:
        raise HTTPException(400, "username y password obligatorios")
    for u in USERS:
        if u["username"] == payload["username"]:
            raise HTTPException(400, "Username exists")
    u = {"id": NEXT_ID, "username": payload["username"], "password": payload["password"],
         "email": payload.get("email"), "is_active": True}
    USERS.append(u)
    NEXT_ID += 1
    return {"id": u["id"], "username": u["username"], "email": u["email"], "is_active": u["is_active"]}

# Listar usuarios
@app.get("/users")
def list_users():
    return [{"id": u["id"], "username": u["username"], "email": u["email"], "is_active": u["is_active"]} for u in USERS]

# Obtener usuario por id
@app.get("/users/{user_id}")
def get_user(user_id: int):
    for u in USERS:
        if u["id"] == user_id:
            return {"id": u["id"], "username": u["username"], "email": u["email"], "is_active": u["is_active"]}
    raise HTTPException(404, "Not found")

# Actualizar usuario (excepto password)
@app.put("/users/{user_id}")
def update_user(user_id: int, payload: dict):
    for u in USERS:
        if u["id"] == user_id:
            new_username = payload.get("username")
            if new_username and new_username != u["username"]:
                for other in USERS:
                    if other["username"] == new_username:
                        raise HTTPException(400, "Username exists")
                u["username"] = new_username
            if "email" in payload: u["email"] = payload.get("email")
            if "is_active" in payload: u["is_active"] = bool(payload.get("is_active"))
            return {"id": u["id"], "username": u["username"], "email": u["email"], "is_active": u["is_active"]}
    raise HTTPException(404, "Not found")

# Eliminar usuario
@app.delete("/users/{user_id}")
def delete_user(user_id: int):
    for i, u in enumerate(USERS):
        if u["id"] == user_id:
            USERS.pop(i)
            return {"detail": "deleted"}
    raise HTTPException(404, "Not found")

# Login
@app.post("/login")
def login(payload: dict):
    if not payload.get("username") or "password" not in payload:
        raise HTTPException(400, "username y password obligatorios")
    for u in USERS:
        if u["username"] == payload["username"] and u["password"] == payload["password"]:
            if not u["is_active"]:
                raise HTTPException(403, "Cuenta inactiva")
            return {"message": f"Bienvenido {u['username']}"}
    raise HTTPException(401, "Usuario o contraseña incorrectos")
