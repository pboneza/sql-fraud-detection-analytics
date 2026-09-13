# Data

This directory will contain documentation and permitted sample data for the project.

## Planned layout

```text
data/
├── raw/        Original, unchanged source data
├── processed/  Generated data products
└── sample/     Small, shareable examples for reproducibility
```

## Rules

1. Do not modify files in `data/raw/`.
2. Do not commit confidential, personal, or credential-related information.
3. Check dataset licence and redistribution conditions before committing data.
4. Keep large raw and processed files outside Git history.
5. Document the source, download date, file names, row counts, columns, and known limitations.
6. Produce processed data through reproducible SQL or code.
7. Commit only small samples when redistribution is permitted.

The dataset will be selected and documented during Milestone 1.
