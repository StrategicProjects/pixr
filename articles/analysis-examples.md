# Data Analysis Examples

This article demonstrates practical data analysis examples using pixr to
explore PIX adoption and usage patterns in Brazil.

## Setup

``` r
library(pixr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

# Set theme for all plots
theme_set(theme_minimal(base_size = 12))
```

## Example 1: PIX Keys Market Share

Analyze which financial institutions dominate the PIX keys market:

``` r
# Get PIX keys data for December 2025
# Note: date uses YYYY-MM-DD format
keys <- get_pix_keys(date = "2025-12-01")

# Get summary by institution (top 20)
top_institutions <- get_pix_keys_summary(date = "2025-12-01", n_top = 20)

# Visualize top 10
top_institutions |>
  slice_head(n = 10) |>
  mutate(Nome = forcats::fct_reorder(Nome, total_keys)) |>
  ggplot(aes(x = total_keys / 1e6, y = Nome)) +
  geom_col(fill = "#008060") +
  geom_text(
    aes(label = sprintf("%.1fM", total_keys / 1e6)),
    hjust = -0.1, size = 3
  ) +
  scale_x_continuous(
    labels = scales::number_format(suffix = "M"),
    expand = expansion(mult = c(0, 0.15))
  ) +
  labs(
    title = "Top 10 PIX Participants by Registered Keys",
    subtitle = "December 2025",
    x = "Total Keys (Millions)",
    y = NULL,
    caption = "Source: Brazilian Central Bank Open Data"
  )
```

## Example 2: Key Type Distribution

Analyze which types of PIX keys are most popular:

``` r
# Get keys data and aggregate by type
keys <- get_pix_keys(date = "2025-12-01")

# Summarize by key type
key_summary <- get_pix_keys_by_type(date = "2025-12-01")

# Calculate percentages
key_summary <- key_summary |>
  mutate(
    percentage = total_keys / sum(total_keys) * 100
  )

# Visualize
ggplot(key_summary, aes(x = reorder(TipoChave, -total_keys), y = total_keys / 1e6, fill = NaturezaUsuario)) +
  geom_col(position = "stack") +
  scale_y_continuous(labels = scales::number_format(suffix = "M")) +
  scale_fill_manual(values = c("PF" = "#008060", "PJ" = "#1e88e5")) +
  labs(
    title = "PIX Keys by Type",
    subtitle = "December 2025",
    x = "Key Type",
    y = "Total Keys (Millions)",
    fill = "User Type",
    caption = "Source: Brazilian Central Bank Open Data"
  ) +
  theme(legend.position = "bottom")
```

## Example 3: Regional Transaction Analysis

Analyze PIX usage patterns across Brazilian regions:

``` r
# Get transactions by region
# Note: database uses YYYYMM format
region_data <- get_pix_transactions_by_region(database = "202512")

# Visualize total value by region
region_data |>
  mutate(
    total_value_billions = (vl_pagador_pf + vl_pagador_pj) / 1e9
  ) |>
  ggplot(aes(x = reorder(Regiao, total_value_billions), y = total_value_billions)) +
  geom_col(fill = "#008060") +
  coord_flip() +
  scale_y_continuous(labels = scales::number_format(prefix = "R$ ", suffix = "B")) +
  labs(
    title = "PIX Transaction Volume by Region",
    subtitle = "December 2025",
    x = NULL,
    y = "Transaction Value (Billions BRL)",
    caption = "Source: Brazilian Central Bank Open Data"
  )
```

## Example 4: State-Level Analysis

``` r
# Get transactions by state
state_data <- get_pix_transactions_by_state(database = "202512")

# Top 10 states by transaction count
state_data |>
  mutate(
    total_count = qt_pagador_pf + qt_pagador_pj
  ) |>
  slice_head(n = 10) |>
  mutate(Estado = forcats::fct_reorder(Estado, total_count)) |>
  ggplot(aes(x = total_count / 1e6, y = Estado)) +
  geom_col(fill = "#1e88e5") +
  scale_x_continuous(labels = scales::number_format(suffix = "M")) +
  labs(
    title = "Top 10 States by PIX Transaction Count",
    subtitle = "December 2025",
    x = "Transactions (Millions)",
    y = NULL,
    caption = "Source: Brazilian Central Bank Open Data"
  )
```

## Example 5: Transaction Nature Analysis

Analyze transactions by nature (P2P, P2B, B2B, etc.):

``` r
# Get summary by transaction nature
nature_summary <- get_pix_summary(database = "202509", group_by = "NATUREZA")

# Visualize
nature_summary |>
  ggplot(aes(x = reorder(NATUREZA, -total_value), y = total_value / 1e12)) +
  geom_col(fill = "#008060") +
  geom_text(
    aes(label = sprintf("R$ %.1fT", total_value / 1e12)),
    vjust = -0.5, size = 3
  ) +
  scale_y_continuous(
    labels = scales::number_format(prefix = "R$ ", suffix = "T"),
    expand = expansion(mult = c(0, 0.15))
  ) +
  labs(
    title = "PIX Transaction Value by Nature",
    subtitle = "September 2025 - P2P: Person to Person, P2B: Person to Business, etc.",
    x = "Transaction Nature",
    y = "Total Value (Trillions BRL)",
    caption = "Source: Brazilian Central Bank Open Data"
  )
```

