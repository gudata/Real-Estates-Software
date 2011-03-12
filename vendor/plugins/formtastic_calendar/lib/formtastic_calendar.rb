module ElanDesign
  module Formtastic
    module Calendar
      
      protected

      # Outputs a Javascript calendar using the rails date kit
      # http://www.methods.co.nz/rails_date_kit/rails_date_kit.html
      #
      def calendar_input(method, options = {})
        format = options[:format] || Date::DATE_FORMATS[:default] || '%d %b %Y'
        calendar_input_html = calendar_options(format, object.send(method))
        options[:input_html] ||= {}
        options[:input_html].merge!(calendar_input_html)
        string_input(method, options)
      end

      # Generate html input options for the calendar_input
      #
      def calendar_options(format, value = nil)
        months = '[' + Date::MONTHNAMES[1..12].collect { |m| "'#{m}'" }.join(',') + ']'
        days = '[' + Date::DAYNAMES.collect { |d| "'#{d}'" }.join(',') + ']'
        {
            :onfocus => "this.select();calendar_open(this,{format:'#{format}',images_dir:'/images',month_names:#{months},day_names:#{days}})",
            :onclick => "event.cancelBubble=true;this.select();calendar_open(this,{format:'#{format}',images_dir:'/images',month_names:#{months},day_names:#{days}})",
            :value => value.try(:strftime, format)}
      end
      
    end
  end
end