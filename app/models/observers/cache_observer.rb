class CacheObserver < ActiveRecord::Observer
  observe $cache.models
  
  def reload_cache(record)
#    puts ">>>>>>>>>>>>>>>>>>>> reloading....#{record.inspect}"
    $cache.reload_model record
  end

  def after_save record
#    puts ">>>>>>>>>>>>>>>>>>>> after_save record....#{record.inspect}"
    reload_cache record
  end

  def after_destroy record
#    puts ">>>>>>>>>>>>>>>>>>>> after destroy.....record....#{record.inspect}"
    reload_cache record
  end

end