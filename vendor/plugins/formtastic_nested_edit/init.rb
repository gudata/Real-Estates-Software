# Include hook code here
if Object.const_defined?("Formtastic")
  ActionView::Base.send :include, Formtastic::NestedEditHelper
else
  puts "Nested Edit plugin needs Formtastic to work"
end