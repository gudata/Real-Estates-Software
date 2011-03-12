/*
  Usage:
 
     <%= sell_search_form.input :city_id,
      :label => t("Град", :scope => [:admin, :buy_search]),
      :as => :select,
      :collection => []
  %>
    <% content_for :head do %>
      <script type="text/javascript">
        $(document).ready(function(){
          fill_from_storage("#sell_search_city_id", "cities_storage", "<%= cities_navigations_path %>", <%= sell_search_form.object.city_id %>);
        });
      </script>
    <% end%>
    https://developer.mozilla.org/En/Using_native_JSON
 */
function fill_from_storage(target_select, storage_name, data_url, value) {
  if (Modernizr.localstorage) {
    // window.localStorage is available!
    var json_stored_data = localStorage.getItem(storage_name);
    if (json_stored_data == null) {
      $.getJSON(data_url, function(data) {
        var select_options = '';
        // use http://code.google.com/p/jquery-json/
        var encoded = $.toJSON(data);
        localStorage.setItem(storage_name, encoded); // store the raw data

        // Store parsed options tags
        $(data).each(function(index, object) {
          select_options += '<option value="' + object.id + '">' + object.name + '</option>';
        });

        localStorage.setItem(storage_name + "_options", select_options); // store the raw data
        $(target_select).html(localStorage.getItem(storage_name + "_options"));
        $(target_select).val(value);
      });
    } else {
      // we don't need the raw data'
      // data = localStorage.getItem(storage_name);
      // items = jQuery.parseJSON(data);

      $(target_select).html(localStorage.getItem(storage_name + "_options"));
      $(target_select).val(value);
    }
  } else {
    // no native support for HTML5 storage :(
    // maybe try dojox.storage or a third-party solution
    $(target_select).load(data_url)
    $(target_select).val(value);
  }

}

function clear_storage(storage_name){
  if (Modernizr.localstorage) {
    localStorage.removeItem(storage_name + "_options")
    localStorage.removeItem(storage_name)
    return true;
  }
  return false;
}




jQuery.fn.exists = function(){
  return jQuery(this).length>0;
}

$(function() {
  $('.city_select').change(function(event) {
    element = $(event.target);
    var input_value = element.val();
    var input_id = element.attr("id");
    var search_object_name = element.attr("search_object_name");
    var data = {
      city_id: input_value,
      replace_selector: "",
      search_object_name: search_object_name
    };
    $.ajax({
      // type:"POST",
      url: '/navigations/quarters',
      data: data,
      cache: true,
      async: true,
      success: function (html) {
       $('#'+search_object_name+'_quarter_ids_input').html(html);
      }
    });
    event.preventDefault();
    event.stopImmediatePropagation();
    return false;
  });

  

  $('.date-pickerzz').datepicker( {
    changeMonth: true,
    changeYear: true,
    showButtonPanel: true,
    dateFormat: 'MM yy',
    //    showAnim: 'fold',
    yearRange:		"-99:+50",
    altField: "#alternate",
    //    altFormat: "DD, d MM, yy",
    showOptions: {
      direction: 'down'
    },
    //    beforeShow: function(input, instance) {
    //      console.log(instance);
    //      console.log(instance.dpDiv.children("table"))
    //      instance.dpDiv.children("table").css('display', "none");
    //      instance.dpDiv.children("table").remove();
    //      $(input).datepicker("widget").find("table").remove();
    //      setDate
    //    },

    onClose: function(dateText, inst) {
      var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
      var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
      $(this).datepicker('setDate', new Date(year, month, 1));
    }
  });
});