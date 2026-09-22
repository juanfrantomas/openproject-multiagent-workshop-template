

# 1. Guía del instructor

## Objetivo del workshop

Que cada participante termine con:

* un proyecto real creado hablando con Codex;
* fases, hitos, tareas y dependencias en OpenProject;
* un Gantt operativo;
* 2–4 agentes personalizados para su sector;
* una ejecución multiagente en paralelo;
* una revisión independiente con `reviewer`;
* una replanificación provocada por un cambio inesperado.

La idea central que puedes repetir durante el taller es:

> **No estamos usando IA solo para responder preguntas. Estamos construyendo un equipo de agentes que opera sobre un sistema real de gestión de proyectos.**

---

## Arquitectura que enseñarás

```text
Persona
   ↓
Orca
   ↓
Codex — Project Manager
   │
   ├── planner
   ├── reviewer
   └── agentes especializados
   ↓
OpenProject CE MCP
   ↓
OpenProject Cloud
```

Cada participante tiene:

```text
Cuenta ChatGPT/Codex propia
Cuenta GitHub propia
Usuario OpenProject propio
API token OpenProject propio
Repositorio GitHub propio
Agentes propios
Proyecto OpenProject propio
```

---

## 00:00–00:20 — Puesta en marcha

Objetivo: que todos lleguen a:

```text
doctor-workshop.ps1
→ LISTO PARA EL WORKSHOP
```

Orden:

```powershell
git --version
gh --version
codex --version
uv --version
openproject-ce-mcp --version
```

Después:

```powershell
.\scripts\setup-workshop.ps1
```

Y:

```powershell
.\scripts\doctor-workshop.ps1
```

Comprueba especialmente:

```text
GitHub autenticado ........ OK
Codex autenticado ......... OK
OpenProject MCP ........... OK
Token OpenProject ......... OK
OpenProject API ........... OK
planner ................... OK
reviewer .................. OK
```

Si alguien falla, no detengas al grupo entero. Corrige su máquina mientras los demás avanzan con la definición del proyecto.

---

# 00:20–00:30 — Explicación conceptual

No entres todavía en TOML, MCP ni detalles técnicos.

Explícales:

```text
OpenProject
= estado real del proyecto

Codex
= Project Manager

Agentes
= especialistas

MCP
= puente entre Codex y OpenProject
```

Y una regla fundamental:

> Los agentes pueden analizar en paralelo, pero el Project Manager principal consolida los resultados y realiza las modificaciones en OpenProject.

Esto evita conflictos entre agentes.

---

# 00:30–00:50 — Crear el proyecto

Cada participante debe escoger un proyecto real.

Prompt común:

> Quiero crear un proyecto real.
>
> Hazme una entrevista breve para conocer:
>
> * objetivo;
> * criterios de éxito;
> * alcance;
> * qué queda fuera;
> * fecha objetivo;
> * presupuesto;
> * restricciones;
> * personas implicadas;
> * riesgos conocidos.
>
> No crees nada todavía.
>
> Cuando tengas información suficiente, presenta una propuesta de definición del proyecto.

Cuando estén conformes:

> Apruebo esta definición.
>
> Crea el proyecto en OpenProject.
>
> Después verifica que se haya creado correctamente.
>
> No crees todavía una WBS detallada.

Haz que todos entren en OpenProject y vean físicamente su proyecto.

Ese es el primer momento importante.

---

# 00:50–01:10 — Construir la primera planificación

Prompt:

> Utiliza `planner` para proponer una WBS inicial.
>
> Quiero una estructura manejable, no burocrática.
>
> Propón:
>
> * fases;
> * hitos verificables;
> * tareas principales;
> * dependencias lógicas reales.
>
> No modifiques todavía OpenProject.

Después de revisar:

> Apruebo esta estructura.
>
> Créala en OpenProject.
>
> Usa preview antes de las escrituras y verifica después:
>
> * jerarquía;
> * hitos;
> * dependencias;
> * duplicados.

Ahora todos deben abrir:

**OpenProject → Gantt**

Haz que observen la relación:

```text
conversación
   ↓
estructura del proyecto
   ↓
tareas reales
   ↓
Gantt
```

---

