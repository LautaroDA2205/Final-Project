USE financial_data;
-- =====================================================
-- Financial Data Pipeline - Database Schema
-- Author: Lautaro Silvestri
-- Description: Relational schema for financial analysis
-- =====================================================

-- -----------------------------------------------------
-- Drop tables (safe re-run)
-- -----------------------------------------------------

DROP TABLE IF EXISTS income_statements;
DROP TABLE IF EXISTS companies;

-- -----------------------------------------------------
-- Companies table
-- -----------------------------------------------------

CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    sector VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Income Statements table
-- -----------------------------------------------------

CREATE TABLE income_statements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    fiscal_year INT NOT NULL,
    
    revenue BIGINT,
    cost_of_revenue BIGINT,
    gross_profit BIGINT,
    operating_income BIGINT,
    net_income BIGINT,
    eps DECIMAL(10,4),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_company
        FOREIGN KEY (company_id)
        REFERENCES companies(id)
        ON DELETE CASCADE,
        
    CONSTRAINT unique_company_year
        UNIQUE (company_id, fiscal_year)
);

-- -----------------------------------------------------
-- Indexes for performance
-- -----------------------------------------------------

CREATE INDEX idx_company_id ON income_statements(company_id);
CREATE INDEX idx_fiscal_year ON income_statements(fiscal_year);

USE financial_data;
SHOW TABLES;

USE financial_data;

DELETE FROM income_statements;
DELETE FROM companies;

SELECT COUNT(*) FROM companies;
SELECT COUNT(*) FROM income_statements;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM income_statements;
DELETE FROM companies;

SET SQL_SAFE_UPDATES = 1;

SELECT COUNT(*) FROM companies;
SELECT COUNT(*) FROM income_statements;

USE financial_data;

SELECT COUNT(*) AS total_companies FROM companies;
SELECT COUNT(*) AS total_records FROM income_statements;

SELECT c.symbol, COUNT(*) AS years_loaded
FROM income_statements i
JOIN companies c ON i.company_id = c.id
GROUP BY c.symbol;

USE financial_data;

CREATE OR REPLACE VIEW vw_revenue_cagr_5y AS
SELECT
    c.id AS company_id,
    c.symbol,
    
    MIN(i.fiscal_year) AS start_year,
    MAX(i.fiscal_year) AS end_year,
    
    MIN(CASE WHEN i.fiscal_year = (
        SELECT MIN(fiscal_year)
        FROM income_statements i2
        WHERE i2.company_id = c.id
    ) THEN i.revenue END) AS revenue_start,
    
    MIN(CASE WHEN i.fiscal_year = (
        SELECT MAX(fiscal_year)
        FROM income_statements i3
        WHERE i3.company_id = c.id
    ) THEN i.revenue END) AS revenue_end,

    POW(
        MIN(CASE WHEN i.fiscal_year = (
            SELECT MAX(fiscal_year)
            FROM income_statements i4
            WHERE i4.company_id = c.id
        ) THEN i.revenue END)
        /
        MIN(CASE WHEN i.fiscal_year = (
            SELECT MIN(fiscal_year)
            FROM income_statements i5
            WHERE i5.company_id = c.id
        ) THEN i.revenue END),
        1.0 / (COUNT(DISTINCT i.fiscal_year) - 1)
    ) - 1 AS revenue_cagr_5y

FROM income_statements i
JOIN companies c ON i.company_id = c.id
GROUP BY c.id, c.symbol;

SELECT * FROM vw_revenue_cagr_5y;

CREATE OR REPLACE VIEW vw_profitability_5y AS
SELECT
    c.id AS company_id,
    c.symbol,
    
    AVG(i.net_income / i.revenue) AS avg_net_margin_5y,
    STDDEV(i.net_income / i.revenue) AS margin_std_5y

FROM income_statements i
JOIN companies c ON i.company_id = c.id

GROUP BY c.id, c.symbol;

SELECT * FROM vw_profitability_5y;

