class Notebook
  require 'json'
  include FileTools

  # Class Methods
  
  def self.to_s
    'Notebook'
  end

  def blank_nb_hash
    { "cells" => [],
      "metadata" => {"kernelspec"=>{"display_name"=>"Ruby 3.0.1", "language"=>"ruby", "name"=>"ruby"}, "language_info"=>{"file_extension"=>".rb", "mimetype"=>"application/x-ruby", "name"=>"ruby", "version"=>"3.0.1"}, "orig_nbformat"=>4},
      "nbformat" => 4,
      "nbformat_minor" => 2 }
  end
  
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
  
  def self.to_json(nb_hash)
    JSON.generate(nb_hash)
  end

  def self.save(nb_hash, file_name, dir: Dir.pwd, folder: false)
    Dir.mkdir(dir) unless Dir.exist?(dir)
    
    nb_json = self.to_json(nb_hash)
    
    file_name += '.ipynb' unless file_name.end_with?('.ipynb')

    Dir.chdir(dir) do
      File.open(file_name, 'w+') do |file|
        file.write(nb_json)
        puts "File saved as #{dir}/#{file_name}"
      end
    end
  end

  # TODO: Should be in filetools
  # def self.fn_format(name)
  #   name = str.downcase.gsub!(' ', '_').gsub!(/\W/,'')
  # end

  def self.append_cell_to_nb_hash!(cell, nb_hash)
    nb_hash['cells'].push(cell)
  end

  # def self.clear(notebook)
  #   notebook.nb_hash = blank_nb_hash
  # end
  
  # Instance Methods

  attr_accessor :nb_hash, :title, :cells, :file_name

  def initialize(title: 'New Notebook', nb_hash: self.class.blank_nb_hash)
    self.nb_hash = nb_hash
    self.title = title
    self.cells = nb_hash['cells']
    self.file_name = FileTools.fn_format(title)
  end

  def add_cell(cell)
    nb_hash['cells'].push(cell)
  end

  def <<(cell)
    add_cell(cell)
  end

  def push(cell)
    add_cell(cell)
  end

  def save(fname: file_name, dir: Dir.pwd)
    unless fname.nil? || fname == ''
      self.class.save(nb_hash, fname, dir: dir)
      return
    end
    puts "Error: No file name set. Use `nb.file_name = 'file_name'`"
  end

  def clear
    self.nb_hash = blank_nb_hash
  end

  def size
    cells.size
  end

  def to_s
    title
  end
end
Notebook.new