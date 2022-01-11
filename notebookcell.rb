# frozen_string_literal: true

# Cell for Jupyter Notebook
class NotebookCell
  include Comparable

  attr_accessor :hash

  def initialize(source: '',
                 cell_type: 'code',
                 existing_hash: nil,
                 heading_level: nil)
    self.hash = existing_hash || make_cell_hash(source:, cell_type:)
    self.heading_level = heading_level
  end

  def source
    hash['source']
  end

  def source=(srce)
    srce = [srce] unless srce.is_a?(Array)
    hash['source'] = srce
  end

  def cell_type
    hash['cell_type']
  end

  def cell_type=(type)
    hash['cell_type'] = type
  end

  def metadata
    hash['metadata']
  end

  def metadata=(data)
    hash['metadata'] = data
  end

  def group
    metadata['group']
  end

  def group=(grp)
    metadata['group'] = grp
  end

  def id
    metadata['id']
  end

  def id=(num)
    metadata['id'] = num
  end

  def heading_level
    metadata['heading_level']
  end

  def heading_level=(lvl)
    metadata['heading_level'] = lvl
  end

  def make_cell_hash(source: '', cell_type: 'code', heading_level: nil)
    source = [source] unless source.is_a?(Array)

    { 'cell_type' => cell_type,
      'execution_count' => 0,
      'metadata' => {
        'group' => nil,
        'id' => nil,
        'heading_level' => heading_level
      },
      'outputs' => [],
      'source' => source }
  end

  # def inspect
  #   details = []
  #   details << "Cell Type: #{cell_type}"
  #   # details << "source:"
  #   details << "Lines: #{source.lines.size}"
  #   details << "First Line: #{source.lines[0]}"
  #   # details << "\n"
  #   details
  # end

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
