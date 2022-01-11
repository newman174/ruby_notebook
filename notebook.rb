# frozen_string_literal: true

require 'pry'
# require '~/ruby_filetools/filetools'
require '~/Documents/ruby_filetools/filetools'
require_relative 'notebookcell'

# Jupyter Notebook Tools for Ruby
class Notebook
  require 'json'
  include FileTools

  NB_RUBY_VERSION = '3.0.1'

  BLANK_NB_HASH = { 'cells' => [],
                    'metadata' => {
                      'kernelspec' => {
                        'display_name' => "Ruby #{NB_RUBY_VERSION}",
                        'language' => 'ruby',
                        'name' => 'ruby'
                      },
                      'language_info' => { 'name' => 'ruby' },
                      'orig_nbformat' => 4
                    },
                    'nbformat' => 4,
                    'nbformat_minor' => 2 }.freeze

  def self.to_s
    'Notebook'
  end

  # Open JSON Notebook file (.ipynb) and return a Notebook object
  def self.open(nb_json_file_name)
    nb_hash = File.open(nb_json_file_name) do |file|
      JSON.parse(file.read)
    end
    new_nb = new(nb_hash:).file_name
    new_nb.file_name = nb_json_file_name
    new_nb.cells = nb_json_file_name
  end

  attr_accessor :title, :cells, :file_name, :created

  def initialize(title: 'New Notebook', nb_hash: self.class::BLANK_NB_HASH.dup)
    @nb_hash = nb_hash
    self.title = title
    self.cells = []
    self.file_name = FileTools.fn_format(title)
    self.created = Time.new
    add_title_cell unless title.nil?
    refresh_nb_hash
  end

  def to_json(*_args)
    refresh_nb_hash
    JSON.generate(@nb_hash)
  end

  def save(file_name: self.file_name, dir: Dir.pwd)
    Dir.mkdir(dir) unless Dir.exist?(dir)

    file_name += '.ipynb' unless file_name.end_with?('.ipynb')
    refresh_nb_hash
    Dir.chdir(dir) do
      File.open(file_name, 'w+') do |file|
        file.write(to_json)
        puts "File saved as #{dir}/#{file_name}"
      end
    end
  end

  # Add a code cell to the notebook.
  def add_code_cell(cell = CodeCell.new)
    cell = CodeCell.new(source: cell) unless cell.is_a?(NotebookCell)
    cells << cell
    refresh_cells
  end

  # Add a markdown cell to the notebook.
  def add_markdown_cell(cell = MarkdownCell.new, heading_level = 0)
    unless cell.is_a?(NotebookCell)
      cell = MarkdownCell.new(source: cell, heading_level:)
    end
    cells << cell
    refresh_cells
  end

  alias add_cell add_markdown_cell
  alias << add_markdown_cell
  alias push add_markdown_cell

  def add_title_cell
    add_cell(title, 1)
  end

  def size
    cells.size
  end

  def to_s
    title
  end

  def to_h
    refresh_nb_hash
    @nb_hash
  end

  def inspect
    output = []
    output << "Title: #{title}\n\n"
    output << 'Cells:'
    cells.each_with_index do |cell, index|
      output << "#{index + 1}. #{cell.cell_type.capitalize} Cell"
      output << cell.source
    end
    output
  end

  def add_numbered_subheadings(ending, starting: 1, heading_level: 2)
    starting.upto(ending) do |num|
      add_markdown_cell(format('%02i', num), heading_level)
    end
  end

  # private

  def refresh_nb_hash
    refresh_cells
  end

  def refresh_cells
    @nb_hash['cells'] = cells.map(&:to_h)
  end
end

nb = Notebook.new
nb.push('yo yo')
nb << 'what it done?'
nb.add_numbered_subheadings(12)
nb.save
