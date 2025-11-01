# Panel Data Econometrics: Income and Democracy Revisited

[![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)](https://www.r-project.org/)
[![Panel Data](https://img.shields.io/badge/Panel%20Data-Econometrics-blue)](https://github.com/MulayeMuhammad/Income-Democracy-Panel-Data)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📋 Project Overview

This project replicates and extends the seminal work of **Acemoglu, Johnson, Robinson, and Yared (2008)** on the relationship between per capita income and democracy. Using advanced panel data econometric techniques, we investigate whether there exists a causal relationship between economic development and democratization.

**Key Question**: Does income cause democracy, or is the positive correlation driven by omitted historical and institutional factors?

## 👥 Authors

- **Moulaye Ahmed BRAHIM** - Data Scientist & Statistician-Economist Engineer
- **Zeinebou TAKI** - Co-author

**Supervisor**: Ilyes BOUMAHDI

**Institution**: Institut National de la Statistique et de l'Économie Appliquée (INSEA), Rabat, Morocco

**Date**: January 2025

---

## 🎯 Research Objectives

1. **Replicate** the findings of Acemoglu et al. (2008) using panel data methods
2. **Investigate** the causal relationship between income and democracy
3. **Apply** advanced econometric techniques:
   - Pooled OLS
   - Fixed Effects (Within Estimator)
   - Anderson-Hsiao IV Estimator
   - Generalized Method of Moments (GMM)
4. **Test** model validity using:
   - Arellano-Bond autocorrelation test
   - Hansen-Sargan test for overidentifying restrictions

---

## 📊 Data Description

### Dataset Characteristics
- **Time Period**: 1950-2000 (5-year intervals)
- **Countries**: 211 countries
- **Observations**: 11 time periods per country
- **Total Observations**: 2,321

### Variables

| Variable | Description | Source |
|----------|-------------|--------|
| `democracy` | Freedom House Political Rights Index (normalized 0-1) | Freedom House |
| `income` | Log GDP per capita | Maddison Tables (2003) + PPP estimates |
| `country` | Country identifier | - |
| `year` | Time period (5-year intervals) | - |

**Democracy Index (Freedom House)**:
- Evaluates: Electoral freedom, political parties, minority participation, effective opposition
- Scale: 0 (no democracy) to 1 (perfect democracy)

**Income Measure**:
- Two sources combined for robustness:
  - Long-term series: Maddison Tables (2003)
  - Recent estimates: Purchasing Power Parity (PPP) adjusted

---

## 🔬 Methodology

### Econometric Model

The dynamic panel data model is specified as:

```
d_it = α·d_i,t-1 + γ·y_i,t-1 + X'_i,t-1·β + μ_t + δ_i + u_it
```

Where:
- `d_it`: Democracy level in country i at time t
- `d_i,t-1`: Lagged democracy (captures persistence)
- `y_i,t-1`: Lagged log income per capita (main variable of interest)
- `X_i,t-1`: Vector of control variables
- `μ_t`: Time fixed effects (global trends)
- `δ_i`: Country fixed effects (time-invariant factors)
- `u_it`: Error term

### Estimation Strategies

#### 1. **Pooled OLS** (Baseline)
- Simple benchmark estimation
- **Bias**: Positive bias due to correlation between lagged dependent variable and error term
- **Coefficient (democracy lag)**: 0.7064*** (SE: 0.0243)
- **Coefficient (income lag)**: 0.0723*** (SE: 0.0083)

#### 2. **Fixed Effects (Within Estimator)**
- Controls for time-invariant country characteristics
- **Bias**: Negative bias (Nickell bias) due to lagged dependent variable
- **Coefficient (democracy lag)**: 0.3786*** (SE: 0.0334)
- **Coefficient (income lag)**: 0.0104 (SE: 0.0264) - **NOT SIGNIFICANT**
- **Key Finding**: Income effect disappears once fixed effects are included!

#### 3. **Anderson-Hsiao IV Estimator**
- Uses first differences to eliminate fixed effects
- Instruments: 2-period lagged levels
- **Coefficient (democracy lag)**: 0.4687*** (SE: 0.1182)
- **Coefficient (income lag)**: -0.1036 (SE: 0.3049) - NOT SIGNIFICANT
- Consistent but not efficient

#### 4. **GMM (Arellano-Bond)**
- Most efficient estimator under no serial correlation
- Uses all available moment conditions
- **Coefficient (democracy lag)**: 0.5050*** (SE: 0.0905)
- **Coefficient (income lag)**: -0.0901 (SE: 0.0803) - NOT SIGNIFICANT
- **AR(2) Test**: p-value = 0.3988 (no autocorrelation ✓)
- **Hansen Test**: χ² = 70.745, df = 44, p = 0.0064 (overidentification restrictions valid)

---

## 📈 Key Results

### Main Findings

1. **Cross-Sectional Analysis**: 
   - Strong positive correlation between income and democracy (see Figure 1)
   - Coefficient suggests 10% increase in GDP → 0.007 increase in Freedom House score

2. **Panel Data with Fixed Effects**:
   - ⚠️ **The relationship disappears!**
   - Once country-specific factors are controlled, income has NO significant effect on democracy
   - Result is robust across different estimation methods

3. **Dynamic Persistence**:
   - Democracy shows strong persistence (α ≈ 0.38 to 0.71)
   - Countries tend to maintain their democratic levels over time

4. **Causal Interpretation**:
   - **No evidence of causal effect** of income on democracy
   - Positive correlation likely due to omitted historical and institutional factors
   - Historical trajectories shape both economic and political development

### Statistical Tests

| Test | Statistic | p-value | Interpretation |
|------|-----------|---------|----------------|
| AR(2) - Arellano-Bond | 0.8437 | 0.3988 | No second-order autocorrelation ✓ |
| Hansen J-test | χ² = 70.745 (df=44) | 0.0064 | Overidentification restrictions valid |

---

## 🛠️ Technical Implementation

### R Packages Used

```r
library(plm)        # Panel data econometrics
library(lmtest)     # Diagnostic tests
library(sandwich)   # Robust standard errors
library(stargazer)  # Table formatting
library(ggplot2)    # Visualizations
library(dplyr)      # Data manipulation
```

### Code Structure

```
Income-Democracy-Panel-Data/
│
├── data/
│   ├── DemocracyIncome.csv          # Main dataset
│   └── data_description.txt
│
├── scripts/
│   ├── 01_data_preparation.R        # Data cleaning and transformation
│   ├── 02_pooled_ols.R              # Pooled OLS estimation
│   ├── 03_fixed_effects.R           # Within estimator
│   ├── 04_anderson_hsiao.R          # IV estimation
│   ├── 05_gmm_estimation.R          # Arellano-Bond GMM
│   ├── 06_diagnostic_tests.R        # AR tests, Hansen tests
│   └── 07_visualizations.R          # Plots and figures
│
├── output/
│   ├── tables/                      # Regression tables
│   ├── figures/                     # Plots (Figure 1, etc.)
│   └── results_summary.txt
│
├── docs/
│   ├── TP_PANEL_DATA_ECONOMETRICS.pdf    # Full report
│   ├── presentation.pdf                   # Slides
│   └── acemoglu_et_al_2008.pdf           # Original paper
│
├── README.md                        # This file
├── LICENSE
└── .gitignore
```

---

## 🚀 Getting Started

### Prerequisites

```r
# Install required packages
install.packages(c("plm", "lmtest", "sandwich", "stargazer", "ggplot2", "dplyr"))
```

### Running the Analysis

```r
# Clone the repository
git clone https://github.com/MulayeMuhammad/Income-Democracy-Panel-Data.git
cd Income-Democracy-Panel-Data

# Set working directory in R
setwd("path/to/Income-Democracy-Panel-Data")

# Load data
source("scripts/01_data_preparation.R")

# Run main analysis
source("scripts/02_pooled_ols.R")
source("scripts/03_fixed_effects.R")
source("scripts/04_anderson_hsiao.R")
source("scripts/05_gmm_estimation.R")

# Run diagnostic tests
source("scripts/06_diagnostic_tests.R")

# Generate visualizations
source("scripts/07_visualizations.R")
```

---

## 📊 Results Visualization

### Figure 1: Cross-Sectional Relationship (1999)

The scatter plot shows a clear positive relationship between log GDP per capita and democracy across countries in 1999. However, this relationship is **not causal** once panel data methods are applied.

<img src="output/figures/income_democracy_1999.png" width="600" alt="Income and Democracy Cross-Section">

---

## 📚 References

**Main Paper**:
- Acemoglu, D., Johnson, S., Robinson, J. A., & Yared, P. (2008). Income and democracy. *American Economic Review*, 98(3), 808-842.

**Econometric Methods**:
- Anderson, T. W., & Hsiao, C. (1982). Formulation and estimation of dynamic models using panel data. *Journal of Econometrics*, 18(1), 47-82.
- Arellano, M., & Bond, S. (1991). Some tests of specification for panel data: Monte Carlo evidence and an application to employment equations. *Review of Economic Studies*, 58(2), 277-297.

**Data Sources**:
- Freedom House. Political Rights Index. [https://freedomhouse.org/](https://freedomhouse.org/)
- Maddison, A. (2003). *The World Economy: Historical Statistics*. OECD Development Centre.

---

## 🎓 Academic Context

This project was completed as part of the **Panel Data Econometrics** course at INSEA (Institut National de la Statistique et de l'Économie Appliquée) in Rabat, Morocco.

**Learning Objectives**:
- Master advanced panel data techniques
- Understand causal inference in observational data
- Apply GMM estimation methods
- Conduct rigorous econometric diagnostics
- Replicate influential academic research

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/MulayeMuhammad/Income-Democracy-Panel-Data/issues).

---

## 👨‍💻 Author

**Moulaye Ahmed Mohammed Brahim**

- 🌐 Portfolio: [mulayemuhammad.github.io/Moulaye_DS_Portfolio](https://mulayemuhammad.github.io/Moulaye_DS_Portfolio/)
- 💼 LinkedIn: [Moulaye Ahmed MUHAMMAD](https://www.linkedin.com/in/moulaye-ahmed-muhammad/)
- 🐙 GitHub: [@MulayeMuhammad](https://github.com/MulayeMuhammad)
- 📧 Email: mulayemuhammad@gmail.com
- 🐦 Twitter: [@MuhammadMoulaye](https://twitter.com/MuhammadMoulaye)

---

## 🙏 Acknowledgments

- **Supervisor**: Ilyes BOUMAHDI for guidance and support
- **INSEA**: For providing the academic framework and resources
- **Acemoglu et al. (2008)**: For the original groundbreaking research
- **R Community**: For excellent econometric packages (especially `plm`)

---

## 📞 Contact

For questions or collaborations related to this project:
- Open an issue on GitHub
- Email: mulayemuhammad@gmail.com
- Connect on [LinkedIn](https://www.linkedin.com/in/moulaye-ahmed-muhammad/)

---

<p align="center">
  <i>⭐ If you find this project useful, please consider giving it a star!</i>
</p>

<p align="center">
  Made with ❤️ by <a href="https://github.com/MulayeMuhammad">Moulaye Ahmed</a>
</p>
