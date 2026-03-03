import yfinance as yf

def fetch_fundamentals(symbol):

    try:
        ticker = yf.Ticker(symbol)
        info = ticker.info
        financials = ticker.financials

        market_cap = info.get("marketCap", None)

        if "Net Income" not in financials.index:
            return None

        net_income = financials.loc["Net Income"]
        net_income = net_income.sort_index(ascending=False)
        last_years = net_income.dropna().head(5)

        if len(last_years) < 3:
            return None

        start = last_years.iloc[-1]
        end = last_years.iloc[0]

        if start <= 0 or end <= 0:
            return None

        years = len(last_years) - 1
        cagr = (end / start) ** (1 / years) - 1

        return {
            "symbol": symbol,
            "market_cap": market_cap,
            "net_income_cagr_5y": cagr
        }

    except:
        return None