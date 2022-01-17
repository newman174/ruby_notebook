# frozen_string_literal: true

# Cell for Jupyter Notebook
class NotebookCell
  include Comparable

  attr_accessor :to_h

  def initialize(source: '',
                 cell_type: 'code',
                 existing_hash: nil,
                 heading_level: nil,
                 tags: '')
    raise TypeError unless existing_hash.nil? || existing_hash.is_a?(Hash)
    @id = generate_id
    tags = [tags] unless tags.is_a?(Array)
    @tags = tags
    self.to_h = !!existing_hash ||
                make_cell_hash(source: source, cell_type: cell_type)
    self.heading_level = heading_level
  end

  def source
    to_h['source']
  end

  def source=(srce)
    srce = [srce] unless srce.is_a?(Array)
    to_h['source'] = srce
  end

  def cell_type
    to_h['cell_type']
  end

  def cell_type=(type)
    to_h['cell_type'] = type
  end

  def metadata
    to_h['metadata']
  end

  def metadata=(data)
    to_h['metadata'] = data
  end

  def tags
    metadata['tags']
  end

  def tags=(tgs)
    tgs = [tgs] unless tgs.is_a?(Array)
    metadata['tags'] = tgs
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
    to_h['outputs']
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

  # rubocop:disable Metrics/MethodLength

  def make_cell_hash(source: '', cell_type: 'code', heading_level: nil)
    source = [source] unless source.is_a?(Array)

    hsh = { 'cell_type' => cell_type,
            'id' => @id,
            'metadata' => {
              'tags' => @tags,
              'heading_level' => heading_level
            },
            'source' => source }

    if cell_type == 'code'
      hsh['metadata']['collapsed'] = false
      hsh['execution_count'] = 0
      hsh['outputs'] = []
    end

    hsh
  end

  # rubocop:enable Metrics/MethodLength

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

  def <=>(other)
    # source <=> other.source
    id <=> other.id
  end
end
