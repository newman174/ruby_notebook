# frozen_string_literal: true

require_relative 'nbtools'

# Cells for Jupyter Notebooks
class NotebookCell
  GENERAL_CELL_ATTRIBUTES = [:heading_level, :id, :name,
                             :source, :cell_type, :tags]

  attr_accessor :heading_level,
                :id,
                :name

  attr_reader :source,
              :tags,
              :cell_type

  def initialize(source: '',
                 cell_type: 'markdown',
                 heading_level: 0,
                 tags: 'default')

    self.source = source
    self.cell_type = cell_type
    self.heading_level = heading_level
    self.tags = tags
    self.id = NBTools.generate_id
    self.name = ''
  end

  def source=(new_source)
    new_source = [new_source] unless new_source.is_a?(Array)
    @source = new_source
  end

  def tags=(new_tags)
    new_tags = [new_tags] unless new_tags.is_a?(Array)
    @tags = new_tags
  end

  def cell_type=(new_type)
    raise TypeError unless ['markdown', 'code'].include?(new_type)
    @cell_type = new_type
  end

  def to_h
    { 'cell_type' => cell_type,
      'id' => id,
      'metadata' => {
        'tags' => tags,
        'heading_level' => heading_level,
        'name' => name
      },
      'source' => source }
  end

  # def inspect
  #   details = []
  #   details << "Cell Type: #{cell_type}"
  #   details << "Name: #{name}"
  #   details << "Tags: #{tags.join(', ')}"
  #   begin
  #     details << "Lines: #{source.lines.size}"
  #     details << "First Line: #{source.lines[0]}"
  #   rescue NoMethodError
  #     details << "Source: #{source}"
  #   end
  #   details << "\n"
  #   details
  # end

  def to_s
    source
  end

  def ==(other)
    source == other.source
  end
end

class MarkdownCell < NotebookCell; end

class CodeCell < NotebookCell
  CODE_CELL_ATTRIBUTES = GENERAL_CELL_ATTRIBUTES +
                         [:heading_level, :id, :name,
                          :source, :cell_type, :tags]

  attr_accessor :execution_count,
                :collapsed,
                :outputs

  def initialize(source: '', tags: 'default')
    super(source: source, heading_level: 0, tags: tags, cell_type: 'code')
    self.execution_count = 0
    self.outputs = []
    self.collapsed = false
  end

  def to_h
    hsh = super
    hsh['metadata']['collapsed'] = collapsed
    hsh['execution_count'] = execution_count
    hsh['outputs'] = outputs
    hsh
  end

  # def output_text
  #   outputs.map do |output|
  #     output['text'] || output['evalue']
  #   end
  # end
end
