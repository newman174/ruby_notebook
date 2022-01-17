require 'json-schema'
require_relative '../notebook'
require 'pry'

nb = Notebook.new
schema = File.read('/home/pi/Documents/ruby_notebook/docs/ipynb_json_schema.json')
nb.add_code_cell("p 'hello world'")
nb.save
p JSON::Validator.fully_validate(schema, nb.to_json)
# binding.pry