# 01:10–01:35 — Crear agentes propios

Ahora llega una de las partes principales.

Explícales que un buen agente no es simplemente:

> “Eres experto en X”.

Tiene que definir:

```text
Responsabilidad
Entradas
Salidas
Límites
Criterios
Evidencia
```

Prompt común:

> Quiero crear tres agentes especializados para este proyecto.
>
> Ayúdame a definirlos.
>
> Cada agente debe:
>
> * tener una responsabilidad distinta;
> * evitar solaparse con los demás;
> * especificar qué debe analizar;
> * especificar qué resultado debe devolver;
> * declarar incertidumbre;
> * no modificar OpenProject directamente.
>
> Primero propón los agentes.
> No crees todavía los archivos.

Ejemplos:

| Perfil       | Agentes                                                        |
| ------------ | -------------------------------------------------------------- |
| Reformas     | `site_manager`, `cost_estimator`, `procurement`                |
| Arquitectura | `brief_analyst`, `regulatory_researcher`, `design_coordinator` |
| Deportes     | `event_manager`, `operations`, `marketing`                     |
| Videojuegos  | `producer`, `game_designer`, `technical_planner`               |
| Tú           | `workshop_manager`, `infrastructure`, `participant_experience` |

Después:

> Créame ahora los archivos de esos agentes dentro de `.codex/agents/`.

Que los abran en Orca y lean/modifiquen alguno manualmente.

La idea educativa es que entiendan que **los agentes son configuración editable, no magia oculta**.

---

# 01:35–01:55 — Ejecución multiagente

Prompt común:

> Analiza mi proyecto utilizando en paralelo:
>
> * `planner`;
> * mis tres agentes especializados.
>
> Asigna a cada agente una responsabilidad distinta y sin solapamientos.
>
> No modifiquéis OpenProject.
>
> Espera a que terminen todos.
>
> Consolida después sus resultados.

En Orca deberían observar:

```text
Project Manager
├── planner
├── especialista 1
├── especialista 2
└── especialista 3
```

Después:

> Ahora utiliza `reviewer` para criticar la propuesta consolidada.
>
> Busca:
>
> * incoherencias;
> * trabajo que falta;
> * dependencias cuestionables;
> * riesgos;
> * supuestos sin justificar.
>
> No cambies nada todavía.

Esta es la demostración clara del patrón:

```text
generación
   ↓
especialización
   ↓
consolidación
   ↓
revisión independiente
```

---

# 01:55–02:20 — Cambio sorpresa

No se lo anuncies con demasiada antelación.

Entrégale a cada uno su cambio.

Primero deben utilizar:

> Acaba de ocurrir este cambio:
>
> [CAMBIO]
>
> No modifiques todavía el proyecto.
>
> Usa varios agentes en paralelo para analizar:
>
> * impacto en alcance;
> * impacto temporal;
> * impacto económico;
> * tareas afectadas;
> * dependencias afectadas;
> * riesgos nuevos;
> * alternativas.
>
> Devuélveme varias opciones.

Después deberán escoger una alternativa.

Entonces:

> Apruebo la opción X.
>
> Replanifica OpenProject exactamente según esa opción.
>
> Verifica el resultado.

Y vuelven a mirar el Gantt.

Este es probablemente el momento más fuerte del taller:

```text
situación inicial
      ↓
cambio real
      ↓
análisis multiagente
      ↓
decisión humana
      ↓
replanificación
      ↓
Gantt actualizado
```

---

# 02:20–02:35 — Contexto, Wiki e imágenes

Haz una demostración rápida.

En la Wiki pueden registrar:

```text
Objetivo
Requisitos
Restricciones
Decisiones
Preguntas abiertas
```

Explícales:

```text
Work Packages
→ qué estamos haciendo

Wiki
→ qué sabemos

Comentarios
→ qué ha ocurrido

Gantt
→ cuándo y en qué orden

Agentes
→ quién razona sobre todo ello
```

Si tienes una imagen preparada, pásala a Codex:

> Analiza esta imagen como evidencia del proyecto y compárala con el estado actual de OpenProject. No conviertas interpretaciones inciertas en hechos.

Esto introduce multimodalidad sin complicar demasiado el taller.

---

