class Cell
  attr_accessor :type, :content, :hsh

  def initialize(type: 'code', content: '')
    self.hsh = self.class.make_cell_hash(type: type, content: content)
  end
  
  # self.make_cell - Valid cell_type are ['code'*, 'markdown'], *default
  # cell = self.make_cell('yo', 'markdown')
  def self.make_cell_hash(type: 'code', content: '')
    {"cell_type"=>type,
      "execution_count"=>0,
      "metadata"=>{},
      "outputs"=>[],
      "source"=>[content]}
  end

  def self.make_code_cell(content: '')
    self.make_cell_hash(type: 'code', content: content)
  end

  def self.make_md_cell(content: '', heading_level: 0)
    if heading_level.positive?
      hash_marks = '#' * heading_level
      content = hash_marks + ' ' + content
    end

    self.make_cell_hash(type: 'markdown', content: content)
  end
end