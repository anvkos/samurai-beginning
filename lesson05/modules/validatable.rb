module Validatable
  def valid?
    validate!
  rescue
    false
  end
end
