module Admin::StatisticsHelper
  
  def show_line row, value, sumator, row_label = ""
    data = ""
    UserStatistic.kinds.collect do |kind|
      row[kind].each_pair do |status, values|
        calc_value_for_status = values[value]
        sumator.add kind, status, value, calc_value_for_status
        if calc_value_for_status >= 0
          if calc_value_for_status > 0
            display = content_tag :strong, calc_value_for_status
          else
            display = calc_value_for_status
          end
        else
          display = "&nbsp;".html_safe
        end
        data += content_tag(:td, display)
      end
    end
    
    data = data.html_safe

    row_string =  content_tag(:td, row_label) +  data  +  content_tag(:td, "")
      
    content_tag :tr, row_string
  end

  def ab name
    words = name.split(/ /).collect{|word| word }
    first = words[0].split("")
    second =  words[1].blank? ? "" : " #{words[1].first}"
    short = "#{first[0]}#{first[1]}.#{second}"
    content_tag :span, short, :title => name
  end

end
