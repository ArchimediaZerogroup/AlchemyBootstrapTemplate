require 'active_support/concern'

module AlchemyElementProxerConcern
  extend ActiveSupport::Concern

  included do
    after_create :initialize_essence_elements

    private
    def initialize_essence_elements

      element = self.class.proxer_element_class.new_from_scratch(name: self.class.alchemy_element_name)
      element.page_id = self.id
      self.alchemy_element = element

    end


  end

  module ClassMethods


    ##
    # Costruisce il nome dell'element di alchemy, deve essere presente come name in element.yml
    def alchemy_element_name
      "proxed_#{self.name.underscore.gsub(/\//, '_')}"
    end

    def proxed_elements
      alchemy_definition[:contents]
    end

    def proxer_element_name
      "#{self.name.demodulize}ElementProxer"
    end

    def proxer_element_class
      Object.const_get(proxer_element_name)
    end

    def build_proxed_elements

      selfless = self.name

      Object.const_set(proxer_element_name, Class.new(Alchemy::Element) do
        belongs_to :page, required: true, class_name: selfless
      end)

      if have_alchemy_definition?


        self.has_one(:alchemy_element, class_name: proxer_element_name, foreign_key: :page_id, :dependent => :destroy)

        proxed_elements.each do |c|
          define_method c[:name].to_sym do
            self.alchemy_element.contents.named(:immagine_principale).first
          end

        end
      else
        Rails.logger.debug{"Non abbiamo trovato la definizione per l'elemento:#{alchemy_element_name}"}
      end

    end

    def proxed_element_have_gallery?
      alchemy_definition[:picture_gallery]
    end

    def have_alchemy_definition?
      !alchemy_definition.nil?
    end

    private
    def alchemy_definition
      proxer_element_class.definition_by_name(alchemy_element_name)
    end

  end
end