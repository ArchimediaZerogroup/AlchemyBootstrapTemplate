# config/initializers/tinymce.rb
Alchemy::Tinymce.init = {
  skin: "custom",
  plugins: Alchemy::Tinymce.plugins + ['image', 'alchemy_file_selector', 'table'],
  toolbar: [
    'bold italic underline | strikethrough subscript superscript | numlist bullist indent outdent | removeformat | fullscreen',
    'pastetext | formatselect | charmap code | undo redo | alchemy_link unlink | image',
    'table tabledelete | tableprops tablerowprops tablecellprops | tableinsertrowbefore tableinsertrowafter tabledeleterow | tableinsertcolbefore tableinsertcolafter tabledeletecol'
  ],
  block_formats: "Header 1=h1;Header 2=h2;Header 3=h3;Header 4=h4;Header 5=h5;Paragraph=p"
}
