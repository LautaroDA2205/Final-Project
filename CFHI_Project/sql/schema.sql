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