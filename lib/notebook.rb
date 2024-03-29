# frozen_string_literal: true

require_relative 'notebook/notebookcell'
require_relative 'notebook/loader'
require_relative 'notebook/nbtools'
require_relative 'notebook/formatter'

require 'json'

# Jupyter Notebook Tools for Ruby
class Notebook
  NB_RUBY_VERSION = '3.1.0'

  DEFAULT_AUTHOR = 'newms'

  BLANK_NB_HASH = { 'cells' => [],
                    'metadata' => {
                      'kernelspec' => {
                        'display_name' => "Ruby #{NB_RUBY_VERSION}",
                        'language' => 'ruby',
                        'name' => 'ruby'
                      },
                      'language_info' => { 'name' => 'ruby' },
                      'orig_nbformat' => 4,
                      'authors' => [{ 'name' => DEFAULT_AUTHOR }],
                      'my_metadata' => {
                        'title' => nil,
                        'file_name' => '',
                        'created' => ''
                      }
                    },
                    'nbformat' => 4,
                    'nbformat_minor' => 5 }.freeze

  def self.to_s
    'Notebook'
  end

  def self.open(nb_json)
    NBLoader.open(nb_json)
  end

  attr_accessor :cells, :authors, :title, :file_name, :created

  def initialize(title = 'New Notebook')
    self.cells = []
    self.authors = [{ name: DEFAULT_AUTHOR }]
    self.title = title
    self.file_name = Formatter.snake_case(title)
    self.created = Time.now.to_s
    add_title_cell
    add_info_cell
  end

  def to_json(*_args)
    duped_nb_hash = to_h.dup
    duped_nb_hash['cells'] = duped_nb_hash['cells'].map(&:to_h)
    JSON.pretty_generate(duped_nb_hash)
  end

  # Save the notebook to `dir:` in JSON with extension `.ipynb`
  def save(dir: Dir.pwd)
    Dir.mkdir(dir) unless Dir.exist?(dir)

    self.file_name = "#{file_name}.ipynb" unless file_name.end_with?('.ipynb')
    Dir.chdir(dir) do
      File.open(file_name, 'w+') do |file|
        if file.write(to_json).positive?
          puts "File saved as #{dir}/#{file_name}"
        end
      end
    end
  end

  def import_cells(nb_hash)
    self.cells = nb_hash['cells'].map do |cell_hash|
      CellLoader.open(cell_hash)
    end
  end

  def set_custom_metadata(nb_hash, namespace)
    nb_hash['metadata'][namespace].each do |k, v|
      send("#{k}=", v)
    end
  end

  # Add a code cell to the notebook.
  def add_code_cell(cell = '', tgs = 'default')
    unless cell.is_a?(NotebookCell)
      cell = CodeCell.new(source: cell, tags: tgs)
    end
    cells << cell.dup
    refresh_info_cell
  end

  # Add a markdown cell to the notebook.
  def add_markdown_cell(cell = '', h_level = 0, tgs = 'default')
    unless cell.is_a?(NotebookCell)
      cell = MarkdownCell.new(source: cell,
                              cell_type: 'markdown',
                              heading_level: h_level,
                              tags: tgs)
    end

    cells << cell.dup
    refresh_info_cell
  end

  alias add_cell add_markdown_cell

  alias << add_markdown_cell

  alias push add_markdown_cell

  def add_title_cell
    cells << MarkdownCell.new(source: "# #{title}",
                              cell_type: 'markdown',
                              heading_level: 1,
                              tags: 'title')
    cells.last.name = 'title'
  end

  # Insert an info cell as the second cell
  def add_info_cell
    info_cell = MarkdownCell.new(tags: 'info')
    cells.insert(1, info_cell)

    lines = []
    lines << "**Authors:** #{list_authors}\n\n"
    lines << "**Created:** #{created}\n\n"
    lines << "**Cells:** #{size}\n\n"
    lines << "**Tags:** #{tags}\n\n"

    cells[1].source = lines
    cells[1].name = 'info'
  end

  def refresh_info_cell
    # TODO: uncomment and test the next line
    # return unless cells.any? { |cell| cell.name == 'info' }
    cells.delete_if { |cell| cell.name == 'info' }
    add_info_cell
  end

  def tags
    cells.map(&:tags).uniq.join(', ')
  end

  def size
    cells.size
  end

  def to_s
    title
  end

  def to_h
    nb_hsh = BLANK_NB_HASH.dup
    nb_hsh['cells'] = cells
    nb_hsh['metadata']['authors'] = authors
    custom_meta = nb_hsh['metadata']['my_metadata']
    custom_meta['title'] = title
    custom_meta['file_name'] = file_name
    custom_meta['created'] = created
    nb_hsh
  end

  def inspect
    output = []
    output << "Title: #{title}"
    output << "Cells: #{size}"
    cells.each_with_index do |cell, index|
      output << "[#{index}] #{cell.cell_type.capitalize} Cell"
      output << "[Tags] #{cell.tags.join(', ')}"
      output << cell.source
      output << ''
    end
    output
  end

  def add_numbered_subheadings(last, first: 1, hlevel: 2)
    first.upto(last) do |num|
      text = "#{'#' * hlevel} #{format('%02i', num)}"
      add_markdown_cell(text, hlevel, num.to_s)
    end
    self
  end

  def ==(other)
    to_h == other.to_h
  end

  private

  def list_authors
    authors.map(&:values).flatten.join(', ')
  end
end
