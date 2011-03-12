#Date.class_eval do
#
#  def to_s( format_name = :default )
#    format = case format_name
#    when String
#      self.strftime( format )
#    when Symbol
#      I18n.localize( self, :format => format_name)
#    end
#  end
#
#end
#
#Time.class_eval do
#
#  def to_s( format_name = :default )
#    format = case format_name
#    when String
#      self.strftime( format )
#    when Symbol
#      I18n.localize( self, :format => format_name)
#    end
#  end
#
#end
