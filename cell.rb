# frozen_string_literal: true

# Cell for Jupyter Notebook
class NotebookCell
  attr_accessor :type, :content, :hash

  def initialize(content: '', type: 'code')
    self.hash = make_cell_hash(content: content)
    self.type = type
    self.content = content
  end

  # self.make_cell - Valid cell_type are ['code'*, 'markdown'], *default
  # cell = self.make_cell('yo', 'markdown')
  def make_cell_hash(content: '', type: 'code')
    { 'cell_type' => type,
      'execution_count' => 0,
      'metadata' => {},
      'outputs' => [],
      'source' => [content] }
  end

  def inspect
    details = []
    details << "Type: #{type} Cell"
    # details << "Content:"
    details << "Lines: #{content.lines.size}"
    details << "First Line: #{content.lines.size}"
    # details << "\n"
    details
  end

  def to_s
    content
  end
end

# Code Cells for Notebooks
class CodeCell < NBCell; end

# Markdown Cells for Notebooks
class MarkdownCell < NBCell
  attr_accessor :heading_level

  def initialize(content: '', heading_level: 0)
    super(content: content, type: 'markdown')
    self.heading_level = heading_level
    self.hash = make_md_cell(content: content, heading_level: heading_level)
  end

  def make_md_cell(content: '', heading_level: 0)
    if heading_level.positive?
      hash_marks = '#' * heading_level
      self.content = "#{hash_marks} #{content}"
    end

    make_cell_hash(type: 'markdown', content: self.content)
  end
end

puts MarkdownCell.new(content: 'New Notebook', heading_level: 1)
