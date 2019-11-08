# modulo della gemma
module AlchemyBootstrapGrid

  mattr_accessor :column_elements, default: ['single_image', 'single_text', 'contenitore_colonne']
  mattr_accessor :column_widths, default: [{larg: 'col-lg-1', title: 'larghgezza 1/12'},
                                           {larg: 'col-lg-2', title: 'larghezza 2/12'},
                                           {larg: 'col-lg-3', title: 'larghezza 3/12'},
                                           {larg: 'col-lg-4', title: 'larghezza 4/12'},
                                           {larg: 'col-lg-5', title: 'larghezza 5/12'},
                                           {larg: 'col-lg-6', title: 'larghezza 6/12'},
                                           {larg: 'col-lg-7', title: 'larghezza 7/12'},
                                           {larg: 'col-lg-8', title: 'larghezza 8/12'},
                                           {larg: 'col-lg-9', title: 'larghezza 9/12'},
                                           {larg: 'col-lg-10', title: 'larghezza 10/12'},
                                           {larg: 'col-lg-11', title: 'larghezza 11/12'},
                                           {larg: 'col-lg-12', title: 'larghezza 12/12'}]


  mattr_accessor :row_options_builder, default: -> {AlchemyBootstrapGrid::RowOptionsBuilder}
  mattr_accessor :col_options_builder, default: -> {AlchemyBootstrapGrid::ColOptionsBuilder}


  def self.config
    yield self
  end


end


## inizializzatore specifico per siti
AlchemyBootstrapGrid.config do |c|
  c.column_elements += ['contact_landing_form', 'big_texts_landing', 'text_landing']
end