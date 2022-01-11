# frozen_string_literal: true

# TODO: Work on sharpening the input types... string or array of strings? Done?

# Cell for Jupyter Notebook
class NotebookCell
  include Comparable

  attr_accessor :cell_type, :source, :hash

  def initialize(source: '', cell_type: 'code')
    self.hash = make_cell_hash(source: source, cell_type: cell_type)
    self.cell_type = hash['cell_type']
    self.source = hash['source']
  end

  def make_cell_hash(source: '', cell_type: 'code')
    source = [source] unless source.is_a?(Array)

    { 'cell_type' => cell_type,
      'execution_count' => 0,
      'metadata' => {},
      'outputs' => [],
      'source' => source }
  end

  def inspect
    details = []
    details << "Cell Type: #{cell_type}"
    # details << "source:"
    details << "Lines: #{source.lines.size}"
    details << "First Line: #{source.lines[0]}"
    # details << "\n"
    details
  end

  def to_s
    source
  end

  def to_h
    hash
  end

  def <=>(other)
    source <=> other.source
  end
end

# Code Cells for Notebooks
class CodeCell < NotebookCell; end

# Markdown Cells for Notebooks
class MarkdownCell < NotebookCell
  attr_accessor :heading_level

  def initialize(source: '', heading_level: 0)
    super(source: source, cell_type: 'markdown')
    self.heading_level = heading_level
    self.hash = make_md_cell(source: source, heading_level: heading_level)
  end

  def make_md_cell(source: '', heading_level: 0)
    if heading_level.positive?
      hash_marks = '#' * heading_level
      self.source = "#{hash_marks} #{source}"
    end

    make_cell_hash(cell_type: 'markdown', source: self.source)
  end
end
