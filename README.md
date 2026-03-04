# Corporate Financial Health Index (CFHI)

Índice cuantitativo diseñado para identificar empresas financieramente sólidas dentro del universo del S&P 500 utilizando métricas fundamentales.

El proyecto construye un índice basado en salud financiera corporativa y evalúa su rendimiento histórico frente al S&P 500.

---

## Metodología

El índice se construye a partir de cuatro dimensiones financieras clave:

- **Rentabilidad**
- **Solvencia**
- **Liquidez**
- **Crecimiento**

Cada empresa recibe un **score financiero agregado** y se seleccionan las **50 empresas mejor clasificadas** para formar el índice.

---

## Pipeline del proyecto

El flujo de trabajo sigue las siguientes etapas:

1. Extracción de datos financieros desde una API
2. Limpieza y transformación de datos
3. Cálculo de métricas financieras
4. Construcción del índice
5. Backtest histórico
6. Análisis del rendimiento

---

## Estructura del proyecto



---

## Resultados del backtest

Comparación del rendimiento del índice frente al S&P 500.

![CFHI vs S&P500](images/lsg50_vs_sp500.png)

---

## Tecnologías utilizadas

- Python
- pandas
- numpy
- matplotlib
- yfinance
- SQLite
- Tableau

---

## Autor

Lautaro Silvestri  
Proyecto final — Data & Financial Analytics
