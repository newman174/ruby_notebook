# frozen_string_literal: true

require 'pry'
require '~/ruby_filetools/filetools'
require '~/Documents/ruby_filetools/filetools'
require_relative 'cell'

# Jupyter Notebook Tools for Ruby
class Notebook
  require 'json'
  include FileTools

  NB_RUBY_VERSION = '3.0.1'

  BLANK_NB_HASH = { 'cells' => [],
                    'metadata' => { 'kernelspec' => { 'display_name' => "Ruby #{NB_RUBY_VERSION}",
                                                      'language' => 'ruby',
                                                      'name' => 'ruby' },
                                    'language_info' => { 'name' => 'ruby' },
                                    'orig_nbformat' => 4 },
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
    new_nb = new(nb_hash: nb_hash).file_name
    new_nb.file_name = nb_json_file_name
    new_nb.cells = nb_json_file_name
  end

  attr_accessor :title, :cells, :file_name, :created

  def initialize(title: 'New Notebook', nb_hash: self.class::BLANK_NB_HASH)
    @nb_hash = nb_hash
    self.title = title
    self.cells = []
    self.file_name = FileTools.fn_format(title)
    self.created = Time.new
    add_title_cell unless title.nil?
  end

  def to_json(*_args)
    JSON.generate(nb_hash)
  end

  # def save(file_name: self.file_name, dir: Dir.pwd, folder: false)
  def save(file_name: self.file_name, dir: Dir.pwd)
    Dir.mkdir(dir) unless Dir.exist?(dir)

    file_name += '.ipynb' unless file_name.end_with?('.ipynb')

    Dir.chdir(dir) do
      File.open(file_name, 'w+') do |file|
        file.write(to_json)
        puts "File saved as #{dir}/#{file_name}"
      end
    end
  end

  # Add a cell to the notebook.
  def add_cell(cell = Cell.new)
    cell = Cell.new(content: cell) unless cell.instance_of?(Cell)
    cells << cell
  end

  alias << add_cell
  alias push add_cell

  def add_title_cell
    add_cell(content: title, heading_level: 1)
  end

  def size
    cells.size
  end

  def to_s
    title
  end

  def to_h
    @nb_hash['cells'] = cells.map(&:hash)
    @nb_hash
  end

  def inspect
    output = []
    output << "Title: #{title}\n\n"
    output << 'Cells:'
    cells.each_with_index do |cell, index|
      output << "#{index + 1}. #{cell.type.capitalize} Cell"
      output << cell.content
    end
    output
  end
end

nb = Notebook.new
nb.push('yo yo')
nb << 'what it done?'
puts nb.inspect
nb.save
binding.pry
