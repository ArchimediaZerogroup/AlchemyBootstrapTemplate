class AdviceResource < ElementProxerResource

  def attributes


    fields = super + model.translated_attribute_names.collect {|col|
      {
        name: col,
        type: model.translation_class.type_for_attribute(col.to_s).type
      }
    }

    fields

  end


  def index_attributes
    super.select {|v|
      [:title].include?(v[:name].to_sym)
    }
  end

  def searchable_attribute_names
    []
  end

end