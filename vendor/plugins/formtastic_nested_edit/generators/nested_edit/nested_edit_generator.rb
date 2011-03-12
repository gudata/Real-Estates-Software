class NestedEditGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory 'public/images/nested_edit'
      m.file 'add.png', 'public/images/nested_edit/add.png'
      m.file 'edit.png', 'public/images/nested_edit/edit.png'
      m.file 'remove.png', 'public/images/nested_edit/remove.png'

      m.directory 'public/javascripts'
      m.file 'nested_edit.js', 'public/javascripts/nested_edit.js'
      m.readme 'README'
    end
  end
end