CREATE OR REPLACE VIEW vw_fundamental_metrics_5y AS
SELECT
    g.company_id,
    g.symbol,
    
    g.revenue_cagr_5y,
    
    p.avg_net_margin_5y,
    p.margin_std_5y

FROM vw_revenue_cagr_5y g
JOIN vw_profitability_5y p
    ON g.company_id = p.company_id;
    
SELECT * FROM vw_fundamental_metrics_5y;

CREATE OR REPLACE VIEW vw_fundamental_scores_global AS
SELECT
    company_id,
    symbol,
    
    revenue_cagr_5y,
    avg_net_margin_5y,
    margin_std_5y,
    
    PERCENT_RANK() OVER (ORDER BY revenue_cagr_5y) * 100 AS growth_score,
    
    PERCENT_RANK() OVER (ORDER BY avg_net_margin_5y) * 100 AS profitability_score,
    
    (1 - PERCENT_RANK() OVER (ORDER BY margin_std_5y)) * 100 AS stability_score

FROM vw_fundamental_metrics_5y;

SELECT * FROM vw_fundamental_scores_global;

CREATE OR REPLACE VIEW vw_cfo_index_global AS
SELECT
    company_id,
    symbol,
    
    growth_score,
    profitability_score,
    stability_score,
    
    (
        0.4 * growth_score +
        0.4 * profitability_score +
        0.2 * stability_score
    ) AS cfo_index

FROM vw_fundamental_scores_global;

SELECT * FROM vw_cfo_index_global
ORDER BY cfo_index DESC;

CREATE OR REPLACE VIEW vw_cfo_index_report AS
SELECT
    ci.company_id,
    c.symbol,
    c.name,
    c.sector,
    
    ci.growth_score,
    ci.profitability_score,
    ci.stability_score,
    ci.cfo_index

FROM vw_cfo_index_global ci
JOIN companies c
    ON ci.company_id = c.id;
    
    SELECT * 
FROM vw_cfo_index_report
ORDER BY cfo_index DESC;

CREATE OR REPLACE VIEW vw_net_income_cagr_5y AS
SELECT
    c.id AS company_id,
    c.symbol,

    MIN(i.fiscal_year) AS start_year,
    MAX(i.fiscal_year) AS end_year,

    MIN(CASE 
        WHEN i.fiscal_year = (
            SELECT MIN(fiscal_year)
            FROM income_statements i2
            WHERE i2.company_id = c.id
        )
        THEN i.net_income
    END) AS net_income_start,

    MIN(CASE 
        WHEN i.fiscal_year = (
            SELECT MAX(fiscal_year)
            FROM income_statements i3
            WHERE i3.company_id = c.id
        )
        THEN i.net_income
    END) AS net_income_end,

    POWER(
        (
            MIN(CASE 
                WHEN i.fiscal_year = (
                    SELECT MAX(fiscal_year)
                    FROM income_statements i4
                    WHERE i4.company_id = c.id
                )
                THEN i.net_income
            END)
        /
            MIN(CASE 
                WHEN i.fiscal_year = (
                    SELECT MIN(fiscal_year)
                    FROM income_statements i5
                    WHERE i5.company_id = c.id
                )
                THEN i.net_income
            END)
        ),
        1.0 / (COUNT(DISTINCT i.fiscal_year) - 1)
    ) - 1 AS net_income_cagr_5y

FROM income_statements i
JOIN companies c ON i.company_id = c.id
GROUP BY c.id, c.symbol;

SELECT * FROM vw_net_income_cagr_5y;

