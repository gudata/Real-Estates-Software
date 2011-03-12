# ActionView::Helpers::InstanceTag.to_label_tag
# https://rails.lighthouseapp.com/projects/8994/tickets/745-form-label-should-use-i18n
module ActionView
  module Helpers
    class InstanceTag
#      alias_method  :to_label_tag, :to_label_tag_old

      def to_label_tag(text = nil, options = {})
        puts "AV patch"
        options = options.stringify_keys
        name_and_id = options.dup
        add_default_name_and_id(name_and_id)

        add_default_name_and_id(name_and_id)
        options.delete("index")
        options["for"] ||= name_and_id["id"]
        if text.blank?
          content = object.class.respond_to?(:human_attribute_name) ? object.class.human_attribute_name(method_name) : method_name.humanize
        else
          content = text.to_s
        end
        #content = (text.blank? ? nil : text.to_s) || object_name.classify.constantize.human_attribute_name(method_name)
         label_tag(name_and_id["id"], content, options)
      end
    end
  end
end