# 02:35–03:00 — Show & Tell

Cada participante tiene aproximadamente 4 minutos.

Debe enseñar:

1. Proyecto.
2. Gantt.
3. Agentes que creó.
4. Qué agentes ejecutó simultáneamente.
5. Qué detectó `reviewer`.
6. Qué cambio sorpresa recibió.
7. Cómo cambió el proyecto después.

Termina comparando cómo diferentes profesiones han construido **arquitecturas de agentes distintas usando exactamente la misma plataforma**.

---

# 2. Hoja rápida para participantes

Puedes meter directamente este contenido en `QUICKSTART.md`.

## OpenProject + Codex Multi-Agent Workshop

### Arquitectura

```text
Tú
 ↓
Codex Project Manager
 ↓
Agentes especializados
 ↓
OpenProject MCP
 ↓
OpenProject
```

### Comprobar entorno

Desde PowerShell, en el repositorio:

```powershell
.\scripts\doctor-workshop.ps1
```

Debe terminar con:

```text
LISTO PARA EL WORKSHOP
```

### Abrir Codex

Puedes utilizar Orca.

Fallback desde PowerShell:

```powershell
.\scripts\codex-workshop.ps1
```

### Crear tu proyecto

Copia:

> Quiero crear un proyecto real.
>
> Hazme una entrevista breve para entender objetivo, criterios de éxito, alcance, exclusiones, fecha, presupuesto, restricciones, personas implicadas y riesgos.
>
> No crees nada todavía.
>
> Primero presenta una definición del proyecto.

Después:

> Apruebo la definición. Crea el proyecto en OpenProject y verifica el resultado.

### Crear la planificación

> Utiliza `planner` para diseñar una WBS inicial con fases, hitos, tareas y dependencias lógicas reales.
>
> No modifiques todavía OpenProject.

Cuando estés de acuerdo:

> Apruebo la propuesta. Aplícala en OpenProject y verifica el resultado.

Después abre **Gantt**.

### Crear tus agentes

> Quiero tres agentes especializados relacionados con mi profesión y este proyecto.
>
> Cada uno debe tener una responsabilidad diferente y límites claros.
>
> Primero propón cuáles serían.

Después:

> Créame sus archivos en `.codex/agents/`.

Puedes abrir y modificar esos archivos desde Orca.

### Ejecutar varios agentes

> Ejecuta `planner` y mis agentes especializados en paralelo.
>
> Da a cada uno una responsabilidad distinta.
>
> No modifiquéis OpenProject.
>
> Espera a todos y consolida los resultados.

Después:

> Pide a `reviewer` que audite la propuesta consolidada.

### Aplicar una propuesta

> Apruebo esta propuesta.
>
> Aplícala mediante MCP.
>
> Utiliza siempre preview antes de confirmar las escrituras y verifica después el resultado.

### Cambio de requisitos

> Ha ocurrido este cambio:
>
> [explicar cambio]
>
> No modifiques nada todavía.
>
> Analiza el impacto utilizando varios agentes en paralelo y propón alternativas.

### Reglas importantes

```text
✓ OpenProject = fuente de verdad
✓ Los agentes pueden equivocarse
✓ Diferencia hechos de supuestos
✓ Primero analizar
✓ Después decidir
✓ Después ejecutar
✓ Finalmente verificar

✗ No inventar costes reales
✗ No borrar sin autorización explícita
✗ No hacer trabajar varios agentes sobre la misma entidad simultáneamente
✗ No aceptar una propuesta solo porque la haya escrito una IA
```

---

# 3. Los cinco cambios sorpresa

Los haría deliberadamente diferentes para provocar distintos tipos de razonamiento.

## Sorpresa 1 — Empresa de reformas

Entrégale esto:

> **CAMBIO DEL CLIENTE**
>
> El cliente acaba de comunicar que el presupuesto máximo se reduce un **25 %**, pero quiere mantener la fecha de finalización.
>
> Además, el baño y la cocina siguen siendo obligatorios y no pueden eliminarse del alcance.
>
> Analiza el impacto antes de modificar nada.

Agentes ideales:

```text
cost_estimator
planner
procurement
site_manager
reviewer
```

Lo interesante es comprobar si detectan que existen tres variables:

