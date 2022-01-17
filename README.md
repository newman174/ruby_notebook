# Notebook.rb

Notebook.rb is a Ruby Class for Jupyter Notebooks

## File Formats

### Jupyter Notebook: `.ipynb`

[Format Description](https://github.com/jupyter/nbformat/blob/master/docs/format_description.rst)

Notebook files are JSON dictionaries.

0.2.0
- [x] Init notebooks with a cell containing the metadata
- [x] Pretty generate

### Planned Features

0.2.1
- [x] Cell / group IDs
- [x] info cells
- [x] rename `cell.hash` to `cell.to_h`
- [/] `inspect` and `to_s` improvements

0.3.x
- [ ] Under the hood overhaul