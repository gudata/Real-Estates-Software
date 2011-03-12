# http://dougselph.com/rails/2010/06/rails3_tabsrenderer/
# http://dougselph.com/rails/2010/06/rails3_tabsrenderer/
module TabsHelper

  def tabs_for( *options, &block )
    raise ArgumentError, "Missing block" unless block_given?

    tabs = TabsHelper::TabsRenderer.new( *options, &block )
    tabs.render
  end

  class TabsRenderer

    def initialize( options={}, &block )
      raise ArgumentError, "Missing block" unless block_given?

      @template = eval( 'self', block.binding )
      @options = options
      @tabs = []

      yield self
    end

    def create( tab_id, tab_text, options={}, &block )
      raise "Block needed for TabsRenderer#CREATE" unless block_given?
      @tabs << [ tab_id, tab_text, options, block ]
    end

    def render
      # МОЯ КОД!!!!
      current_field_saver = hidden_field_tag("current_tab", params[:current_tab])
      content_tag(:div,
        ( current_field_saver + render_tabs + render_bodies ),
        { :id => :tabs }.merge( @options ),
        false
      )
    end

    private # ---------------------------------------------------------------------------

    def render_tabs
      content_tag :ul, {}, false do
        @tabs.collect do |tab|
          # за нормални табове
          prefix =  (tab[0] =~ /http:/) ? '' : '#'
          content_tag(:li, link_to( content_tag(:span, tab[1] ), "#{prefix}#{tab[0]}" ), {}, false )
        end.join("\n").html_safe
      end
    end

    def render_bodies
      @tabs.collect do |tab|
        content_tag(:div, capture(&tab[3]), tab[2].merge( :id => tab[0] ), false )
      end.join("\n").html_safe
    end

    def method_missing( *args, &block )
      @template.send( *args, &block )
    end

  end

end