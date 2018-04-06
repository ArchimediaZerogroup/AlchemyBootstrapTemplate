class ElementProxerResource < Alchemy::Resource

  def attributes

    fields = super

    if model.have_alchemy_definition?
      fields += model.proxed_elements.collect {|c|
        {
          name: c[:name],
          type: :delegated_alchemy_element
        }
      }


      fields += [{
                   name: :picture_gallery,
                   type: :delegated_alchemy_element
                 }] if model.proxed_element_have_gallery?

    end
    fields


  end

  def index_attributes
    attributes.reject {|c| ([:picture_gallery] + model.proxed_elements.collect {|c| c[:name]}).include?(c[:name])}
  end


end