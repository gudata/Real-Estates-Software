# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular "criterias", 'criteria'
  
  inflect.singular("status", "status")
  inflect.singular(/(alias|status)es$/i, '\1')
  inflect.plural(/(alias|status)$/i, '\1es')


  inflect.singular("address_document", "address_document")
  inflect.singular(/(address_document)s$/i, '\1')
  inflect.plural(/(address_document)$/i, '\1s')

  #   inflect.singular /^(ox)en/i, '\1'
  #   inflect.irregular 'person', 'people'
  #   inflect.uncountable %w( fish sheep )
end