## Example 6: Filtering Transactions by State

Use OData filters to analyze specific states:

``` r
# Get transactions for Maranhão only using filter
maranhao <- get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'MARANHÃO'",
  orderby = "VL_PagadorPF desc"
)

# Top 10 municipalities by value
maranhao |>
  slice_head(n = 10) |>
  ggplot(aes(x = reorder(Municipio, VL_PagadorPF), y = VL_PagadorPF / 1e6)) +
  geom_col(fill = "#008060") +
  coord_flip() +
  scale_y_continuous(labels = scales::number_format(prefix = "R$ ", suffix = "M")) +
  labs(
    title = "Top 10 Municipalities in Maranhão by PIX Value",
    subtitle = "December 2025 - Individual payers",
    x = NULL,
    y = "Transaction Value (Millions BRL)",
    caption = "Source: Brazilian Central Bank Open Data"
  )
```

## Example 7: Comparing Regions with Filters

``` r
# Get Northeast transactions using filter
nordeste <- get_pix_transaction_stats(
  database = "202509",
  filter = "PAG_REGIAO eq 'NORDESTE'"
) |>
  summarise(
    total_value = sum(VALOR, na.rm = TRUE),
    total_count = sum(QUANTIDADE, na.rm = TRUE)
  ) |>
  mutate(region = "NORDESTE")

# Get Southeast transactions
sudeste <- get_pix_transaction_stats(
  database = "202509",
  filter = "PAG_REGIAO eq 'SUDESTE'"
) |>
  summarise(
    total_value = sum(VALOR, na.rm = TRUE),
    total_count = sum(QUANTIDADE, na.rm = TRUE)
  ) |>
  mutate(region = "SUDESTE")

# Combine and compare
comparison <- bind_rows(nordeste, sudeste)

comparison |>
  pivot_longer(c(total_value, total_count), names_to = "metric", values_to = "value") |>
  ggplot(aes(x = region, y = value, fill = metric)) +
  geom_col(position = "dodge") +
  facet_wrap(~metric, scales = "free_y") +
  labs(
    title = "Northeast vs Southeast PIX Comparison",
    subtitle = "September 2025",
    x = NULL,
    y = NULL
  )
```

## Example 8: P2P vs P2B Analysis

``` r
# Get P2P transactions
p2p <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2P'"
) |>
  group_by(PAG_REGIAO) |>
  summarise(value = sum(VALOR, na.rm = TRUE)) |>
  mutate(type = "P2P")

# Get P2B transactions
p2b <- get_pix_transaction_stats(
  database = "202509",
  filter = "NATUREZA eq 'P2B'"
) |>
  group_by(PAG_REGIAO) |>
  summarise(value = sum(VALOR, na.rm = TRUE)) |>
  mutate(type = "P2B")

# Combine
combined <- bind_rows(p2p, p2b)

# Visualize
ggplot(combined, aes(x = PAG_REGIAO, y = value / 1e12, fill = type)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("P2P" = "#008060", "P2B" = "#1e88e5")) +
  scale_y_continuous(labels = scales::number_format(prefix = "R$ ", suffix = "T")) +
  labs(
    title = "P2P vs P2B Transactions by Region",
    subtitle = "September 2025",
    x = "Payer Region",
    y = "Transaction Value (Trillions BRL)",
    fill = "Transaction Type",
    caption = "Source: Brazilian Central Bank Open Data"
  ) +
  theme(legend.position = "bottom")
```

## Example 9: Multiple Months Analysis

Fetch data for multiple months and analyze trends:

``` r
# Get Q3 2025 data
q3_data <- get_pix_transaction_stats_multi(
  databases = c("202507", "202508", "202509")
)

# Aggregate by month and nature
monthly_nature <- q3_data |>
  group_by(AnoMes, NATUREZA) |>
  summarise(
    total_value = sum(VALOR, na.rm = TRUE),
    .groups = "drop"
  )

# Visualize trends
ggplot(monthly_nature, aes(x = factor(AnoMes), y = total_value / 1e12, fill = NATUREZA)) +
  geom_col(position = "stack") +
  scale_y_continuous(labels = scales::number_format(prefix = "R$ ", suffix = "T")) +
  labs(
    title = "PIX Transaction Value by Nature - Q3 2025",
    x = "Month",
    y = "Transaction Value (Trillions BRL)",
    fill = "Nature",
    caption = "Source: Brazilian Central Bank Open Data"
  ) +
  theme(legend.position = "bottom")
```

## Example 10: Initiation Method Analysis

Analyze how PIX transactions are initiated:

