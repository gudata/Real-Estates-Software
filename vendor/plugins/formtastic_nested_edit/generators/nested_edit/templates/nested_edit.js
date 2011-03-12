/*
 * Returns a function that can be used as a click handler for adding
 * nested models to a form. For example:
 *
 *   jQuery("add_task_link").observe("click", addNestedItem("tasks", taskTemplate));
 * 
 * The returned click handler will:
 * 
 * 1. Replace all the occurrences of NEW_RECORD in the template with a
 *    generated ID (see the generate_template helper.)
 *
 * 2. Insert the template in the bottom of the given container.
 *
 * 3. Set the focus to the first form element inside the new item.
 */
function add_nested_item(event, container, template) {
    var regexp = new RegExp("NEW_RECORD", "g")
    var new_id = new Date().getTime();
    var new_item = template.replace(regexp, new_id)

    jQuery(container).append(new_item); //.slideToggle(600);;

    var newElement = jQuery(container + " ul.item_form:last")
    newElement.find("input:first").focus();

    event.stopPropagation();
    event.preventDefault();
    return false;

}

/*
 * Returns a function that can be used as a click handler for removing
 * nested models from a form. For example:
 *
 *   jQuery("remove_task_link").observe("click", removeNestedItem("task"));
 *
 */
function remove_nested_item(event, element, item_class) {
    // jQuery(event.target).slideUp();
    // var element = jQuery(event.target);
    event.stopPropagation();
    event.preventDefault();
    
    clicked_link_id = element.attr("id");
    // console.log("We have clicked on id:" + clicked_link_id);

    hidden_selector = "#hidden_" + clicked_link_id;
    // console.log("Hidden selector to search for:" + hidden_selector);

    var hidden_element = jQuery(hidden_selector);
    // console.log("Hidden element:" + hidden_element);

    // console.log("Searching for box with class:" + item_class );
    target = jQuery(element).parents("." + item_class)
    // console.log("The box we found:" + target); // jQuery.dump(target)

    
    jQuery("#dialog_" + clicked_link_id).dialog({
        bgiframe: true,
        resizable: true,
        height: 250,
        closeOnEscape: true,
        position: 'center',
        modal: true,
        overlay: {
            backgroundColor: '#000',
            opacity: 0.5
        },

        buttons: {
            'Are you sure?': function() {
                jQuery(this).dialog('destroy');

                if (hidden_element.length) {
                    // console.log("Found hidden:" + hidden_element);
                    target.slideUp(300, function(){})
                    hidden_element.val(1);
                } else {
                    // console.log("NOT Found hidden:" + hidden_element);
                    target.slideUp(300, function(){
                        target.remove()
                        })
                }

            },
            'Close': function() {
                jQuery(this).dialog('destroy');
            }
        }
    });

    return false;
}

function toggle_item_form(event, element, item_class) {
    //    clicked_link_id = element.attr("id");
    //    // console.log("We have clicked on id:" + clicked_link_id);
    event.stopPropagation();
    event.preventDefault();
    
    // console.log("Searching for box with class:" + item_class);
    target = jQuery(element).parents("." + item_class)
    // console.log("The box we found:" + target); // jQuery.dump(target)
    target.children('.item_form').slideToggle(600);
    
    return false;

}


// How to flash element .stop().css("background-color", "red").animate({ backgroundColor: "#FFFFFF"}, 1500);
