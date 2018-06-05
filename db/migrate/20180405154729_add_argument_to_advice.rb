class AddArgumentToAdvice < ActiveRecord::Migration[5.1]
  def change
    add_reference(:advices, :argument, index: true)
  end
end
