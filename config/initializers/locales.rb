
# You need to "force-initialize" loaded locales
# I18n.backend.send(:init_translations)
# AVAILABLE_LOCALES = I18n.backend.available_locales
AVAILABLE_LOCALES = [:ru, :bg]

Rails.logger.debug "* Loaded locales: #{AVAILABLE_LOCALES.inspect}"
