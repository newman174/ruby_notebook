# frozen_string_literal: true

class NBTools
  # Generate an ID number based on current time
  def self.generate_id
    format("%.7f", Time.now.to_f).delete('.')
  end
end
