# frozen_string_literal: true

# Generate an ID number based on current time
class NBTools
  def self.generate_id
    format("%.7f", Time.now.to_f).delete('.')
  end
end
