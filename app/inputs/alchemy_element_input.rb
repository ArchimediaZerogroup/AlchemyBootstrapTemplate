class AlchemyElementInput < SimpleForm::Inputs::Base
  include ActionView::Context
  # include Alchemy::BaseHelper
  # include Alchemy::EssencesHelper
  include Alchemy::ElementsHelper
  include ActionView::Helpers::JavaScriptHelper
  # include Alchemy::Admin::EssencesHelper

  def input(wrapper_options = nil)

    Rails.logger.debug {input_options.inspect}
    Rails.logger.debug {input_html_options.inspect}
    Rails.logger.debug {wrapper_options.inspect}

    #merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    #@builder.hidden_field(attribute_name, merged_input_options)


    # element_editor_for(@builder.object.send(attribute_name)) do |el|
    #   el.edit attribute_name
    # end
    #
    #
    #

    templated = @builder.template #input_options[:templated]


    templated.extend Alchemy::Admin::EssencesHelper

    if @builder.object.persisted?
      bf = ActiveSupport::SafeBuffer.new
      element = @builder.object.alchemy_element

      element_uid = "element_#{SecureRandom.hex}"

      if attribute_name != :picture_gallery
        bf << content_tag(:div, ElementEditorHelper.new(templated, element: element).edit(attribute_name),
                          id: element_uid, class: 'proxed_element_blk')

        bf << javascript_tag do
          raw " CustomProxedElementEditor.init('##{element_uid}'); "
        end
      else

        templated.extend Alchemy::Admin::ElementsHelper

        bf << content_tag(:div, templated.render_picture_editor(element, max_images: nil, crop: true),
                          class: 'proxed_element_blk')

      end


      bf

    else
      content_tag(:div, '')
    end


    # content_tag(:div, 'coao')

  end


end