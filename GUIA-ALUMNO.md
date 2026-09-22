Lo primero que tienen que hacer desde su Windows es dejar el entorno listo. Yo les daría este orden exacto para evitar líos:

1. Abrir **PowerShell** y comprobar que tienen `winget`:

```powershell
winget --version
```

2. Instalar Git, GitHub CLI y `uv`:

```powershell
winget install --id Git.Git -e
winget install --id GitHub.cli -e
winget install --id astral-sh.uv -e
```

3. Instalar Codex:

```powershell
irm https://chatgpt.com/codex/install.ps1 | iex
```

4. Instalar Orca desde su web y abrirlo al menos una vez.

5. Cerrar PowerShell y abrirlo otra vez. Comprobar:

```powershell
git --version
gh --version
uv --version
codex --version
```

6. Iniciar sesión en GitHub:

```powershell
gh auth login
```

Elegir:

```text
GitHub.com
HTTPS
Login with a web browser
```

7. Iniciar Codex:

```powershell
codex
```

y seleccionar **Sign in with ChatGPT**.

Cuando ya estén autenticados, pueden salir de Codex.

8. Cada uno entra en vuestra instancia:

```text
https://ianegociosocios.openproject.com
```

con el usuario que tú ya les has creado.

En su cuenta:

```text
Ajustes de cuenta
→ Tokens de acceso
→ API token
```

Crear:

```text
codex-workshop
```

y copiarlo. Ese token es personal y **no deben enviártelo ni subirlo a GitHub**.

9. Ahora cada uno crea su repo a partir de tu **Template Repository** en GitHub:

```text
Use this template
→ Create a new repository
```

Podrían poner nombres como:

```text
reformas-project-agent
arquitectura-project-agent
sports-project-agent
videogame-project-agent
```

10. Desde PowerShell clonan su repositorio:

```powershell
cd $HOME
mkdir Projects -ErrorAction SilentlyContinue
cd Projects

gh repo clone SU_USUARIO/NOMBRE_DEL_REPO

cd NOMBRE_DEL_REPO
```

11. Aquí empieza nuestra automatización. Ejecutan:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\setup-workshop.ps1
```

Cuando les pregunte:

```text
Pega tu API token personal de OpenProject:
```

lo introducen.

El script instalará también `openproject-ce-mcp` si todavía no está instalado.

12. Después ejecutan:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\doctor-workshop.ps1
```

Nuestro objetivo es:

```text
Repositorio workshop ........ OK
Git ......................... OK
GitHub CLI .................. OK
GitHub autenticado .......... OK
Codex ....................... OK
Codex autenticado ........... OK
Configuración MCP ........... OK
uv .......................... OK
OpenProject MCP ............. OK
Token OpenProject ........... OK
OpenProject API ............. OK
Agente planner .............. OK
Agente reviewer ............. OK

LISTO PARA EL WORKSHOP
```

13. Finalmente abren **Orca** y añaden el repositorio local:

```text
Add Repo
→ C:\Users\SU_USUARIO\Projects\NOMBRE_DEL_REPO
```

Si Orca estaba abierto cuando ejecutaron `setup-workshop.ps1`, que lo cierren y vuelvan a abrir para que herede la variable del token.

14. Desde Orca abren Codex y la primera prueba será simplemente:

> Comprueba mediante MCP mi conexión con OpenProject. No modifiques nada. Dime qué usuario soy y qué proyectos puedo ver.

Si eso funciona, esa persona está preparada.

Yo pondría en una pantalla/proyector este flujo durante los primeros 20 minutos:

```text
INSTALAR
Git + GitHub CLI + uv + Codex + Orca
        ↓
LOGIN
GitHub + ChatGPT + OpenProject
        ↓
TOKEN
API token personal OpenProject
        ↓
REPO
Use this template
        ↓
CLONE
        ↓
setup-workshop.ps1
        ↓
doctor-workshop.ps1
        ↓
ORCA
        ↓
CODEX
        ↓
OPENPROJECT
```

Y **no empezaría a crear proyectos hasta que todos tengan `LISTO PARA EL WORKSHOP`**. Así empiezan la parte interesante todos desde el mismo punto.
