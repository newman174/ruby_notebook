class Cell
  attr_accessor :type, :content, :heading_level

  def initialize(content: '', type: 'markdown', heading_level: 0)
    @cell_hash = if type == 'code'
                 make_code_cell(content: content)
               else
                 make_md_cell(content: content, heading_level: heading_level)
               end
    self.type = type
    self.content = content
    self.heading_level = heading_level
  end
  
  # self.make_cell - Valid cell_type are ['code'*, 'markdown'], *default
  # cell = self.make_cell('yo', 'markdown')
  def make_cell_hash(content: '', type: 'code')
    {"cell_type"=>type,
      "execution_count"=>0,
      "metadata"=>{},
      "outputs"=>[],
      "source"=>[content]}
  end

  def make_code_cell(content: '')
    make_cell_hash(type: 'code', content: content)
  end

  def make_md_cell(content: '', heading_level: 0)
    if heading_level.positive?
      hash_marks = '#' * heading_level
      content = hash_marks + ' ' + content
    end

    make_cell_hash(type: 'markdown', content: content)
  end

  def inspect
    details = []
    details << "#{type} Cell"
    details << content
    details << "\n"
    details
  end

end