require 'test_helper'

class Admin::<%= plural_class_name %>ControllerTest < ActionController::TestCase
  <%= controller_methods 'tests/shoulda/actions' %>
end
