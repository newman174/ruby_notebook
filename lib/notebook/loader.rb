# frozen_string_literal: true

require_relative '../notebook'

class Loader; end

class CellLoader < Loader
  def self.open(cell_hash)
    cell = NotebookCell.new

    cell.cell_type = cell_hash['cell_type']
    cell.id = cell_hash['id']
    cell.tags = cell_hash['metadata']['tags']
    cell.heading_level = cell_hash['metadata']['heading_level']
    cell.source = cell_hash['source']
    cell.name = cell_hash['metadata']['name']

    if cell.cell_type == 'code'
      cell.collapsed = cell_hash['metadata']['collapsed']
      cell.execution_count = cell_hash['execution_count']
      cell.outputs = cell_hash['outputs']
    end

    cell
  end
end

class NBLoader < Loader
  def self.open(nb_json)
    opened_nb_hash = read_json(nb_json)
    new_nb = Notebook.new
    new_nb.import_cells(opened_nb_hash)
    new_nb.authors = opened_nb_hash['metadata']['authors']
    new_nb.set_custom_metadata(opened_nb_hash, 'my_metadata')
    new_nb
  end

  def self.read_json(nb_json)
    nb_json = File.read(nb_json) unless json?(nb_json)
    JSON.parse(nb_json)
  end

  def self.json?(input)
    input.start_with?('{')
  end

  private_class_method :read_json, :json?
end
