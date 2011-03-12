class UserStatistic
  def initialize user
    @user = user
  end

  def count_sellers(user, status, from, to)
    # sellers
    start_conditions = {
        :status_id => status.id,
        :offer_type_id => OfferType.for(:sellers).id,
      }

    if status.id == 1 # FUCK THOSE BASTARDS! I want my money else all the code will be done in magick numbers!
      start_conditions[:co_owner_id] = user.id
    else
      start_conditions[:user_id] = user.id
    end
#    start_conditions[:user_id] = user.id
      
    sell = SellDocument.where(start_conditions)
    Rails.logger.debug("      - Sellers query: #{sell.selector.inspect}")
    count = sell.count

    sell = SellDocument.where(start_conditions)
    with_time_frame = UserStatistic.add_time_frame(sell, from, to)
    Rails.logger.debug("      - Sellers query with_time_frame: #{with_time_frame.selector.inspect}")
    count_period = with_time_frame.count

    sell = SellDocument.where(start_conditions)
    without_projects = sell.where(:project_id => {"$in" => ["", nil]})
    Rails.logger.debug("      - Sellers query without_projects: #{without_projects.selector.inspect}")
    count_without_project_offers  = without_projects.count

    sell = SellDocument.where(start_conditions)
    without_projects_with_time_frame = UserStatistic.add_time_frame(sell, from, to).where(:project_id => {"$in" => ["", nil]})
    Rails.logger.debug("      - Sellers query without_projects_with_time_frame: #{without_projects_with_time_frame.selector.inspect}")
    count_without_project_offers_period  = without_projects_with_time_frame.count

    result = {
      :count => count,
      :count_period => count_period,
      :count_without_project_offers => count_without_project_offers,
      :count_without_project_offers_period => count_without_project_offers_period,
    }
    Rails.logger.debug("      Sellers count" + result.inspect)
    result
  end

  def count_letters(user, status, from, to)
    # sellers
    start_conditions = {
        :user_id => user.id,
        :status_id => status.id,
        :offer_type_id => OfferType.for(:letters).id,
      }

    sell = SellDocument.where(start_conditions)
    count = sell.count

    sell = SellDocument.where(start_conditions)
    count_period = UserStatistic.add_time_frame(sell, from, to).count
    
    count_without_project_offers  = -1
    count_without_project_offers_period  = -1
    result = {
      :count => count,
      :count_period => count_period,
      :count_without_project_offers => count_without_project_offers,
      :count_without_project_offers_period => count_without_project_offers_period,
    }
    Rails.logger.debug("      Letters count" + result.inspect)
    result
  end

  def count_renters(user, status, from, to)
    # renters
    start_conditions = {
        :user_id => user.id,
        :status_id => status.id,
        :offer_type_id => OfferType.for(:renters).id,
      }
    buy = Buy.where(start_conditions)
    count = buy.count

    buy = Buy.where(start_conditions)
    count_period = UserStatistic.add_time_frame(buy, from, to).count
    
    count_without_project_offers = -1
    count_without_project_offers_period = -1
    
    result = {
      :count => count,
      :count_period => count_period,
      :count_without_project_offers => count_without_project_offers,
      :count_without_project_offers_period => count_without_project_offers_period,
    }
    Rails.logger.debug("      Renters count" + result.inspect)
    result
  end

  def count_buyers(user, status, from, to)
    # buyers
    start_conditions = {
        :user_id => user.id,
        :status_id => status.id,
        :offer_type_id => OfferType.for(:buyers).id,
      }

    buy = Buy.where(start_conditions)
    count = buy.count
    
    buy = Buy.where(start_conditions)
    count_period = UserStatistic.add_time_frame(buy, from, to).count
    
    count_without_project_offers = -1
    count_without_project_offers_period = -1
    result = {
      :count => count,
      :count_period => count_period,
      :count_without_project_offers => count_without_project_offers,
      :count_without_project_offers_period => count_without_project_offers_period,
    }
    Rails.logger.debug("      Buyers count" + result.inspect)
    result
  end

  def count_projects(user, status, from, to)
    Rails.logger.debug("      - count projects =======================================")
    Project.unscoped.where(:status_id => status.id).scoping do
      Rails.logger.debug("        Projects count.sql #{Project.where({:user_id => user.id}).to_sql}")
      count = Project.where({:user_id => user.id}).count()
      Rails.logger.debug("        Projects count_period.sql #{UserStatistic.add_time_frame_ar(Project.where({:user_id => user.id}), from, to).to_sql}")
      count_period = UserStatistic.add_time_frame_ar(Project.where({:user_id => user.id}), from, to).count()
      count_without_project_offers = -1
      count_without_project_offers_period = -1
      result = {
        :count => count,
        :count_period => count_period,
        :count_without_project_offers => count_without_project_offers,
        :count_without_project_offers_period => count_without_project_offers_period,
      }
      Rails.logger.debug("      Projects count" + result.inspect)
      result
    end
  end

  
  def self.add_time_frame_ar object, from, to
    unless from.blank?
      Rails.logger.debug("Adding time constrain from >= #{from.to_formatted_s(:db)}")
      object = object.where("#{object.model_name.tableize}.created_at >= '#{from.to_formatted_s(:db)}'")
    end

    unless to.blank?
      Rails.logger.debug("Adding time constrain to <= #{to.to_formatted_s(:db)}")
      object = object.where("#{object.model_name.tableize}.created_at <= '#{to.to_formatted_s(:db)}'")
    end

    object
  end

  def self.add_time_frame object, from, to
    unless from.blank?
      object.where({:last_updated => {"$gte" => from.to_i}})
    end

    unless to.blank?
      object.where({:last_updated => {"$lte" => to.to_i}})
    end

    object
  end

  def self.kinds
    [:projects, :buyers,  :sellers, :renters, :letters, ]
  end
end
