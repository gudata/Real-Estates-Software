# mongoid иска този patch за да работи.
module ActiveRecord
  class Base
    def self.using_object_ids?
      false
    end
  end
end