``` r
# Get summary by initiation method
method_summary <- get_pix_summary(database = "202509", group_by = "FORMAINICIACAO")

# Add labels
method_labels <- c(
  "DICT" = "PIX Key",
  "QRDN" = "Dynamic QR",
  "QRES" = "Static QR",
  "MANU" = "Manual",
  "INIC" = "Initiator"
)

method_summary |>
  mutate(
    method_label = method_labels[FORMAINICIACAO],
    percentage = total_count / sum(total_count) * 100
  ) |>
  ggplot(aes(x = reorder(method_label, -total_count), y = total_count / 1e9)) +
  geom_col(fill = "#008060") +
  geom_text(
    aes(label = sprintf("%.1f%%", percentage)),
    vjust = -0.5, size = 3
  ) +
  scale_y_continuous(
    labels = scales::number_format(suffix = "B"),
    expand = expansion(mult = c(0, 0.15))
  ) +
  labs(
    title = "PIX Transactions by Initiation Method",
    subtitle = "September 2025",
    x = "Initiation Method",
    y = "Transaction Count (Billions)",
    caption = "Source: Brazilian Central Bank Open Data"
  )
```

## Example 11: Creating a Summary Report

Generate a comprehensive summary report:

``` r
# Function to create a PIX summary for a given month
create_pix_summary <- function(database, date) {
  # Keys data
  keys <- get_pix_keys(date = date, verbose = FALSE)
  keys_summary <- keys |>
    summarise(
      total_keys = sum(qtdChaves, na.rm = TRUE),
      n_institutions = n_distinct(ISPB)
    )
  
  # Transaction stats
  stats <- get_pix_summary(database = database, group_by = "NATUREZA", verbose = FALSE)
  stats_total <- stats |>
    summarise(
      total_value = sum(total_value),
      total_count = sum(total_count)
    )
  
  # State data
  state <- get_pix_transactions_by_state(database = database, verbose = FALSE)
  top_state <- state |>
    mutate(total = vl_pagador_pf + vl_pagador_pj) |>
    slice_max(total, n = 1) |>
    pull(Estado)
  
  list(
    period = database,
    total_keys = keys_summary$total_keys,
    n_institutions = keys_summary$n_institutions,
    transaction_count = stats_total$total_count,
    transaction_value = stats_total$total_value,
    avg_transaction = stats_total$total_value / stats_total$total_count,
    top_state = top_state
  )
}

# Generate summary for September 2025
summary_sep_2025 <- create_pix_summary(
  database = "202509",
  date = "2025-09-01"
)

# Print formatted summary
cat(sprintf(
  "
=== PIX Summary Report: %s ===

📊 Keys & Participants
  - Total registered keys: %s
  - Active institutions: %d

💳 Transactions
  - Monthly count: %s
  - Monthly value: %s
  - Average transaction: %s

🗺️ Regional
  - Most active state: %s
",
  summary_sep_2025$period,
  format(summary_sep_2025$total_keys, big.mark = ","),
  summary_sep_2025$n_institutions,
  format(summary_sep_2025$transaction_count, big.mark = ","),
  format_brl(summary_sep_2025$transaction_value),
  format_brl(summary_sep_2025$avg_transaction),
  summary_sep_2025$top_state
))
```

## Example 12: Exporting Data

Export data for use in other tools:

``` r
# Get comprehensive dataset
keys <- get_pix_keys(date = "2025-12-01")

# Export to CSV
write.csv(keys, "pix_keys_202512.csv", row.names = FALSE)

# Export to Excel (requires writexl package)
# writexl::write_xlsx(keys, "pix_keys_202512.xlsx")

# Export multiple sheets
# writexl::write_xlsx(
#   list(
#     keys = keys,
#     stats = get_pix_transaction_stats(database = "202512"),
#     states = get_pix_transactions_by_state(database = "202512")
#   ),
#   "pix_data_202512.xlsx"
# )
```

## Tips for Large-Scale Analysis

``` r
# 1. Use column selection to reduce memory usage
small_data <- get_pix_keys(
  date = "2025-12-01",
  columns = c("Nome", "TipoChave", "qtdChaves"),
  verbose = FALSE
)

# 2. Use filters to reduce data transfer
filtered <- get_pix_transactions_by_municipality(
  database = "202512",
  filter = "Estado eq 'SÃO PAULO'",
  verbose = FALSE
)

# 3. Process multiple months efficiently
process_quarter <- function(year, quarter) {
  months <- switch(quarter,
    "Q1" = c("01", "02", "03"),
    "Q2" = c("04", "05", "06"),
    "Q3" = c("07", "08", "09"),
    "Q4" = c("10", "11", "12")
  )
  
  databases <- paste0(year, months)
  get_pix_transaction_stats_multi(databases)
}

# Get Q3 2025 data
# q3_2025 <- process_quarter(2025, "Q3")
```

## See Also

- [Introduction to
  pixr](https://monitoramento.pe.gov.br/pixr/articles/pixr.md) - Getting
  started
- [Understanding PIX
  Data](https://monitoramento.pe.gov.br/pixr/articles/understanding-pix-data.md) -
  Data structure
- [Working with OData
  Queries](https://monitoramento.pe.gov.br/pixr/articles/odata-queries.md) -
  Advanced queries with filters
