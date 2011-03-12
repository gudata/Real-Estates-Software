module Admin::SellsHelper  

  def render_keyword(f, keyword)
    display_as = keyword.as
    
    case display_as
    when 'string'      
      f.input :value,
        :label => keyword.name,
        :as => display_as.to_sym

    when 'boolean'
      f.input :value,
        :label => keyword.name,
        :as => :select
      
    when 'select'
      collection = $cache[keyword.patern]
      f.input :value, 
        :label => keyword.name,
        :collection => collection,
        :as => display_as.to_sym,
        #        :selected => f.object.value.to_i,
      :include_blank => true

    when 'multiple_select'
      collection = $cache[keyword.patern]
      #      selected = (f.object.value || "").split(',').map{|char| char.to_i}
      f.input :value,
        :label => keyword.name,
        :as => :select,
        :multiple => true,
        :collection => collection
      #      ,
      #        :selected => selected

    when 'check_boxes'
      collection = $cache[keyword.patern]
      checked = (f.object.value || "").split(',').map{|char| char.to_i}
      Rails.logger.debug("check_boxes controll value #{f.object.value} -> #{checked.inspect}")
      #      f.object.value = checked
      f.input :value, 
        :label => keyword.name,
        :as => :check_boxes,
        :collection => collection,
        :checked => checked

    when 'calendar'
      if f.object.new_record?        
        f.object.value = Time.now()
      else
        f.object.value = Time.parse(f.object.value).to_date rescue Time.now
      end
      f.input :value,
        :label => keyword.name,
        :as => keyword.as.to_sym,
        :input_html => {
        #            :index => index,
        :class => keyword.patern.tableize
      }
    when 'month_calendar'
      if f.object.new_record? or f.object.value == nil or f.object.value == ""
        #        f.object.value = Time.now()
        date_storage = date_presentation = f.object.value = ""
      else
        f.object.value = Time.parse(f.object.value).to_date rescue Time.now
        date_presentation = l(f.object.value, :format => :month) #.strftime("%B %Y")
        date_storage = f.object.value.strftime("%Y-%m-%d")
        f.object.value = date_storage
      end
      hidden_tag = f.hidden_field(:value, :id => dom_id(keyword))
      alternate_field_id = dom_id(keyword)
      calendar_holder_id = "month_calendar_holder_field_#{dom_id(keyword)}"
      calendar_clean_id = "month_calendar_clean_field_#{dom_id(keyword)}"
      calendar_holder_field = text_field_tag("calendar_#{keyword.tag}", date_presentation, :class => "date-picker", :id => calendar_holder_id, :autocomplete => "off") +
          link_to("x", "#", :id => calendar_clean_id)
      label = label_tag keyword.name, keyword.name, :for => calendar_holder_id
      javascript = <<JS
<script type="text/javascript">
  $(function() {
    $('##{calendar_clean_id}').click(function(){
      $("##{alternate_field_id}").val('');
      $("##{calendar_holder_id}").val('');
      return false;
    });


    $('##{calendar_holder_id}').datepicker( {
      changeMonth: true,
      changeYear: true,
      showButtonPanel: false,
      dateFormat: 'MM yy',
      yearRange:		"-99:+50",
      altField: "##{alternate_field_id}",
      altFormat: "yy-m-d",
      showOptions: {
        direction: 'down'
      },

      onClose: function(dateText, inst) {
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker('setDate', new Date(year, month, 1));
      }
    });
  }).datepicker( "option",
				$.datepicker.regional["bg"] );;


