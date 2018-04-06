##
# Questo override serve per correggere un problema per cui gli elementi nested non eseguivano correttamente il touch
# agli elementi padre
module Alchemy::Touching

  def touch(*)
    super
    # Using update here, because we want the touch call to bubble up to the page.
    update(touchable_attributes)
  end

end