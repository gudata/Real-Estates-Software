# TODO - make helpers for contact phones and internet comunicators
# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper

  def with_locales
    I18n.available_locales.each do |locale|
      I18n.locale = locale
      yield locale
    end
  end

  def will_paginate(collection, options = {})
    options.merge!({
        :previous_label => I18n::t('Previous page', :scope=>[:will_paginate]),
        :next_label =>  I18n::t('Next page', :scope=>[:will_paginate])
      })

    super(collection, options)
  end

end