</script>
JS
      content_tag(:li, label +
          calendar_holder_field +
          hidden_tag +
          javascript.html_safe)
    when 'year_calendar'
      if f.object.new_record? or f.object.value == nil or f.object.value == ""
        #        f.object.value = Time.now()
        date_storage = date_presentation = f.object.value = ""
      else
        f.object.value = Time.parse(f.object.value).to_date rescue Time.now
        date_presentation = l(f.object.value, :format => :year) #.strftime("%B %Y")
        date_storage = f.object.value.strftime("%Y-%m-%d")
        f.object.value = date_storage
      end
      hidden_tag = f.hidden_field(:value, :id => dom_id(keyword))
      alternate_field_id = dom_id(keyword)
      calendar_holder_id = "year_calendar_holder_field_#{dom_id(keyword)}"
      calendar_clean_id = "year_calendar_clean_field_#{dom_id(keyword)}"
      calendar_holder_field = text_field_tag("calendar_#{keyword.tag}", date_presentation, :class => "date-picker", :id => calendar_holder_id, :autocomplete => "off")+
        link_to("x", "#", :id => calendar_clean_id)
      label = label_tag keyword.name, keyword.name, :for => calendar_holder_id
      javascript = <<JS
<script type="text/javascript">
  $(function() {

    $('##{calendar_clean_id}').click(function(){
      $("##{alternate_field_id}").val('');
      $("##{calendar_holder_id}").val('');
      return false;
    });

    $('##{calendar_holder_id}').datepicker( {
      changeMonth: true,
      changeYear: true,
      showButtonPanel: false,
      dateFormat: 'yy',
      yearRange:		"-99:+50",
      altField: "##{alternate_field_id}",
      altFormat: "yy-m-d",
      showOptions: {
        direction: 'down'
      },

      onClose: function(dateText, inst) {
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker('setDate', new Date(year, month, 1));
      }
    });
  }).datepicker( "option",
				$.datepicker.regional["bg"] );;


</script>
JS
      content_tag(:li, label +
          calendar_holder_field +
          hidden_tag +
          javascript.html_safe)

    else
      "Unknown field #{keyword.inspect} - #{display_as}"
    end

  end

  def show_keyword(object, keyword_tag)    
    keyword = object.keywords.detect(){|temp_keyword| temp_keyword.tag == keyword_tag}
    value = object.keywords_sells.detect{|keyword_sell| keyword_sell.keyword_id == keyword.id}.value
    
    if (keyword.name)
      name = keyword.name
    else
      return "Bad keyword"
    end

    display_as = keyword.as

    case display_as
    when *['string', 'boolean']
      labelize(name, value)    

    when 'select'
      begin
        collection = $cache[keyword.patern]
        value = collection.detect(){|record| record.id == value.to_i}
        value = value.name
        labelize(name, value)
      rescue
        labelize(name, '')
      end

    when *['multiple_select', 'check_boxes']
      collection = $cache[keyword.patern]
      values = value.split(',').map{|char| char}
      keyword_value = ''

      values.each do |v|        
        temp_value = collection.detect(){|record| record.id == v.to_i}.name
        keyword_value += temp_value + ", "
      end
      keyword_value.chop!
      labelize(name, keyword_value)

    when 'calendar'
      value = value.to_s
      labelize(name, value)
    end
  end


  def show_term(object, keyword_tag)
    keyword = object.terms.select(){|temp_keyword| temp_keyword.tag == keyword_tag}.first
    unless keyword
      logger.debug("---> липсва стойност за терм #{keyword_tag}")
      return ""
    end
    name = keyword.name

    display_as = keyword.as

    case display_as
    when *['string', 'boolean']
      value = keyword.value
      
      labelize(name, value)

    when 'select'
      begin
        value = keyword.values.first
        collection = $cache[keyword.patern]
        value = collection.detect(){|record| record.id == value.to_i}
        value = value.name
        labelize(name, value)
      rescue
        labelize(name, '')
      end

    when *['multiple_select', 'check_boxes']
      collection = $cache[keyword.patern]      
      keyword_value = ''

      begin
        keyword.values.each do |v|
          temp_value = collection.detect(){|record| record.id == v.to_i}.name
          keyword_value += temp_value + ", "
        end
        keyword_value.chop!
        labelize(name, keyword_value)
      rescue
        labelize(name, 'Не работи')
      end

    when 'calendar'
      value = value.to_s
      labelize(name, value)
    end
  end

  private

  def labelize(label, value)
    content_tag(:span, "#{label}: <strong>#{value}</strong>".html_safe) unless "#{value}".strip.blank?
  end

end
