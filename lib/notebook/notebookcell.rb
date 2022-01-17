# frozen_string_literal: true

# Cell for Jupyter Notebook
class NotebookCell
  include Comparable

  attr_accessor :hash

  def initialize(source: '',
                 cell_type: 'code',
                 existing_hash: nil,
                 heading_level: nil)
    raise TypeError unless existing_hash.nil? || existing_hash.is_a?(Hash)
    self.hash = !!existing_hash || make_cell_hash(source: source, cell_type: cell_type)
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

  def outputs
    hash['outputs']
  end

  def output_text
    outputs.map do |output|
      output['text'] || output['evalue']
    end
  end

  def collapsed
    metadata['collapsed']
  end

  def collapsed=(bool)
    raise TypeError unless bool.is_a?(TrueClass) || bool.is_a?(FalseClass)
    metadata['collapsed'] = bool
  end

  def make_cell_hash(source: '', cell_type: 'code', heading_level: nil)
    source = [source] unless source.is_a?(Array)

    hsh = { 'cell_type' => cell_type,
            'id' => (self.id = generate_id),
            'metadata' => {
              'group' => 'some_group',
              'heading_level' => heading_level,
              'collapsed' => false
            },
            'source' => source }

    if cell_type == 'code'
      hsh['execution_count'] = 0
      hsh['outputs'] = []
    end
    hsh
  end

  def generate_id
    Time.now.to_f.to_s.delete('.')
  end

  # def inspect
    # details = []
    # details << "Cell Type: #{cell_type}"
    # # details << "source:"
    # begin
    # details << "Lines: #{source.lines.size}"
    # details << "First Line: #{source.lines[0]}"
    # rescue NoMethodError
    #   details << source
    # end
    # details << "\n"
    # details
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
