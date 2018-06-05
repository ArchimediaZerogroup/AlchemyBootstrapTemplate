require 'active_support/concern'

module AdminOverrideToParam

  def to_param
    self.id.to_s
  end

end
