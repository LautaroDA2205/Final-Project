# Corporate Financial Health Index (CFHI)

![Python](https://img.shields.io/badge/Python-3.x-blue)
![SQL](https://img.shields.io/badge/SQL-Database-green)
![Tableau](https://img.shields.io/badge/Tableau-Data%20Visualization-orange)
![Status](https://img.shields.io/badge/Project-Final%20Bootcamp-blue)

## Descripción del proyecto

El **Corporate Financial Health Index (CFHI)** es un índice cuantitativo diseñado para identificar empresas financieramente sólidas dentro del universo del **S&P 500**, utilizando métricas fundamentales basadas en la calidad financiera corporativa.

El objetivo del proyecto es construir un índice compuesto por empresas con **alta calidad de flujo de caja y solidez financiera**, y analizar su comportamiento frente al **benchmark del S&P 500**.

Este proyecto demuestra un **pipeline completo de análisis de datos**, desde la extracción de datos financieros hasta la construcción del índice y su visualización mediante dashboards interactivos.

---

## Objetivos

- Identificar empresas con **alta calidad financiera**
- Construir un **índice basado en métricas fundamentales**
- Seleccionar las **50 empresas mejor clasificadas**
- Comparar el rendimiento del índice con el **S&P 500**
- Analizar la **composición del portafolio y la exposición sectorial**

---

## Metodología

La construcción del índice se basa en cuatro dimensiones financieras clave:

- **Rentabilidad**
- **Solvencia**
- **Liquidez**
- **Crecimiento**

Cada empresa recibe un **score financiero agregado** basado en estas métricas.

Posteriormente se seleccionan las **50 empresas con mayor puntuación**, que conforman el portafolio final del índice.

El análisis posterior incluye:

- asignación de pesos
- concentración sectorial
- comparación con benchmark
- análisis de diversificación

---

## Pipeline del proyecto

El proyecto sigue un flujo completo de análisis de datos:

1. **Extracción de datos financieros**
   - API financiera mediante `yfinance`
   - Web scraping de empresas del S&P 500

2. **Limpieza y transformación de datos**
   - Normalización de datos
   - Tratamiento de valores faltantes
   - Preparación de variables financieras

3. **Cálculo de métricas financieras**
   - Ratios de rentabilidad
   - Ratios de liquidez
   - Métricas de crecimiento
   - Construcción del score financiero

4. **Construcción del índice**
   - Ranking de empresas
   - Selección del Top 50
   - Asignación de pesos en el portafolio

5. **Backtesting histórico**
   - Comparación del índice frente al S&P 500

6. **Visualización de resultados**
   - Dashboards interactivos desarrollados en **Tableau**


---

## Estructura del proyecto

El proyecto está organizado en distintos módulos que representan cada etapa del pipeline de datos.

CFHI_Project

- data_raw:
  
   datos financieros descargados desde la API


- notebooks:

  
  . 01_api_extraction.ipynb → extracción de datos
  
  . 02_pipeline_clean.ipynb → limpieza y transformación
  
  . 03_pipeline_build.ipynb → construcción del índice
  
  . 04_lsg50_backtest.ipynb → backtest histórico
  
  . 05_lsg50_index_research.ipynb → análisis del índice
  
  . 06_project_architecture.ipynb → documentación del pipeline


- src:
  
  .functions.py
  
  .fundamentals.py


- sql:

  schema.sql


- tableau:

  visualizaciones del índice

---


---

## Resultados del backtest

Comparación del rendimiento del índice CFHI frente al **S&P 500**.

![Backtest CFHI vs S&P500](images/lsg50_vs_sp500.png)

---

## Visualización del índice

El análisis final del índice se presenta mediante **dashboards interactivos desarrollados en Tableau**, que permiten explorar la estructura y comportamiento del portafolio.

Principales visualizaciones:

- Calidad financiera vs peso en el portafolio
- Composición del portafolio
- Comparación con benchmark
- Exposición sectorial
- Concentración de holdings

### Ejemplo de Dashboard

![Dashboard CFHI](images/tableau_overview.png)

### Exposición sectorial del índice

![Sector Allocation](images/sector_allocation.png)

---

## Tecnologías utilizadas

- **Python**
- **pandas**
- **numpy**
- **matplotlib**
- **yfinance**
- **SQL**
- **SQLite**
- **Tableau**

---

## Principales conclusiones

- La **calidad del flujo de caja** influye en la asignación del portafolio
- El índice muestra **concentración en sectores financieramente sólidos**
- La combinación de **Python, SQL y Tableau** permite desarrollar un pipeline completo de análisis financiero

---

## Futuras mejoras

- Ampliar el universo de empresas analizadas
- Incorporar nuevos ratios financieros
- Incluir métricas de riesgo ajustado
- Comparar el índice con otros índices basados en factores

---

## Autor

**Lautaro Silvestri**

Proyecto Final — **Data & Financial Analytics Bootcamp**
