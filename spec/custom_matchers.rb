module CustomMatchers
  class HaveAccess
    def initialize(actions, objects)
      @actions, @objects = actions, objects
    end

    def matches?(target)
      target.can? @actions, @objects
    end

    def failure_message_for_should
      "expected #{@objects.inspect} to have access to #{@actions.inspect}"
    end

    def failure_message_for_should_not
      "expected #{@objects.inspect} to NOT have access to #{@actions.inspect}"
    end
  end

  def have_access(actions, objects)
    HaveAccess.new(actions, objects)
  end
end

