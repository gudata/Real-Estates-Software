module Admin::BuysHelper

  def render_term(f, term, index)
    term_html = case term.kind_of_search
    when "exact"
      display_as_exact(f, term, index)
    when "multiple"
      display_as_multiple(f, term, index)
    when "range"
      display_as_range(f, term, index)
    end

    if term.end_of_line
      output_html =  term_html << content_tag(:li, "", {:class => 'keyword_separator'}, false)
    else
      output_html = term_html
    end
    output_html
  end

  def short_search_criteria_list search_criteria
    return ["Empty criteria"] if search_criteria.blank?
    filled_terms = search_criteria.filled_terms

    key_values = filled_terms.collect do |term|
      content_tag(:span, term.name, :class => :keyword) + "" +
        case term.kind_of_search
      when "exact"
        if $cache.key? term.patern
          nomeclatures = $cache[term.patern].select{|el| term.value == el.id}
          name = nomeclatures.first.name
        else
          case term.as
          when "month_calendar"
            name = " #{l(Time.at(term.value), :format => :month)}"
          when "string"
            name = term.value
          end
        end
        " #{name}"
      when "multiple"
        if $cache.key? term.patern
          nomeclatures = $cache[term.patern].select{|el| term.values.include? el.id}
          names = nomeclatures.collect{|n| n.name}
        else
          names = term.values
        end
        ": " + names.join(", ")
      when "range"
        case term.as
        when "calendar"
          " #{term.from_date.strftime("%d %b %Y")} - #{term.to_date.strftime("%d %b %Y")}"
        when "string"
          " #{term.from} - #{term.to}"
        end
      end
    end

    key_values
  end
      
  private
  def display_as_multiple(f, term, index)
    case term.as
    when *['multiple_select', 'select']
      collection = $cache[term.patern]

      options_for_select = collection.collect do |item|
        selected = (term.values and term.values.include?(item.id)) ? 'selected="selected"'  : nil
        content_tag(:option, item.name, :value => item.id, :selected => selected)
      end.join("\n").html_safe

      select_html_attributes = {
        :multiple => "multiple",
        :size => 5,
        :class => term.patern.tableize,
        :id => dom_id(term),
        :name => "search_criteria[terms_attributes][#{index}][values][]",
      }
      content_tag(:fieldset, content_tag(:legend, term.name) +
          meta_for_term(f, term, index) +
          #          label_tag(dom_id(term), term.name) +
        content_tag(:select, options_for_select, select_html_attributes),
        :class => term.patern.tableize
      )

    when 'check_boxes'
      collection = $cache[term.patern]
      content_tag(:fieldset,
        content_tag(:legend, term.name) +
          meta_for_term(f, term, index) +
          collection.collect do |item|
          content_tag :div, :style => 'overflow: auto;' do
            checked = 'checked="checked"' if term.values and term.values.include?(item.id)
            s = <<-html
              <input id="#{dom_id(item)}" name="search_criteria[terms_attributes][#{index}][values][]" type="checkbox" value="#{item.id}" #{checked}/>
              <label for="#{dom_id(item)}">#{item.name}</label>
            html
            s.html_safe
          end.html_safe
        end.join("\n").html_safe,
        :class => term.patern.tableize
      ).html_safe
      #    when 'calendar'
      #      if f.object.new_record?
      #        f.object.value = Time.now()
      #        raise f.object.value.class.inspect
      #        f.input :value,
      #          :label => term.name,
      #          :as => term.as.to_sym
      #      else
      #        f.object.value = Time.parse(f.object.value).to_date
      #        f.input :value ,
      #          :label => term.name,
      #          :as => term.as.to_sym
      #      end
    else
      "<div style='clear:both'>unsupported control as multiple #{term.as} - #{term.name}</div>".html_safe
    end
  end

  def display_as_range(f, term, index)
    case term.as
    when 'string'
      f.input(
        :from,
        :label => t("something_from", :scope =>[:admin, :buys], :name => term.name),
        :as => term.as.to_sym,
        :input_html => {
          #            :index => index,
          :class => term.patern.tableize
        }
      ) +
        f.input(
        :to,
        :label => t("something_to", :scope =>[:admin, :buys], :name => term.name),
        :as => term.as.to_sym,
        :input_html => {
          #            :index => index,
          :class => term.patern.tableize
        }
      ) +
        meta_for_term(f, term, index)

    when 'select'
      collection = $cache[term.patern]
      f.input(:from,
        :label => term.name,
        :collection => collection,
        :as => term.as.to_sym,
        :input_html => {
          #            :index => index,
          :class => term.patern.tableize
        }
      ) +
        f.input(:to,
        :label => term.name,
        :collection => collection,
        :as => term.as.to_sym,
        :input_html => {
          #            :index => index,
          :class => term.patern.tableize
        }
      ) +
        meta_for_term(f, term, index)

    when 'calendar'
      from = f.input(:from_date,
        :label => t("something_from", :scope =>[:admin, :buys], :name => term.name),
        :as => 'calendar', #term.as.to_sym,
        :input_html => {
          #            :index => index,
          :class => term.patern.tableize
        }
      )
      to = f.input(:to_date,
        :label =>t("something_to", :scope =>[:admin, :buys], :name => term.name),
        :as => 'calendar', #term.as.to_sym,
        :input_html => {
          #            :index => index,
          :class => term.patern.tableize
        }
      )

      from +  to + meta_for_term(f, term, index)
    else
      "<div style='clear:both'>unsupported control as range #{term.as} - #{term.name} #{term.as == 'select'}</div>".html_safe
    end
  end

  def display_as_exact(f, term, index)
    case term.as
    when 'string'
      f.input(
        :value,
        :label => term.name,
        :as => term.as.to_sym,
        :input_html => {
          #            :index => index,
          :class => term.patern.tableize
        }
      ) +
        meta_for_term(f, term, index)

    when 'boolean'
      f.input(:value,
        :label => term.name,
        :as => term.as.to_sym,
        :input_html => {
          #            :index => index,
          :id => dom_id(term), :class => term.patern.tableize
        }
      ) +
        meta_for_term(f, term, index)
    when 'select'
      collection = $cache[term.patern]
      select_html_attributes = {:id => dom_id(term), :class => term.patern.tableize, :name => "search_criteria[terms_attributes][#{index}][value]" }
      select_options = content_tag(:option, "", :value => "") +
        collection.collect do |item|
        selected = (term.value and term.value == item.id) ? 'selected="selected"' : nil
        content_tag(:option, item.name, :value => item.id, :selected => selected)
      end.join("\n").html_safe

      label_tag(dom_id(term), term.name) +
        content_tag(:select, select_options, select_html_attributes) +
        meta_for_term(f, term, index)
    when 'month_calendar'
      if term.new_record?
        term.value = Time.now().to_i
        term.value = ""
        date_presentation = ""
      elsif term.value == nil or term.value == ""
        term.value = ""
      else
        term.value = term.value.class == Bignum ? term.value.to_s[0..9] : term.value
        date_presentation = l(Time.at(term.value), :format => :month) #.strftime("%B %Y")
      end

      date_storage = term.value
      f.object.value = date_storage
      hidden_tag = f.hidden_field(:value, :id => dom_id(term))
      alternate_field_id = dom_id(term)
      calendar_holder_id = "month_calendar_holder_field_#{dom_id(term)}"
      calendar_clean_id = "month_calendar_clean_field_#{dom_id(term)}"
      calendar_holder_field = text_field_tag("calendar_#{term.tag}", date_presentation,
        :class => "date-picker #{term.patern.tableize}",
        :id => calendar_holder_id, :autocomplete => "off")  +
        link_to("x", "#", :id => calendar_clean_id)
      label = label_tag term.name, term.name, :for => calendar_holder_id
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
      altFormat: "@",
      showOptions: {
        direction: 'down'
      },

      onClose: function(dateText, inst) {
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker('setDate', new Date(year, month, 1));
        big_date = $("##{alternate_field_id}").val();
        big_date = big_date.substring(0, big_date.length - 3)
        $("##{alternate_field_id}").val(big_date);
      }
    });
  }).datepicker( "option",
				$.datepicker.regional["bg"] );;