```text
scope
coste
plazo
```

y que no pueden simplemente “abaratar todo” sin justificar cómo.

---

## Sorpresa 2 — Arquitecto

> **CAMBIO DEL PROMOTOR**
>
> El cliente quiere cambiar una parte importante del uso previsto del espacio.
>
> Hasta ahora una zona iba a destinarse a almacenamiento y ahora quiere utilizarla como zona accesible al público.
>
> No sabemos todavía qué requisitos normativos adicionales implica.
>
> Analiza el impacto técnico, documental, administrativo y de planificación. No inventes requisitos normativos que no hayas verificado.

Agentes ideales:

```text
brief_analyst
regulatory_researcher
design_coordinator
planner
reviewer
```

Aquí quieres que aparezca explícitamente:

```text
hecho confirmado
vs.
normativa que todavía debe investigarse
```

---

## Sorpresa 3 — Empresa de deportes

> **PROBLEMA OPERATIVO**
>
> El recinto previsto para el evento acaba de informar de que **no estará disponible en la fecha planificada**.
>
> Ofrece dos alternativas:
>
> * el mismo recinto una semana después;
> * otro recinto disponible en la fecha original, pero con un 20 % menos de capacidad.
>
> Analiza ambas alternativas y sus consecuencias antes de realizar cambios.

Agentes:

```text
event_manager
operations
marketing
planner
reviewer
```

Aquí tendrán que comparar alternativas, no simplemente ejecutar un cambio.

Es excelente para enseñar que la IA **propone y el humano decide**.

---

## Sorpresa 4 — Diseñador de videojuegos

> **SCOPE CREEP**
>
> Después de ver el prototipo, alguien importante para el proyecto pide incorporar **modo cooperativo online** al vertical slice.
>
> La fecha de entrega no cambia.
>
> El equipo tampoco aumenta.
>
> Analiza:
>
> * impacto técnico;
> * impacto artístico;
> * QA;
> * nuevas dependencias;
> * riesgo sobre el milestone.
>
> No añadas la funcionalidad todavía.

Agentes:

```text
producer
game_designer
technical_planner
qa_release
reviewer
```

Aquí lo interesante es comprobar si los agentes dicen realmente:

> esto probablemente requiere sacrificar alcance existente

en lugar de simplemente añadir veinte tareas nuevas.

---

## Sorpresa 5 — Tu proyecto / workshop

Tu propio proyecto puede ser:

**Preparación y ejecución del workshop Codex + OpenProject + Multiagentes**

Tu cambio:

> **INCIDENCIA DEL WORKSHOP**
>
> Dos horas antes de empezar descubres que:
>
> * uno de los participantes no ha instalado nada;
> * otro no puede utilizar Orca correctamente;
> * dispones solo de 2 horas y 15 minutos en lugar de 3 horas;
> * quieres conservar obligatoriamente la demostración multiagente y el cambio sorpresa.
>
> Replanifica el workshop.
>
> Primero analiza qué partes pueden eliminarse, reducirse, adelantarse o ejecutar en paralelo. No cambies todavía el proyecto.

Agentes:

```text
workshop_manager
infrastructure
participant_experience
planner
reviewer
```

Esta tiene una ventaja: **estás gestionando con el sistema el propio workshop en el que estás enseñando el sistema**.

Es dogfooding perfecto.

---

## Una última dinámica que añadiría

No les entregaría el cambio sorpresa simplemente para que Codex lo resuelva.

Primero les preguntaría a ellos:

> **¿Qué crees tú que va a afectar este cambio?**

Que digan durante 30 segundos qué esperan.

Después lanzan los agentes.

Finalmente comparan:

```text
intuición humana
       ↕
análisis multiagente
       ↕
estado real OpenProject
```

Eso evita convertir el workshop en una sesión de “copiar prompts y mirar a la IA trabajar”.

El objetivo educativo final debería ser que entiendan que la mejor arquitectura no es:

```text
Humano → IA → aceptar
```

sino:

```text
                 especialistas IA
                ↗       ↑       ↖
Humano → Project Manager → sistema real
  ↑             ↓
  └──── decisión/revisión
```

Ahí está realmente el valor de todo lo que habéis montado.
