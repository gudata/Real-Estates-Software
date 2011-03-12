class String
  
  def String.random_alphanumeric(size=16)
    (1..size).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }.join
  end
  
  def chunkanize(parts = [[0,4], [48, 52], [95, 100]])
    return [self] if self.size <= 1
    
    # working with words
    terms_array = self.split(/ /)
    join_type = " "
    
    # working with letters
    if terms_array.size <= 100
      terms_array = self.split(//)
      join_type = ""
    end
    
    one_percent = terms_array.size.to_f / 100
    
    parts.collect do |part|
      start = part[0]
      stop = part[1]
      terms_array[(start * one_percent)..(stop * one_percent)].join(join_type)
    end
  end

end