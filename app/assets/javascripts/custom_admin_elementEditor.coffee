#= require 'alchemy/alchemy.element_editors'



window.CustomProxedElementEditor = $.extend {}, Alchemy.ElementEditors


$.extend window.CustomProxedElementEditor,
  init: (selector = "#element_area")->
    @element_area = $(selector)
    @bindEvents()

    @initialize_tinymce()
    return

  initialize_tinymce: ()->
    ids = []
    @element_area.find('.has_tinymce').each (i, e)->
      ids.push($(e).attr("id").match(/[0-9]+/)[0])
    Alchemy.Tinymce.init(ids)


# disattivazione del check di reload pagina
$(document).on 'submit', '.simple_form.alchemy', (e)=>
  window.onbeforeunload = null;


#Ordinamento categorie prodotti
$ ->
  $(document).on 'click', 'a[href="#sort_categories"]', (e)->
    e.preventDefault()
    $('#save_category_order').css('display', 'inline-block');
    setTimeout(->
      Alchemy.pleaseWaitOverlay(false)
    , 300);
    $('body').addClass('sorting');
    $('#categories_list tbody').sortable();
    $('#categories_list tbody').disableSelection();


  $(document).on 'click', '#save_category_order', (e)->
    e.preventDefault();
    path = $(this).find('a').data('savePath');
    $(this).hide();
    $('body').removeClass('sorting');
    sortedIDs = $('#categories_list tbody').sortable("toArray", {attribute: 'data-element_id'});
    $('#categories_list tbody').sortable('destroy');
    $('#categories_list tbody').enableSelection();
    $.ajax
      url: path
      method: 'POST'
      data:
        order: sortedIDs
      success: (ris)->
        if(ris.success)
          Alchemy.pleaseWaitOverlay(false)


