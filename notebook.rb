# frozen_string_literal: true

require 'pry'
require '~/ruby_filetools/filetools'
# require '~/Documents/ruby_filetools/filetools'
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
                      'orig_nbformat' => 4,
                      'my_metadata' => {
                        'title' => nil,
                        'file_name' => '',
                        'created' => ''
                      }
                    },
                    'nbformat' => 4,
                    'nbformat_minor' => 2 }.freeze

  def self.to_s
    'Notebook'
  end

  # Open JSON Notebook file (.ipynb) and return a Notebook object
  def self.open(nb_json_file_name)
    opened_nb_hash = File.open(nb_json_file_name) do |file|
      JSON.parse(file.read)
    end
    new_nb = new(existing_nb_hash: opened_nb_hash)
    new_nb.file_name = nb_json_file_name
    new_nb
  end

  attr_accessor :nb_hash

  def initialize(title: nil, existing_nb_hash: nil)
    self.nb_hash = existing_nb_hash.dup ||
                   self.class::BLANK_NB_HASH.dup
    self.title = title || self.title || "New Notebook"
    cell_hashes_to_objects!
    self.file_name = FileTools.fn_format(title)
    add_title_cell unless existing_nb_hash 
    # self.created = Time.new
  end

  def cell_hashes_to_objects!
    self.cells = cells.map do |cell_hsh|
      NotebookCell.new(existing_hash: cell_hsh)
    end
  end

  def my_metadata
    nb_hash['metadata']['my_metadata']
  end

  def title
    my_metadata['title']
  end

  def title=(title)
    my_metadata['title'] = title
  end

  def cells
    nb_hash['cells']
  end

  def cells=(cls)
    nb_hash['cells'] = cls
  end

  def file_name
    my_metadata['file_name']
  end

  def file_name=(fname)
    my_metadata['file_name'] = fname
  end

  def to_json(*_args)
    # binding.pry
    duped_nb_hash = nb_hash.dup
    duped_nb_hash['cells'] = nb_hash['cells'].dup
    # binding.pry
    duped_nb_hash['cells'] = duped_nb_hash['cells'].map(&:to_h)
    # binding.pry
    JSON.generate(duped_nb_hash)
  end

  # def save(file_name: self.file_name, dir: Dir.pwd)
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

  # Add a code cell to the notebook.
  def add_code_cell(cell = CodeCell.new)
    cell = NotebookCell.new(source: cell) unless cell.is_a?(NotebookCell)
    cells << cell.dup
  end

  # Add a markdown cell to the notebook.
  def add_markdown_cell(cell = '', heading_level = 0)
    unless cell.is_a?(NotebookCell)
      cell = NotebookCell.new(source: cell,
                              cell_type: 'markdown',
                              heading_level: heading_level)
    end

    cells << cell.dup
  end

  alias add_cell add_markdown_cell
  alias << add_markdown_cell
  alias push add_markdown_cell

  def add_title_cell
    heading = "# #{title}"
    add_markdown_cell(heading, 1)
  end

  def size
    cells.size
  end

  def to_s
    title
  end

  def to_h
    nb_hash
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

  def add_numbered_subheadings(last, first: 1, hlevel: 2)
    first.upto(last) do |num|
      text = "#{'#' * hlevel} #{format('%02i', num)}"
      add_markdown_cell(text, hlevel)
    end
  end
end

# nb = Notebook.new(title: 'New Notebook')
nb = Notebook.open('new_notebook.ipynb')
# nb.push(Time.now.to_s)
# code = "puts 'hello world'"
# nb << NotebookCell.new(source: code)
# puts nb.cells.last.to_s
# puts nb.to_json
# puts Time.now
binding.pry

nb.save
# binding.pry
