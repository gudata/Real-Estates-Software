module SearchLogic
   module NoJoins
  
    def self.included(klass)
      klass.class_eval do
        alias_method_chain :merge_joins, :singularity1
        alias_method_chain :merge_joins, :consistent_conditions1
        alias_method_chain :merge_joins, :merged_duplicates1
      end
    end   

    def merge_joins_with_merged_duplicates1(*args)    
      []
    end

    def merge_joins_with_singularity1(*args)
      []
    end

    def merge_joins_with_consistent_conditions1(*args)
      []
    end

  end
end