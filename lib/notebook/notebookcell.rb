# frozen_string_literal: true

# Cell for Jupyter Notebook
class NotebookCell
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize

  def self.open(cell_hash)
    cell = new

    cell.cell_type = cell_hash['cell_type']
    cell.id = cell_hash['id']
    cell.tags = cell_hash['metadata']['tags']
    cell.heading_level = cell_hash['metadata']['heading_level']
    cell.source = cell_hash['source']
    cell.name = cell_hash['metadata']['name']

    if cell.cell_type == 'code'
      cell.collapsed = cell_hash['metadata']['collapsed']
      cell.execution_count = cell_hash['execution_count']
      cell.outputs = cell_hash['outputs']
    end

    cell
  end

  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def self.to_s
    self.class.to_s
  end

  attr_accessor :heading_level, :id, :execution_count, :collapsed, :outputs, :name

  attr_reader :source, :tags, :cell_type

  def initialize(source: '',
                 cell_type: 'code',
                 heading_level: 0,
                 tags: '')

    self.source = source
    self.cell_type = cell_type
    self.heading_level = heading_level
    self.tags = tags
    self.id = generate_id
    self.execution_count = execution_count
    self.outputs = []
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

  # rubocop:disable Metrics/MethodLength

  def to_h
    hsh = { 'cell_type' => cell_type,
            'id' => id,
            'metadata' => {
              'tags' => tags,
              'heading_level' => heading_level,
              'name' => name
            },
            'source' => source }

    if cell_type == 'code'
      hsh['metadata']['collapsed'] = collapsed
      hsh['execution_count'] = execution_count
      hsh['outputs'] = outputs
    end

    hsh
  end

  # rubocop:enable Metrics/MethodLength

  def generate_id
    Time.now.to_f.to_s.delete('.')
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

  def output_text
    outputs.map do |output|
      output['text'] || output['evalue']
    end
  end
end
