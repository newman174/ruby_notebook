require 'json-schema'
require_relative '../notebook'
require 'pry'

nb = Notebook.new
# schema = File.read('/home/pi/Documents/ruby_notebook/docs/ipynb_json_schema.json')
nb.add_code_cell("p 'hello world'")
# nb.add_numbered_subheadings(5)
# nb.save
# puts JSON::Validator.fully_validate(schema, nb.to_json)
nb2 = Notebook.open(nb.to_json)
# binding.pry
