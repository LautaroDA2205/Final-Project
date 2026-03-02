# ==============================================
# Conexión a base de datos MySQL
# ==============================================

import mysql.connector

def create_connection(host, user, password, database):
    """
    Crea y devuelve una conexión a MySQL.
    
    Parameters:
        host (str): Servidor
        user (str): Usuario
        password (str): Contraseña
        database (str): Nombre de la base de datos
    
    Returns:
        connection: Objeto conexión MySQL
    """
    try:
        connection = mysql.connector.connect(
            host=host,
            user=user,
            password=password,
            database=database
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error de conexión: {err}")
        return None


# ==============================================
# Cálculo de métricas financieras
# ==============================================

def calculate_financial_metrics(df):
    """
    Calcula métricas clave:
    - Crecimiento interanual
    - Margen neto
    """
    df["revenue_yoy_%"] = df["revenue"].pct_change() * 100
    df["net_income_yoy_%"] = df["net_income"].pct_change() * 100
    df["net_margin_%"] = (df["net_income"] / df["revenue"]) * 100
    
    return df


# ==============================================
# Cálculo de CAGR
# ==============================================

def calculate_cagr(series):
    """
    Calcula la tasa de crecimiento anual compuesta (CAGR).
    """
    years = len(series) - 1
    
    if years <= 0 or series.iloc[0] == 0:
        return None
    
    return (series.iloc[-1] / series.iloc[0]) ** (1/years) - 1