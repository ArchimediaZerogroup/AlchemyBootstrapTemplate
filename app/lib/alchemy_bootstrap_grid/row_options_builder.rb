module AlchemyBootstrapGrid
  ##
  # PORO per generazione corretta classi css per le rows
  # riceve l'elemnto alchemy rappresentante la row
  class RowOptionsBuilder

    attr_accessor :element

    ##
    # @param [Alchemy::Element] row
    def initialize(row)
      @element = row
    end


    ##
    # Classi da restituire alla row
    # @return [Array]
    def css_classes
      classes= ["row"]
      unless @element.content_by_name(:classi_css).essence.body.nil?
        classes << @element.content_by_name(:classi_css).essence.body
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