# indian-liver-pd
Predicting liver patients from data

Data Source: https://archive.ics.uci.edu/ml/datasets/ILPD+(Indian+Liver+Patient+Dataset)

First Approach (rather naive)

-- Feature selection: normalized data and constructed a correlation matrix. Removed highly correlated features.

-- Test/train split: 50/50 split from existing data. Only 583 instances. 

-- Model: fit a simple logistic regression model

-- Results: 73 percent accuracy