</script>
JS

      content_tag(:li, label +
          calendar_holder_field +
          hidden_tag + meta_for_term(f, term, index) +
          javascript.html_safe)
    when 'year_calendar'
      if term.new_record?
        term.value = Time.now().to_i
        term.value = ""
        date_presentation =  ""
      elsif term.value == nil or term.value == ""
        term.value = ""
      else
        term.value = term.value.class == Bignum ? term.value.to_s[0..9] : term.value
        date_presentation = l(Time.at(term.value), :format => :year) #.strftime("%B %Y")
      end

      date_storage = term.value
      f.object.value = date_storage
      hidden_tag = f.hidden_field(:value, :id => dom_id(term))
      alternate_field_id = dom_id(term)
      calendar_holder_id = "year_calendar_holder_field_#{dom_id(term)}"
      calendar_clean_id = "year_calendar_clean_field_#{dom_id(term)}"
      calendar_holder_field = text_field_tag("calendar_#{term.tag}", date_presentation,
        :class => "date-picker #{term.patern.tableize}",
        :id => calendar_holder_id, :autocomplete => "off") + 
        link_to("x", "#", :id => calendar_clean_id)
      label = label_tag term.name, term.name, :for => calendar_holder_id
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
      altFormat: "@",
      showOptions: {
        direction: 'down'
      },

      onClose: function(dateText, inst) {
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker('setDate', new Date(year, month, 1));
        big_date = $("##{alternate_field_id}").val();
        big_date = big_date.substring(0, big_date.length - 3)
        $("##{alternate_field_id}").val(big_date);
      }
    });
  }).datepicker( "option",
				$.datepicker.regional["bg"] );;


</script>
JS

      content_tag(:li, label +
          calendar_holder_field +
          hidden_tag + meta_for_term(f, term, index) +
          javascript.html_safe)

    else
      "<div style='clear:both'>unsupported control as exact #{term.as} - #{term.name}</div>".html_safe
    end
  end

  def meta_for_term(f, term, index)
    [
      f.hidden_field("id",  :value => term.id),
      f.hidden_field("tag", :value => term.tag),
      f.hidden_field("keyword_id", :value => term.keyword_id),
      f.hidden_field("kind_of_search", :value => term.kind_of_search),

      f.hidden_field("name", :value => term.name),
      f.hidden_field("patern", :value => term.patern),
      f.hidden_field("position", :value => term.position),
      f.hidden_field("as", :value => term.as),
      f.hidden_field("active", :value => term.active),
    ].join("\n").html_safe
  end
end
