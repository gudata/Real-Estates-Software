class Sumator
  attr :sum, false

  def initialize
    @sum = {
      :projects => {},
      :buyers => {},
      :sellers => {},
      :renters => {},
      :letters => {},
    }
  end
  

  def add kind, status, counter_type, calc_value_for_status
#    puts kind, status, calc_value_for_status
    @sum[kind][status] ||= {}
    @sum[kind][status][counter_type] ||= 0
    @sum[kind][status][counter_type] += calc_value_for_status if calc_value_for_status >= 0
  end
  alias :<< :add

  def [] kind
    @sum[kind]
  end
end