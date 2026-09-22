# Workshop — OpenProject + Codex + Multiagentes

## Objetivo

Crear un proyecto real hablando con Codex, construir agentes de IA
especializados en vuestro propio sector, ejecutarlos en paralelo
y gestionar el proyecto resultante dentro de OpenProject.

## Arquitectura

Usuario
  ↓
Codex — Project Manager
  ↓
Subagentes especialistas
  ↓
OpenProject CE MCP
  ↓
OpenProject

## Durante el workshop

El objetivo es que cada participante:

1. conecte su API token personal de OpenProject;
2. abra Codex desde este repositorio;
3. describa un proyecto real;
4. permita que Codex realice una pequeña entrevista;
5. cree el proyecto en OpenProject;
6. cree fases, hitos, tareas y dependencias;
7. visualice el proyecto en Gantt;
8. cree entre 2 y 4 agentes especializados en su profesión;
9. ejecute varios agentes en paralelo;
10. consolide sus recomendaciones;
11. aplique cambios aprobados;
12. introduzca un cambio inesperado;
13. replantee el proyecto;
14. ejecute una auditoría mediante `reviewer`;
15. presente su proyecto y su equipo de agentes.

## Primer prompt recomendado

Puedes empezar escribiendo:

"Quiero crear un proyecto real.

Hazme una entrevista breve para entender:

- objetivo;
- alcance;
- fecha;
- presupuesto;
- restricciones.

No crees nada todavía.

Primero enséñame la definición del proyecto que propones."

## Prompt multiagente recomendado

Cuando el proyecto ya exista:

"Utiliza planner y mis agentes especialistas para analizar
el proyecto en paralelo.

Asigna a cada agente una responsabilidad distinta y sin solapamientos.

Espera a que todos terminen.

Consolida sus resultados.

Después utiliza reviewer para cuestionar la propuesta combinada.

No modifiques todavía OpenProject."

## Cambio inesperado

Durante el workshop se introducirá un cambio importante en el proyecto.

Por ejemplo:

- reducción del presupuesto;
- reducción del plazo;
- cambio de alcance;
- proveedor no disponible;
- recurso no disponible;
- cambio de requisitos;
- nueva funcionalidad.

Los agentes deberán analizar el impacto antes de realizar modificaciones.

## Objetivo final

Al terminar deberías disponer de:

- un proyecto real;
- fases;
- hitos;
- tareas;
- dependencias;
- Gantt;
- riesgos;
- agentes personalizados;
- una revisión independiente;
- una replanificación provocada por un cambio.
