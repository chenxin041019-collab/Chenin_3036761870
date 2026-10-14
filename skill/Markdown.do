Replication README for Card and Krueger (1994)
Author: Chenxin
Dataset: public.csv.

Project Overview
This repository replicates the core empirical results of Card and Krueger (1994), including descriptive statistics, DiD regressions, wage-gap specifications, price regressions and non-wage benefit tests (Table 3–Table 7). Table 8 cannot be replicated due to missing geographic/new store data.

Requirements
- Software: Stata 16 or newer
- Data file: njmin.dta (placed in the same working folder)
- Main do-file: replication.do

Instructions to reproduce results
1. Open Stata and set your working directory to the folder containing njmin.dta and replication.do
2. Run the do-file replication.do sequentially.
   Step1: Load data, clean variables, generate constructed variables (nj dummy, wage gap, ownership dummies)
   Step2: Generate descriptive statistics for Table 1 & Table 2
   Step3: Run baseline DID and wage-gap regressions for Table3, Table4
   Step4: Estimate non-wage outcome regressions for Table6
   Step5: Estimate price effect regressions for Table7
   Step6: Run heterogeneity regressions by store ownership (extension analysis)
3. All regression outputs will appear in Stata results window. The tables in the report are manually compiled from these Stata outputs.

Reusable workflow to generate main tables and figures
All results are produced with a single structured Stata do-file, following a modular, reproducible workflow.
1. **Data loading and cleaning module**: Load the `njmin.dta` dataset, drop invalid observations, label variables, and construct derived variables (DiD dummy, wage gap, ownership indicators, etc.). This step only runs once at the start and creates a clean analytical dataset.
2. **Descriptive statistics module**: Codes for Table 1 and Table 2 calculate summary statistics and group-wise means, which can be re-run at any time to update descriptive tables.
3. **Regression module**: Separate code blocks estimate baseline DiD, wage-gap, non-wage benefit and price regressions for Table3,4,6,7. Each block stores regression estimates.
4. **Table export module**: Regression outputs can be exported using `esttab` to automatically generate formatted Markdown/LaTeX tables.
5. **Sensitivity check**: The code can be re-executed entirely from start to finish. If the raw dataset remains unchanged, re-running the whole do-file will reproduce identical coefficients, standard errors and summary statistics.

The workflow is modular: individual sections can be run independently to regenerate a single table without re-running the entire project. All data manipulation and estimation steps are recorded in code, rather than manual point-and-click operations, so every number in the report is traceable and replicable.

Notes & Limitations
1. Table 8 cannot be replicated, as the dataset lacks county-level population and new store entry variables.
2. Minor numerical differences between replication and original paper come from sample filtering and robust standard error choices.
3. AI was used to draft code templates and text, all code was manually tested and corrected in Stata.

AI-use disclosure
Where and how AI was used
AI was used to draft Stata code for the independent heterogeneity extension across store ownership types, generate regression table templates, structure the empirical interpretation of estimation outputs, and refine academic writing for the extension section and conclusion. AI helped organise the logical framework for the replication report and suggested ways to align the discussion with Card and Krueger's original theoretical arguments. All raw regression estimation was run independently by me in Stata using the `njmin.dta` dataset.

How AI-generated code, analysis, and writing were checked
All AI-provided Stata syntax was manually tested in Stata. I cross-checked the generated regression outputs against the raw Stata results, verified coefficient values, standard errors and p-values. AI-drafted text was reviewed line by line to ensure consistency with my empirical findings. I also compared the analysis against the original Card and Krueger (1994) paper to confirm the economic interpretation matched the research context. All final numbers and claims in the report are based on my own Stata runs.

Important AI errors or suggestions that you corrected or rejected
1. AI initially miscalculated the total marginal effect of `gap1` for company-owned stores in the price regression; I manually recalculated and corrected this value.
2. AI's first draft omitted the requirement to replicate Table 6 (non-wage benefits) from the original paper. I rejected this omission and added Table 6 replication and discussion into the report structure.
3. Some early AI interpretations overstated the causal implication of the significant price interaction term; I revised the wording to emphasise that the result is correlational and limited by the dataset's scope.
