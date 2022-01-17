# Notebook.rb

Notebook.rb is a Ruby Class for Jupyter Notebooks

## File Formats

### Jupyter Notebook: `.ipynb`

[Format Description](https://github.com/jupyter/nbformat/blob/master/docs/format_description.rst)

Notebook files are JSON dictionaries.

2.0
- [x] Init notebooks with a cell containing the metadata
- [x] Pretty generate

### Planned Features

2.1
- [ ] Built in json schema validation

2.x
- [/] Cell / group IDs
- [ ] Under the hood overhaul
- [ ] insert cell
- [ ] `inspect` and `to_s` improvements
- [ ] rename `cell.hash` to `cell.to_h`