class UserSiteResource < Alchemy::Resource

  def attributes
    (super + model.stored_attributes[:serialized_data].collect{|col|
      {
        name: col,
        type: :string
      }
    }).reject{|c|  [:serialized_data,:type,:check_privacy].include?(c[:name].to_sym) }
  end

  def searchable_attribute_names
    [:email]
  end

end