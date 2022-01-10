require '~/ruby_filetools/filetools'
require_relative 'cell'

class Notebook
  require 'json'
  include FileTools

  # Class Methods

  NB_RUBY_VERSION = '3.0.1'
  
  BLANK_NB_HASH = { 'cells' => [],
                    'metadata' => { 'kernelspec' => { 'display_name' => "Ruby #{NB_RUBY_VERSION}",
                                                     'language' => 'ruby',
                                                     'name' => 'ruby' },
                                    'language_info' => { 'name' => 'ruby' },
                                    'orig_nbformat' => 4 },
                    'nbformat' => 4,
                    'nbformat_minor' => 2 }
                
  def self.to_s
    'Notebook'
  end

  # def self.blank_nb_hash
  #   { "cells" => [],
  #     "metadata" => {"kernelspec"=>{"display_name"=>"Ruby 3.0.1", "language"=>"ruby", "name"=>"ruby"}, "language_info"=>{"file_extension"=>".rb", "mimetype"=>"application/x-ruby", "name"=>"ruby", "version"=>"3.0.1"}, "orig_nbformat"=>4},
  #     "nbformat" => 4,
  #     "nbformat_minor" => 2 }
  # end
  
  # Notebook.load(nb_file_name)
  # open json nb file and returns a nb_hash
  def self.open(nb_file_name)
    nb_hash = File.open(nb_file_name) do |file|
      JSON.parse(file.read)
    end
    # TODO: automate setting the title variable on open
    # puts nb_hash
    self.new(file_name: nb_file_name, nb_hash: nb_hash)
  end
  
  
  # TODO: Should be in filetools
  # def self.fn_format(name)
  #   name = str.downcase.gsub!(' ', '_').gsub!(/\W/,'')
  # end
  
  # def self.append_cell_to_nb_hash!(cell, nb_hash)
  #   nb_hash['cells'].push(cell)
  # end
  
  # Instance Methods
  
  attr_accessor :title, :cells, :file_name, :created
  
  def initialize(title: 'New Notebook')
    # @nb_hash = self.class::BLANK_NB_HASH
    self.title = title
    self.cells = []
    self.file_name = FileTools.fn_format(title)
    self.created = Time.new
    add_title_cell unless title.nil?
  end
  
  def to_json
    JSON.generate(nb_hash)
  end

  def save(file_name: self.file_name, dir: Dir.pwd, folder: false)
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
    cell = Cell.new(content: cell) unless cell.class == Cell
    cells << cell
  end

  alias_method :<<, :add_cell
  alias_method :push, :add_cell

  def add_title_cell
    add_cell(content: title, heading_level: 1)
  end

  # def save(fname: file_name, dir: Dir.pwd)
  #   unless fname.nil? || fname == ''
  #     self.class.save(nb_hash, fname, dir: dir)
  #     return
  #   end
  #   puts "Error: No file name set. Use `nb.file_name = 'file_name'`"
  # end

  def clear!
    @nb_hash = self.class::BLANK_NB_HASH
  end

  def size
    cells.size
  end

  def to_s
    title
  end

  def to_h
    @nb_hash['cells'] = cells.map { |cell| cell.hash}
  end

  def inspect
    output = []
    output << "Title: #{title}\n\n"
    output << "Cells:"
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