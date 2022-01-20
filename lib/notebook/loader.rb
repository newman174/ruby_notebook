# frozen_string_literal: true

require_relative '../notebook'

class Loader; end

class CellLoader < Loader
  def self.open(cell_hash)
    case cell_hash['cell_type']
    when 'code'
      open_code_cell(cell_hash)
    when 'markdown'
      open_markdown_cell(cell_hash)
    else
      raise TypeError, "Invalid cell_type"
    end
  end

  def self.open_code_cell(cell_hash)
    cell = CodeCell.new
    # The attribute setters should be moved into the respective cell subclasses.
    set_universal_attributes(cell, cell_hash)
    set_code_cell_attributes(cell, cell_hash)
    cell
  end

  def self.open_markdown_cell(cell_hash)
    cell = MarkdownCell.new
    set_markdown_cell_attributes(cell, cell_hash)
    cell
  end

  def self.set_universal_attributes(cell, cell_hash)
    cell.cell_type = cell_hash['cell_type']
    cell.id = cell_hash['id']
    cell.tags = cell_hash['metadata']['tags']
    cell.heading_level = cell_hash['metadata']['heading_level']
    cell.source = cell_hash['source']
    cell.name = cell_hash['metadata']['name']
    cell
  end

  def self.set_markdown_cell_attributes(cell, cell_hash)
    set_universal_attributes(cell, cell_hash)
  end

  def self.set_code_cell_attributes(cell, cell_hash)
    cell.collapsed = cell_hash['metadata']['collapsed']
    cell.execution_count = cell_hash['execution_count']
    cell.outputs = cell_hash['outputs']
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