CREATE OR REPLACE VIEW vw_net_income_cagr_5y AS
SELECT
    c.id AS company_id,
    c.symbol,

    MIN(i.fiscal_year) AS start_year,
    MAX(i.fiscal_year) AS end_year,

    MIN(CASE 
        WHEN i.fiscal_year = (
            SELECT MIN(fiscal_year)
            FROM income_statements i2
            WHERE i2.company_id = c.id
        )
        THEN i.net_income
    END) AS net_income_start,

    MIN(CASE 
        WHEN i.fiscal_year = (
            SELECT MAX(fiscal_year)
            FROM income_statements i3
            WHERE i3.company_id = c.id
        )
        THEN i.net_income
    END) AS net_income_end,

    CASE
        WHEN 
            MIN(CASE 
                WHEN i.fiscal_year = (
                    SELECT MIN(fiscal_year)
                    FROM income_statements i4
                    WHERE i4.company_id = c.id
                )
                THEN i.net_income
            END) > 0
        AND
            MIN(CASE 
                WHEN i.fiscal_year = (
                    SELECT MAX(fiscal_year)
                    FROM income_statements i5
                    WHERE i5.company_id = c.id
                )
                THEN i.net_income
            END) > 0
        THEN
            POWER(
                (
                    MIN(CASE 
                        WHEN i.fiscal_year = (
                            SELECT MAX(fiscal_year)
                            FROM income_statements i6
                            WHERE i6.company_id = c.id
                        )
                        THEN i.net_income
                    END)
                /
                    MIN(CASE 
                        WHEN i.fiscal_year = (
                            SELECT MIN(fiscal_year)
                            FROM income_statements i7
                            WHERE i7.company_id = c.id
                        )
                        THEN i.net_income
                    END)
                ),
                1.0 / (COUNT(DISTINCT i.fiscal_year) - 1)
            ) - 1
        ELSE NULL
    END AS net_income_cagr_5y

FROM income_statements i
JOIN companies c ON i.company_id = c.id
GROUP BY c.id, c.symbol;

CREATE OR REPLACE VIEW vw_fundamental_metrics_5y AS
SELECT
    r.company_id,
    r.symbol,

    r.revenue_cagr_5y,
    n.net_income_cagr_5y,

    p.avg_net_margin_5y,
    p.margin_std_5y

FROM vw_revenue_cagr_5y r
LEFT JOIN vw_net_income_cagr_5y n
    ON r.company_id = n.company_id
JOIN vw_profitability_5y p
    ON r.company_id = p.company_id;
    
SELECT * FROM vw_fundamental_metrics_5y;

CREATE OR REPLACE VIEW vw_fundamental_scores_global AS
SELECT
    company_id,
    symbol,

    revenue_cagr_5y,
    net_income_cagr_5y,
    avg_net_margin_5y,
    margin_std_5y,

    -- Percentiles base
    PERCENT_RANK() OVER (ORDER BY revenue_cagr_5y) * 100 AS revenue_percentile,
    PERCENT_RANK() OVER (ORDER BY net_income_cagr_5y) * 100 AS net_income_percentile,
    PERCENT_RANK() OVER (ORDER BY avg_net_margin_5y) * 100 AS margin_percentile,
    (1 - PERCENT_RANK() OVER (ORDER BY margin_std_5y)) * 100 AS stability_percentile,

    -- Growth score dinámico
    CASE
        WHEN net_income_cagr_5y IS NULL
            THEN PERCENT_RANK() OVER (ORDER BY revenue_cagr_5y) * 100
        ELSE
            0.5 * (PERCENT_RANK() OVER (ORDER BY revenue_cagr_5y) * 100) +
            0.5 * (PERCENT_RANK() OVER (ORDER BY net_income_cagr_5y) * 100)
    END AS growth_score,

    -- Profitability score
    PERCENT_RANK() OVER (ORDER BY avg_net_margin_5y) * 100 AS profitability_score,

    -- Stability score
    (1 - PERCENT_RANK() OVER (ORDER BY margin_std_5y)) * 100 AS stability_score

FROM vw_fundamental_metrics_5y;

CREATE OR REPLACE VIEW vw_cfo_index_global AS
SELECT
    company_id,
    symbol,
    growth_score,
    profitability_score,
    stability_score,

    (
        0.4 * growth_score +
        0.4 * profitability_score +
        0.2 * stability_score
    ) AS cfo_index

FROM vw_fundamental_scores_global;

SELECT *
FROM vw_cfo_index_global
ORDER BY cfo_index DESC;