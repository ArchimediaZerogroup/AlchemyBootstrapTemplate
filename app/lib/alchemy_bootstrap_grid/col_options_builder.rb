module AlchemyBootstrapGrid
  ##
  # PORO per generazione corretta classi css per le rows
  # riceve l'elemnto alchemy rappresentante la colonna
  class ColOptionsBuilder

    attr_accessor :element

    ##
    # @param [Alchemy::Element] row
    def initialize(col)
      @element = col
    end
    

    ##
    # Classi da restituire alla colonna
    # @return [Array]
    def css_classes
      classes= ["col-12"]
      unless @element.content_by_name(:classi_css).essence.body.nil?
        classes << @element.content_by_name(:classi_css).essence.body
      end

      unless @element.content_by_name(:larghezza).essence.value.nil?
        classes << @element.content_by_name(:larghezza).essence.value
      end
      classes #todo estrapolare valori da options
    end

    ##
    # Hash opzioni passate all'helper Alchemy::ElementsBlockHelper#element_view_for
    # @return [Hash]
    def view_options
      {
        class: css_classes
      }
    end

  end
end