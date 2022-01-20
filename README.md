# Notebook.rb

Notebook.rb is a Ruby Class for Jupyter Notebooks

## File Formats

### Jupyter Notebook: `.ipynb`

[Format Description](https://github.com/jupyter/nbformat/blob/master/docs/format_description.rst)

Notebook files are JSON dictionaries.

### Cell types:
* code
* markdown
* raw

### Cell attributes

* all
  * cell_type => string
  * metadata => hash/dict
    * my_metadata => hash/dict
      * heading_level
      * id
      * name
      * tags
      * created
  * source => arr

```ruby
  {
  "cell_type" : "type",
  "metadata" : {},
  "source" : "single string or [list, of, strings]",
}
```
  
* code
  * execution_count => int or null
  * metadata => hash/dict (inherited from base class)
    * collapsed => bool
    * scrolled => bool
  * outputs => arr (list of output dicts)
    * {output dicts}
    * { "output_type" : "stream",
        "name" : "stdout", # or stderr
        "text" : "[multiline stream text]" }

* markdown
* raw

## Change Log

**0.2.0**

- [x] Init notebooks with a cell containing the metadata
- [x] Pretty generate


**0.2.1**

- [x] Cell / group IDs
- [x] info cells
- [x] rename `cell.hash` to `cell.to_h`
- [/] `inspect` and `to_s` improvements

**0.2.2** => jump to **0.3.0**

**0.3.0**

- [X] Under the hood overhaul

**0.3.1
**
- [x] Encapsulate loader to class
- [X] Encapsulate ID generator to class

**0.3.2**

- [x] Split notebookcell class to code and markdown cell subclasses
- [x] Move formatters to their own class
- [x] Other minor refactoring
- [x] Change required ruby version to >= 3.0.0

**x.x.x**

- [ ] Reserved cell names list (notebook instance method?)
