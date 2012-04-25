Re::Application.routes.draw do
  root :to => "admin/contacts#index_contacts"
  #  Translate::Routes.translation_ui(map) if RAILS_ENV != "production"

    #  https://github.com/ccoenen/rails-translate
    scope '/translate' do
      match '/translate_list', :to => 'translate#index'
      match '/translate', :to => 'translate#translate'
      match '/translate_reload', :to => 'translate#reload'
    end
  
  resources :navigations do
    collection do
      get :cities
      get :quarters
      get :update_address
      get :clean_cache
      get :terms
    end
  end


  namespace :admin do

    resources :statistics do
      collection do
        get :offers_by_team
        get :do_offers_by_team
        get :full_report
        get :do_full_report
      end
    end
    
    resources :contacts do
      collection do
        get :index_clients
        get :index_contacts
        get :check
      end
      member do
        get :add
        get :tab_contact
        get :tab_projects
        get :tab_sells
        get :tab_buys
        get :show_offers
      end

      resources :buys do
        collection do
          get :tab_basic_data
          get :tab_search_results
          get :show_attachments
        end
        member do
          get :add_search_criterias
          get :buy_search_result
          get :change_buy_status
        end
        resources :buy_addresses
        resources :attachments 
        resources :search_criterias do
          member do
            get :property_type_keywords
            get :criteria_search_result
          end
        end
      end

      resources :sells do
        resources :pictures do
          collection do
            get :reload_pictures
          end
        end
      end

      resources :projects do
        resources :project_sells, :as => :sells
        member do
          get :tab_project_sells
        end
      end

    end # end contacts

    namespace :indexes do
      resources :sells do
        collection do
          get :print_sells
          get :user_offers
        end
        member do
          get :print
        end
      end

      resources :projects, :except => [:new, :create] do
        resources :project_sells, :as => :sells
        
        collection do
          get :print_projects
          get :user_projects
        end
        member do
          get :print
        end
      end

      resources :buys do
        collection do
          get :print_buys
          get :user_offers
        end
      end
    end # end indexes
      
    resources :roles
    resources :users do
      collection do
        get :help
      end
      member do
        get :activate
      end

    end

    resources :navigations do
      collection do
        get :nomenclatures
        get :guest_screen
      end
    end

    resources :countries
    resources :districts
    resources :municipalities do
      collection do
        get :load_districts
      end
    end
    
    resources :cities do
      resources :quarters do
        collection do
          get :add_multiple
          post :do_add_multiple
        end
      end
      
      collection do
        get :load_districts
        get :load_municipalities
        get :load_places
      end
    end
    
    resources :offices
    resources :teams do
      collection do
        get :update_team_users
      end


    end
    resources :spheres
    resources :contact_categories
    resources :phones
    resources :phone_types
    resources :internet_comunicators
    resources :internet_comunicator_types
    resources :exposure_types
    resources :construction_types
    resources :property_functions
    resources :property_types
    resources :heating_types
    resources :infrastructure_types
    resources :road_types
    resources :room_types
    resources :apartment_types
    resources :rooms
    resources :buildings
    resources :building_types
    resources :fence_types
    resources :property_locations
    resources :property_category_locations
    resources :keywords
    resources :validation_types
    resources :offer_types
    resources :inspections
    #resources :pictures
    resources :furnishes
    resources :sources
    resources :statuses
    resources :buy_statuses
    resources :standart_choices
    resources :project_stages
    resources :floor_types
    resources :street_types
    resources :canceled_types

    resources :index_sells do
      member do
        get :print
      end
    end

    resources :index_projects do
      member do
        get :print
        get :sells
      end
    end

    resources :addresses do
      collection do
        get :get_districts
        get :get_cities
      end
    end

  end

  match '/' => 'admin/contacts#index'
  resource :account, :controller => "users"
  resources :users
  resource :user_session
  resources :password_resets
  match '/:controller(/:action(/:id))'
end

__END__

ActionController::Routing::Routes.draw do |map|  

  
  #  Translate::Routes.translation_ui(map) if RAILS_ENV != "production"
  
  map.resources  :navigations,
    :collection => [:cities]

  map.namespace :admin do |admin|
    admin.resources :contacts,
      :collection => {
      :index_clients => :get,
      :check => :get
    },
      :member => {
      :add => :get,
      :tab_projects => :get,
      :tab_sells => :get,
      :tab_buys => :get
    } do |contact|
        
      contact.resources :buys,
        :member => {
        :add_search_criterias => :get,
        :buy_search_result => :get,
        :change_buy_status => :get,
      } do |buy|
        buy.resources :buy_addresses
        buy.resources :search_criterias,
          :member => {
          :property_type_keywords => :any,
          :criteria_search_result => :get,
        }
      end

      contact.resources :sells, :member => {:print => :get}

      contact.resources :projects, :member => {
        :print => :get,
        :tab_project_sells => :get,
      } do |project|
        project.resources :sells, :controller => "project_sells"
      end

      admin.namespace :indexes do |index|

        index.resources :sells,
          :member => {:print => :get},
          :collection => {
          :print_sells => :get,
          :user_offers => :get
        }

        index.resources :projects,
          :member => {:print => :get},
          :collection => {
          :print_projects => :get,
          :user_projects => :get
        } do |project|
          project.resources :sells
        end

        index.resources :buys,
          :member => {:print => :get},
          :collection => {
          :print_buys => :get,
          :user_offers => :get
        }
      end

    end

    admin.resources :roles

    admin.resources :users,
      :collection => {:help => :get},
      :member => {:activate => :get}

    admin.resources  :navigations, 
      :collection => [:nomenclatures, :guest_screen]

    admin.resources :countries
    admin.resources :districts

    admin.resources :municipalities,
      :collection => {:load_districts => :get}

    admin.resources :cities,
      :has_many => :quarters,
      :collection => {
      :load_municipalities => :any,
      :load_places => :any,
    }
    
    admin.resources :quarters, :collection => {
      :add_multiple => :get,
      :do_add_multiple => :post
    }
    admin.resources :offices

    admin.resources :teams, 
      :collection => {:update_team_users => :get}

    admin.resources :spheres
    admin.resources :contact_categories
    admin.resources :phones
    admin.resources :phone_types
    admin.resources :internet_comunicators
    admin.resources :internet_comunicator_types
    admin.resources :exposure_types
    admin.resources :construction_types
    admin.resources :property_functions
    admin.resources :property_types
    admin.resources :heating_types
    admin.resources :infrastructure_types
    admin.resources :road_types
    admin.resources :room_types
    admin.resources :apartment_types
    admin.resources :rooms
    admin.resources :buildings
    admin.resources :building_types
    admin.resources :fence_types
    admin.resources :property_locations
    admin.resources :property_category_locations
    admin.resources :keywords
    admin.resources :validation_types
    admin.resources :offer_types
    admin.resources :inspections
    admin.resources :pictures
    admin.resources :furnishes
    admin.resources :sources
    admin.resources :statuses
    admin.resources :buy_statuses
    admin.resources :standart_choices
    admin.resources :project_stages

    admin.resources :index_sells, 
      :except => [:new, :create],
      :member => {:print => :get}
    
    admin.resources :index_projects, 
      :except => [:new, :create],
      :member => {
      :print => :get,
      :sells => :get
    }

    admin.resources :addresses,
      :collection => {
      :update_address=> :get,
      :get_districts => :get,
      :get_cities => :get
    }
  end

  map.root :controller => "admin/contacts", :action => 'index'

  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session
  map.resources :password_resets
  
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
#== Route Map
# Generated on 10 Dec 2010 10:57
#
#                                                     root        /(.:format)                                                                                    {:action=>"index_contacts", :controller=>"admin/contacts"}
#                                           translate_list        /translate/translate_list(.:format)                                                            {:action=>"index", :controller=>"translate"}
#                                                translate        /translate/translate(.:format)                                                                 {:action=>"translate", :controller=>"translate"}
#                                         translate_reload        /translate/translate_reload(.:format)                                                          {:action=>"reload", :controller=>"translate"}
#                                       cities_navigations GET    /navigations/cities(.:format)                                                                  {:action=>"cities", :controller=>"navigations"}
#                                     quarters_navigations GET    /navigations/quarters(.:format)                                                                {:action=>"quarters", :controller=>"navigations"}
#                               update_address_navigations GET    /navigations/update_address(.:format)                                                          {:action=>"update_address", :controller=>"navigations"}
#                                  clean_cache_navigations GET    /navigations/clean_cache(.:format)                                                             {:action=>"clean_cache", :controller=>"navigations"}
#                                        terms_navigations GET    /navigations/terms(.:format)                                                                   {:action=>"terms", :controller=>"navigations"}
#                                              navigations GET    /navigations(.:format)                                                                         {:action=>"index", :controller=>"navigations"}
#                                                          POST   /navigations(.:format)                                                                         {:action=>"create", :controller=>"navigations"}
#                                           new_navigation GET    /navigations/new(.:format)                                                                     {:action=>"new", :controller=>"navigations"}
#                                          edit_navigation GET    /navigations/:id/edit(.:format)                                                                {:action=>"edit", :controller=>"navigations"}
#                                               navigation GET    /navigations/:id(.:format)                                                                     {:action=>"show", :controller=>"navigations"}
#                                                          PUT    /navigations/:id(.:format)                                                                     {:action=>"update", :controller=>"navigations"}
#                                                          DELETE /navigations/:id(.:format)                                                                     {:action=>"destroy", :controller=>"navigations"}
#                          offers_by_team_admin_statistics GET    /admin/statistics/offers_by_team(.:format)                                                     {:action=>"offers_by_team", :controller=>"admin/statistics"}
#                       do_offers_by_team_admin_statistics GET    /admin/statistics/do_offers_by_team(.:format)                                                  {:action=>"do_offers_by_team", :controller=>"admin/statistics"}
#                                         admin_statistics GET    /admin/statistics(.:format)                                                                    {:action=>"index", :controller=>"admin/statistics"}
#                                                          POST   /admin/statistics(.:format)                                                                    {:action=>"create", :controller=>"admin/statistics"}
#                                      new_admin_statistic GET    /admin/statistics/new(.:format)                                                                {:action=>"new", :controller=>"admin/statistics"}
#                                     edit_admin_statistic GET    /admin/statistics/:id/edit(.:format)                                                           {:action=>"edit", :controller=>"admin/statistics"}
#                                          admin_statistic GET    /admin/statistics/:id(.:format)                                                                {:action=>"show", :controller=>"admin/statistics"}
#                                                          PUT    /admin/statistics/:id(.:format)                                                                {:action=>"update", :controller=>"admin/statistics"}
#                                                          DELETE /admin/statistics/:id(.:format)                                                                {:action=>"destroy", :controller=>"admin/statistics"}
#                             index_clients_admin_contacts GET    /admin/contacts/index_clients(.:format)                                                        {:action=>"index_clients", :controller=>"admin/contacts"}
#                            index_contacts_admin_contacts GET    /admin/contacts/index_contacts(.:format)                                                       {:action=>"index_contacts", :controller=>"admin/contacts"}
#                                     check_admin_contacts GET    /admin/contacts/check(.:format)                                                                {:action=>"check", :controller=>"admin/contacts"}
#                                        add_admin_contact GET    /admin/contacts/:id/add(.:format)                                                              {:action=>"add", :controller=>"admin/contacts"}
#                                tab_contact_admin_contact GET    /admin/contacts/:id/tab_contact(.:format)                                                      {:action=>"tab_contact", :controller=>"admin/contacts"}
#                               tab_projects_admin_contact GET    /admin/contacts/:id/tab_projects(.:format)                                                     {:action=>"tab_projects", :controller=>"admin/contacts"}
#                                  tab_sells_admin_contact GET    /admin/contacts/:id/tab_sells(.:format)                                                        {:action=>"tab_sells", :controller=>"admin/contacts"}
#                                   tab_buys_admin_contact GET    /admin/contacts/:id/tab_buys(.:format)                                                         {:action=>"tab_buys", :controller=>"admin/contacts"}
#                                show_offers_admin_contact GET    /admin/contacts/:id/show_offers(.:format)                                                      {:action=>"show_offers", :controller=>"admin/contacts"}
#                        tab_basic_data_admin_contact_buys GET    /admin/contacts/:contact_id/buys/tab_basic_data(.:format)                                      {:action=>"tab_basic_data", :controller=>"admin/buys"}
#                    tab_search_results_admin_contact_buys GET    /admin/contacts/:contact_id/buys/tab_search_results(.:format)                                  {:action=>"tab_search_results", :controller=>"admin/buys"}
#                      show_attachments_admin_contact_buys GET    /admin/contacts/:contact_id/buys/show_attachments(.:format)                                    {:action=>"show_attachments", :controller=>"admin/buys"}
#                   add_search_criterias_admin_contact_buy GET    /admin/contacts/:contact_id/buys/:id/add_search_criterias(.:format)                            {:action=>"add_search_criterias", :controller=>"admin/buys"}
#                      buy_search_result_admin_contact_buy GET    /admin/contacts/:contact_id/buys/:id/buy_search_result(.:format)                               {:action=>"buy_search_result", :controller=>"admin/buys"}
#                      change_buy_status_admin_contact_buy GET    /admin/contacts/:contact_id/buys/:id/change_buy_status(.:format)                               {:action=>"change_buy_status", :controller=>"admin/buys"}
#                          admin_contact_buy_buy_addresses GET    /admin/contacts/:contact_id/buys/:buy_id/buy_addresses(.:format)                               {:action=>"index", :controller=>"admin/buy_addresses"}
#                                                          POST   /admin/contacts/:contact_id/buys/:buy_id/buy_addresses(.:format)                               {:action=>"create", :controller=>"admin/buy_addresses"}
#                        new_admin_contact_buy_buy_address GET    /admin/contacts/:contact_id/buys/:buy_id/buy_addresses/new(.:format)                           {:action=>"new", :controller=>"admin/buy_addresses"}
#                       edit_admin_contact_buy_buy_address GET    /admin/contacts/:contact_id/buys/:buy_id/buy_addresses/:id/edit(.:format)                      {:action=>"edit", :controller=>"admin/buy_addresses"}
#                            admin_contact_buy_buy_address GET    /admin/contacts/:contact_id/buys/:buy_id/buy_addresses/:id(.:format)                           {:action=>"show", :controller=>"admin/buy_addresses"}
#                                                          PUT    /admin/contacts/:contact_id/buys/:buy_id/buy_addresses/:id(.:format)                           {:action=>"update", :controller=>"admin/buy_addresses"}
#                                                          DELETE /admin/contacts/:contact_id/buys/:buy_id/buy_addresses/:id(.:format)                           {:action=>"destroy", :controller=>"admin/buy_addresses"}
#                            admin_contact_buy_attachments GET    /admin/contacts/:contact_id/buys/:buy_id/attachments(.:format)                                 {:action=>"index", :controller=>"admin/attachments"}
#                                                          POST   /admin/contacts/:contact_id/buys/:buy_id/attachments(.:format)                                 {:action=>"create", :controller=>"admin/attachments"}
#                         new_admin_contact_buy_attachment GET    /admin/contacts/:contact_id/buys/:buy_id/attachments/new(.:format)                             {:action=>"new", :controller=>"admin/attachments"}
#                        edit_admin_contact_buy_attachment GET    /admin/contacts/:contact_id/buys/:buy_id/attachments/:id/edit(.:format)                        {:action=>"edit", :controller=>"admin/attachments"}
#                             admin_contact_buy_attachment GET    /admin/contacts/:contact_id/buys/:buy_id/attachments/:id(.:format)                             {:action=>"show", :controller=>"admin/attachments"}
#                                                          PUT    /admin/contacts/:contact_id/buys/:buy_id/attachments/:id(.:format)                             {:action=>"update", :controller=>"admin/attachments"}
#                                                          DELETE /admin/contacts/:contact_id/buys/:buy_id/attachments/:id(.:format)                             {:action=>"destroy", :controller=>"admin/attachments"}
# property_type_keywords_admin_contact_buy_search_criteria GET    /admin/contacts/:contact_id/buys/:buy_id/search_criterias/:id/property_type_keywords(.:format) {:action=>"property_type_keywords", :controller=>"admin/search_criterias"}
# criteria_search_result_admin_contact_buy_search_criteria GET    /admin/contacts/:contact_id/buys/:buy_id/search_criterias/:id/criteria_search_result(.:format) {:action=>"criteria_search_result", :controller=>"admin/search_criterias"}
#                       admin_contact_buy_search_criterias GET    /admin/contacts/:contact_id/buys/:buy_id/search_criterias(.:format)                            {:action=>"index", :controller=>"admin/search_criterias"}
#                                                          POST   /admin/contacts/:contact_id/buys/:buy_id/search_criterias(.:format)                            {:action=>"create", :controller=>"admin/search_criterias"}
#                    new_admin_contact_buy_search_criteria GET    /admin/contacts/:contact_id/buys/:buy_id/search_criterias/new(.:format)                        {:action=>"new", :controller=>"admin/search_criterias"}
#                   edit_admin_contact_buy_search_criteria GET    /admin/contacts/:contact_id/buys/:buy_id/search_criterias/:id/edit(.:format)                   {:action=>"edit", :controller=>"admin/search_criterias"}
#                        admin_contact_buy_search_criteria GET    /admin/contacts/:contact_id/buys/:buy_id/search_criterias/:id(.:format)                        {:action=>"show", :controller=>"admin/search_criterias"}
#                                                          PUT    /admin/contacts/:contact_id/buys/:buy_id/search_criterias/:id(.:format)                        {:action=>"update", :controller=>"admin/search_criterias"}
#                                                          DELETE /admin/contacts/:contact_id/buys/:buy_id/search_criterias/:id(.:format)                        {:action=>"destroy", :controller=>"admin/search_criterias"}
#                                       admin_contact_buys GET    /admin/contacts/:contact_id/buys(.:format)                                                     {:action=>"index", :controller=>"admin/buys"}
#                                                          POST   /admin/contacts/:contact_id/buys(.:format)                                                     {:action=>"create", :controller=>"admin/buys"}
#                                    new_admin_contact_buy GET    /admin/contacts/:contact_id/buys/new(.:format)                                                 {:action=>"new", :controller=>"admin/buys"}
#                                   edit_admin_contact_buy GET    /admin/contacts/:contact_id/buys/:id/edit(.:format)                                            {:action=>"edit", :controller=>"admin/buys"}
#                                        admin_contact_buy GET    /admin/contacts/:contact_id/buys/:id(.:format)                                                 {:action=>"show", :controller=>"admin/buys"}
#                                                          PUT    /admin/contacts/:contact_id/buys/:id(.:format)                                                 {:action=>"update", :controller=>"admin/buys"}
#                                                          DELETE /admin/contacts/:contact_id/buys/:id(.:format)                                                 {:action=>"destroy", :controller=>"admin/buys"}
#                                      admin_contact_sells GET    /admin/contacts/:contact_id/sells(.:format)                                                    {:action=>"index", :controller=>"admin/sells"}
#                                                          POST   /admin/contacts/:contact_id/sells(.:format)                                                    {:action=>"create", :controller=>"admin/sells"}
#                                   new_admin_contact_sell GET    /admin/contacts/:contact_id/sells/new(.:format)                                                {:action=>"new", :controller=>"admin/sells"}
#                                  edit_admin_contact_sell GET    /admin/contacts/:contact_id/sells/:id/edit(.:format)                                           {:action=>"edit", :controller=>"admin/sells"}
#                                       admin_contact_sell GET    /admin/contacts/:contact_id/sells/:id(.:format)                                                {:action=>"show", :controller=>"admin/sells"}
#                                                          PUT    /admin/contacts/:contact_id/sells/:id(.:format)                                                {:action=>"update", :controller=>"admin/sells"}
#                                                          DELETE /admin/contacts/:contact_id/sells/:id(.:format)                                                {:action=>"destroy", :controller=>"admin/sells"}
#                              admin_contact_project_sells GET    /admin/contacts/:contact_id/projects/:project_id/project_sells(.:format)                       {:action=>"index", :controller=>"admin/project_sells"}
#                                                          POST   /admin/contacts/:contact_id/projects/:project_id/project_sells(.:format)                       {:action=>"create", :controller=>"admin/project_sells"}
#                           new_admin_contact_project_sell GET    /admin/contacts/:contact_id/projects/:project_id/project_sells/new(.:format)                   {:action=>"new", :controller=>"admin/project_sells"}
#                          edit_admin_contact_project_sell GET    /admin/contacts/:contact_id/projects/:project_id/project_sells/:id/edit(.:format)              {:action=>"edit", :controller=>"admin/project_sells"}
#                               admin_contact_project_sell GET    /admin/contacts/:contact_id/projects/:project_id/project_sells/:id(.:format)                   {:action=>"show", :controller=>"admin/project_sells"}
#                                                          PUT    /admin/contacts/:contact_id/projects/:project_id/project_sells/:id(.:format)                   {:action=>"update", :controller=>"admin/project_sells"}
#                                                          DELETE /admin/contacts/:contact_id/projects/:project_id/project_sells/:id(.:format)                   {:action=>"destroy", :controller=>"admin/project_sells"}
#                  tab_project_sells_admin_contact_project GET    /admin/contacts/:contact_id/projects/:id/tab_project_sells(.:format)                           {:action=>"tab_project_sells", :controller=>"admin/projects"}
#                                   admin_contact_projects GET    /admin/contacts/:contact_id/projects(.:format)                                                 {:action=>"index", :controller=>"admin/projects"}
#                                                          POST   /admin/contacts/:contact_id/projects(.:format)                                                 {:action=>"create", :controller=>"admin/projects"}
#                                new_admin_contact_project GET    /admin/contacts/:contact_id/projects/new(.:format)                                             {:action=>"new", :controller=>"admin/projects"}
#                               edit_admin_contact_project GET    /admin/contacts/:contact_id/projects/:id/edit(.:format)                                        {:action=>"edit", :controller=>"admin/projects"}
#                                    admin_contact_project GET    /admin/contacts/:contact_id/projects/:id(.:format)                                             {:action=>"show", :controller=>"admin/projects"}
#                                                          PUT    /admin/contacts/:contact_id/projects/:id(.:format)                                             {:action=>"update", :controller=>"admin/projects"}
#                                                          DELETE /admin/contacts/:contact_id/projects/:id(.:format)                                             {:action=>"destroy", :controller=>"admin/projects"}
#                                           admin_contacts GET    /admin/contacts(.:format)                                                                      {:action=>"index", :controller=>"admin/contacts"}
#                                                          POST   /admin/contacts(.:format)                                                                      {:action=>"create", :controller=>"admin/contacts"}
#                                        new_admin_contact GET    /admin/contacts/new(.:format)                                                                  {:action=>"new", :controller=>"admin/contacts"}
#                                       edit_admin_contact GET    /admin/contacts/:id/edit(.:format)                                                             {:action=>"edit", :controller=>"admin/contacts"}
#                                            admin_contact GET    /admin/contacts/:id(.:format)                                                                  {:action=>"show", :controller=>"admin/contacts"}
#                                                          PUT    /admin/contacts/:id(.:format)                                                                  {:action=>"update", :controller=>"admin/contacts"}
#                                                          DELETE /admin/contacts/:id(.:format)                                                                  {:action=>"destroy", :controller=>"admin/contacts"}
#                          print_sells_admin_indexes_sells GET    /admin/indexes/sells/print_sells(.:format)                                                     {:action=>"print_sells", :controller=>"admin/indexes/sells"}
#                          user_offers_admin_indexes_sells GET    /admin/indexes/sells/user_offers(.:format)                                                     {:action=>"user_offers", :controller=>"admin/indexes/sells"}
#                                 print_admin_indexes_sell GET    /admin/indexes/sells/:id/print(.:format)                                                       {:action=>"print", :controller=>"admin/indexes/sells"}
#                                      admin_indexes_sells GET    /admin/indexes/sells(.:format)                                                                 {:action=>"index", :controller=>"admin/indexes/sells"}
#                                                          POST   /admin/indexes/sells(.:format)                                                                 {:action=>"create", :controller=>"admin/indexes/sells"}
#                                   new_admin_indexes_sell GET    /admin/indexes/sells/new(.:format)                                                             {:action=>"new", :controller=>"admin/indexes/sells"}
#                                  edit_admin_indexes_sell GET    /admin/indexes/sells/:id/edit(.:format)                                                        {:action=>"edit", :controller=>"admin/indexes/sells"}
#                                       admin_indexes_sell GET    /admin/indexes/sells/:id(.:format)                                                             {:action=>"show", :controller=>"admin/indexes/sells"}
#                                                          PUT    /admin/indexes/sells/:id(.:format)                                                             {:action=>"update", :controller=>"admin/indexes/sells"}
#                                                          DELETE /admin/indexes/sells/:id(.:format)                                                             {:action=>"destroy", :controller=>"admin/indexes/sells"}
#                              admin_indexes_project_sells GET    /admin/indexes/projects/:project_id/project_sells(.:format)                                    {:action=>"index", :controller=>"admin/indexes/project_sells"}
#                                                          POST   /admin/indexes/projects/:project_id/project_sells(.:format)                                    {:action=>"create", :controller=>"admin/indexes/project_sells"}
#                           new_admin_indexes_project_sell GET    /admin/indexes/projects/:project_id/project_sells/new(.:format)                                {:action=>"new", :controller=>"admin/indexes/project_sells"}
#                          edit_admin_indexes_project_sell GET    /admin/indexes/projects/:project_id/project_sells/:id/edit(.:format)                           {:action=>"edit", :controller=>"admin/indexes/project_sells"}
#                               admin_indexes_project_sell GET    /admin/indexes/projects/:project_id/project_sells/:id(.:format)                                {:action=>"show", :controller=>"admin/indexes/project_sells"}
#                                                          PUT    /admin/indexes/projects/:project_id/project_sells/:id(.:format)                                {:action=>"update", :controller=>"admin/indexes/project_sells"}
#                                                          DELETE /admin/indexes/projects/:project_id/project_sells/:id(.:format)                                {:action=>"destroy", :controller=>"admin/indexes/project_sells"}
#                    print_projects_admin_indexes_projects GET    /admin/indexes/projects/print_projects(.:format)                                               {:action=>"print_projects", :controller=>"admin/indexes/projects"}
#                     user_projects_admin_indexes_projects GET    /admin/indexes/projects/user_projects(.:format)                                                {:action=>"user_projects", :controller=>"admin/indexes/projects"}
#                              print_admin_indexes_project GET    /admin/indexes/projects/:id/print(.:format)                                                    {:action=>"print", :controller=>"admin/indexes/projects"}
#                                   admin_indexes_projects GET    /admin/indexes/projects(.:format)                                                              {:action=>"index", :controller=>"admin/indexes/projects"}
#                               edit_admin_indexes_project GET    /admin/indexes/projects/:id/edit(.:format)                                                     {:action=>"edit", :controller=>"admin/indexes/projects"}
#                                    admin_indexes_project GET    /admin/indexes/projects/:id(.:format)                                                          {:action=>"show", :controller=>"admin/indexes/projects"}
#                                                          PUT    /admin/indexes/projects/:id(.:format)                                                          {:action=>"update", :controller=>"admin/indexes/projects"}
#                                                          DELETE /admin/indexes/projects/:id(.:format)                                                          {:action=>"destroy", :controller=>"admin/indexes/projects"}
#                            print_buys_admin_indexes_buys GET    /admin/indexes/buys/print_buys(.:format)                                                       {:action=>"print_buys", :controller=>"admin/indexes/buys"}
#                           user_offers_admin_indexes_buys GET    /admin/indexes/buys/user_offers(.:format)                                                      {:action=>"user_offers", :controller=>"admin/indexes/buys"}
#                                       admin_indexes_buys GET    /admin/indexes/buys(.:format)                                                                  {:action=>"index", :controller=>"admin/indexes/buys"}
#                                                          POST   /admin/indexes/buys(.:format)                                                                  {:action=>"create", :controller=>"admin/indexes/buys"}
#                                    new_admin_indexes_buy GET    /admin/indexes/buys/new(.:format)                                                              {:action=>"new", :controller=>"admin/indexes/buys"}
#                                   edit_admin_indexes_buy GET    /admin/indexes/buys/:id/edit(.:format)                                                         {:action=>"edit", :controller=>"admin/indexes/buys"}
#                                        admin_indexes_buy GET    /admin/indexes/buys/:id(.:format)                                                              {:action=>"show", :controller=>"admin/indexes/buys"}
#                                                          PUT    /admin/indexes/buys/:id(.:format)                                                              {:action=>"update", :controller=>"admin/indexes/buys"}
#                                                          DELETE /admin/indexes/buys/:id(.:format)                                                              {:action=>"destroy", :controller=>"admin/indexes/buys"}
#                                              admin_roles GET    /admin/roles(.:format)                                                                         {:action=>"index", :controller=>"admin/roles"}
#                                                          POST   /admin/roles(.:format)                                                                         {:action=>"create", :controller=>"admin/roles"}
#                                           new_admin_role GET    /admin/roles/new(.:format)                                                                     {:action=>"new", :controller=>"admin/roles"}
#                                          edit_admin_role GET    /admin/roles/:id/edit(.:format)                                                                {:action=>"edit", :controller=>"admin/roles"}
#                                               admin_role GET    /admin/roles/:id(.:format)                                                                     {:action=>"show", :controller=>"admin/roles"}
#                                                          PUT    /admin/roles/:id(.:format)                                                                     {:action=>"update", :controller=>"admin/roles"}
#                                                          DELETE /admin/roles/:id(.:format)                                                                     {:action=>"destroy", :controller=>"admin/roles"}
#                                         help_admin_users GET    /admin/users/help(.:format)                                                                    {:action=>"help", :controller=>"admin/users"}
#                                      activate_admin_user GET    /admin/users/:id/activate(.:format)                                                            {:action=>"activate", :controller=>"admin/users"}
#                                              admin_users GET    /admin/users(.:format)                                                                         {:action=>"index", :controller=>"admin/users"}
#                                                          POST   /admin/users(.:format)                                                                         {:action=>"create", :controller=>"admin/users"}
#                                           new_admin_user GET    /admin/users/new(.:format)                                                                     {:action=>"new", :controller=>"admin/users"}
#                                          edit_admin_user GET    /admin/users/:id/edit(.:format)                                                                {:action=>"edit", :controller=>"admin/users"}
#                                               admin_user GET    /admin/users/:id(.:format)                                                                     {:action=>"show", :controller=>"admin/users"}
#                                                          PUT    /admin/users/:id(.:format)                                                                     {:action=>"update", :controller=>"admin/users"}
#                                                          DELETE /admin/users/:id(.:format)                                                                     {:action=>"destroy", :controller=>"admin/users"}
#                          nomenclatures_admin_navigations GET    /admin/navigations/nomenclatures(.:format)                                                     {:action=>"nomenclatures", :controller=>"admin/navigations"}
#                           guest_screen_admin_navigations GET    /admin/navigations/guest_screen(.:format)                                                      {:action=>"guest_screen", :controller=>"admin/navigations"}
#                                        admin_navigations GET    /admin/navigations(.:format)                                                                   {:action=>"index", :controller=>"admin/navigations"}
#                                                          POST   /admin/navigations(.:format)                                                                   {:action=>"create", :controller=>"admin/navigations"}
#                                     new_admin_navigation GET    /admin/navigations/new(.:format)                                                               {:action=>"new", :controller=>"admin/navigations"}
#                                    edit_admin_navigation GET    /admin/navigations/:id/edit(.:format)                                                          {:action=>"edit", :controller=>"admin/navigations"}
#                                         admin_navigation GET    /admin/navigations/:id(.:format)                                                               {:action=>"show", :controller=>"admin/navigations"}
#                                                          PUT    /admin/navigations/:id(.:format)                                                               {:action=>"update", :controller=>"admin/navigations"}
#                                                          DELETE /admin/navigations/:id(.:format)                                                               {:action=>"destroy", :controller=>"admin/navigations"}
#                                          admin_countries GET    /admin/countries(.:format)                                                                     {:action=>"index", :controller=>"admin/countries"}
#                                                          POST   /admin/countries(.:format)                                                                     {:action=>"create", :controller=>"admin/countries"}
#                                        new_admin_country GET    /admin/countries/new(.:format)                                                                 {:action=>"new", :controller=>"admin/countries"}
#                                       edit_admin_country GET    /admin/countries/:id/edit(.:format)                                                            {:action=>"edit", :controller=>"admin/countries"}
#                                            admin_country GET    /admin/countries/:id(.:format)                                                                 {:action=>"show", :controller=>"admin/countries"}
#                                                          PUT    /admin/countries/:id(.:format)                                                                 {:action=>"update", :controller=>"admin/countries"}
#                                                          DELETE /admin/countries/:id(.:format)                                                                 {:action=>"destroy", :controller=>"admin/countries"}
#                                          admin_districts GET    /admin/districts(.:format)                                                                     {:action=>"index", :controller=>"admin/districts"}
#                                                          POST   /admin/districts(.:format)                                                                     {:action=>"create", :controller=>"admin/districts"}
#                                       new_admin_district GET    /admin/districts/new(.:format)                                                                 {:action=>"new", :controller=>"admin/districts"}
#                                      edit_admin_district GET    /admin/districts/:id/edit(.:format)                                                            {:action=>"edit", :controller=>"admin/districts"}
#                                           admin_district GET    /admin/districts/:id(.:format)                                                                 {:action=>"show", :controller=>"admin/districts"}
#                                                          PUT    /admin/districts/:id(.:format)                                                                 {:action=>"update", :controller=>"admin/districts"}
#                                                          DELETE /admin/districts/:id(.:format)                                                                 {:action=>"destroy", :controller=>"admin/districts"}
#                      load_districts_admin_municipalities GET    /admin/municipalities/load_districts(.:format)                                                 {:action=>"load_districts", :controller=>"admin/municipalities"}
#                                     admin_municipalities GET    /admin/municipalities(.:format)                                                                {:action=>"index", :controller=>"admin/municipalities"}
#                                                          POST   /admin/municipalities(.:format)                                                                {:action=>"create", :controller=>"admin/municipalities"}
#                                   new_admin_municipality GET    /admin/municipalities/new(.:format)                                                            {:action=>"new", :controller=>"admin/municipalities"}
#                                  edit_admin_municipality GET    /admin/municipalities/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"admin/municipalities"}
#                                       admin_municipality GET    /admin/municipalities/:id(.:format)                                                            {:action=>"show", :controller=>"admin/municipalities"}
#                                                          PUT    /admin/municipalities/:id(.:format)                                                            {:action=>"update", :controller=>"admin/municipalities"}
#                                                          DELETE /admin/municipalities/:id(.:format)                                                            {:action=>"destroy", :controller=>"admin/municipalities"}
#                         add_multiple_admin_city_quarters GET    /admin/cities/:city_id/quarters/add_multiple(.:format)                                         {:action=>"add_multiple", :controller=>"admin/quarters"}
#                      do_add_multiple_admin_city_quarters POST   /admin/cities/:city_id/quarters/do_add_multiple(.:format)                                      {:action=>"do_add_multiple", :controller=>"admin/quarters"}
#                                      admin_city_quarters GET    /admin/cities/:city_id/quarters(.:format)                                                      {:action=>"index", :controller=>"admin/quarters"}
#                                                          POST   /admin/cities/:city_id/quarters(.:format)                                                      {:action=>"create", :controller=>"admin/quarters"}
#                                   new_admin_city_quarter GET    /admin/cities/:city_id/quarters/new(.:format)                                                  {:action=>"new", :controller=>"admin/quarters"}
#                                  edit_admin_city_quarter GET    /admin/cities/:city_id/quarters/:id/edit(.:format)                                             {:action=>"edit", :controller=>"admin/quarters"}
#                                       admin_city_quarter GET    /admin/cities/:city_id/quarters/:id(.:format)                                                  {:action=>"show", :controller=>"admin/quarters"}
#                                                          PUT    /admin/cities/:city_id/quarters/:id(.:format)                                                  {:action=>"update", :controller=>"admin/quarters"}
#                                                          DELETE /admin/cities/:city_id/quarters/:id(.:format)                                                  {:action=>"destroy", :controller=>"admin/quarters"}
#                              load_districts_admin_cities GET    /admin/cities/load_districts(.:format)                                                         {:action=>"load_districts", :controller=>"admin/cities"}
#                         load_municipalities_admin_cities GET    /admin/cities/load_municipalities(.:format)                                                    {:action=>"load_municipalities", :controller=>"admin/cities"}
#                                 load_places_admin_cities GET    /admin/cities/load_places(.:format)                                                            {:action=>"load_places", :controller=>"admin/cities"}
#                                             admin_cities GET    /admin/cities(.:format)                                                                        {:action=>"index", :controller=>"admin/cities"}
#                                                          POST   /admin/cities(.:format)                                                                        {:action=>"create", :controller=>"admin/cities"}
#                                           new_admin_city GET    /admin/cities/new(.:format)                                                                    {:action=>"new", :controller=>"admin/cities"}
#                                          edit_admin_city GET    /admin/cities/:id/edit(.:format)                                                               {:action=>"edit", :controller=>"admin/cities"}
#                                               admin_city GET    /admin/cities/:id(.:format)                                                                    {:action=>"show", :controller=>"admin/cities"}
#                                                          PUT    /admin/cities/:id(.:format)                                                                    {:action=>"update", :controller=>"admin/cities"}
#                                                          DELETE /admin/cities/:id(.:format)                                                                    {:action=>"destroy", :controller=>"admin/cities"}
#                                            admin_offices GET    /admin/offices(.:format)                                                                       {:action=>"index", :controller=>"admin/offices"}
#                                                          POST   /admin/offices(.:format)                                                                       {:action=>"create", :controller=>"admin/offices"}
#                                         new_admin_office GET    /admin/offices/new(.:format)                                                                   {:action=>"new", :controller=>"admin/offices"}
#                                        edit_admin_office GET    /admin/offices/:id/edit(.:format)                                                              {:action=>"edit", :controller=>"admin/offices"}
#                                             admin_office GET    /admin/offices/:id(.:format)                                                                   {:action=>"show", :controller=>"admin/offices"}
#                                                          PUT    /admin/offices/:id(.:format)                                                                   {:action=>"update", :controller=>"admin/offices"}
#                                                          DELETE /admin/offices/:id(.:format)                                                                   {:action=>"destroy", :controller=>"admin/offices"}
#                            update_team_users_admin_teams GET    /admin/teams/update_team_users(.:format)                                                       {:action=>"update_team_users", :controller=>"admin/teams"}
#                                              admin_teams GET    /admin/teams(.:format)                                                                         {:action=>"index", :controller=>"admin/teams"}
#                                                          POST   /admin/teams(.:format)                                                                         {:action=>"create", :controller=>"admin/teams"}
#                                           new_admin_team GET    /admin/teams/new(.:format)                                                                     {:action=>"new", :controller=>"admin/teams"}
#                                          edit_admin_team GET    /admin/teams/:id/edit(.:format)                                                                {:action=>"edit", :controller=>"admin/teams"}
#                                               admin_team GET    /admin/teams/:id(.:format)                                                                     {:action=>"show", :controller=>"admin/teams"}
#                                                          PUT    /admin/teams/:id(.:format)                                                                     {:action=>"update", :controller=>"admin/teams"}
#                                                          DELETE /admin/teams/:id(.:format)                                                                     {:action=>"destroy", :controller=>"admin/teams"}
#                                            admin_spheres GET    /admin/spheres(.:format)                                                                       {:action=>"index", :controller=>"admin/spheres"}
#                                                          POST   /admin/spheres(.:format)                                                                       {:action=>"create", :controller=>"admin/spheres"}
#                                         new_admin_sphere GET    /admin/spheres/new(.:format)                                                                   {:action=>"new", :controller=>"admin/spheres"}
#                                        edit_admin_sphere GET    /admin/spheres/:id/edit(.:format)                                                              {:action=>"edit", :controller=>"admin/spheres"}
#                                             admin_sphere GET    /admin/spheres/:id(.:format)                                                                   {:action=>"show", :controller=>"admin/spheres"}
#                                                          PUT    /admin/spheres/:id(.:format)                                                                   {:action=>"update", :controller=>"admin/spheres"}
#                                                          DELETE /admin/spheres/:id(.:format)                                                                   {:action=>"destroy", :controller=>"admin/spheres"}
#                                 admin_contact_categories GET    /admin/contact_categories(.:format)                                                            {:action=>"index", :controller=>"admin/contact_categories"}
#                                                          POST   /admin/contact_categories(.:format)                                                            {:action=>"create", :controller=>"admin/contact_categories"}
#                               new_admin_contact_category GET    /admin/contact_categories/new(.:format)                                                        {:action=>"new", :controller=>"admin/contact_categories"}
#                              edit_admin_contact_category GET    /admin/contact_categories/:id/edit(.:format)                                                   {:action=>"edit", :controller=>"admin/contact_categories"}
#                                   admin_contact_category GET    /admin/contact_categories/:id(.:format)                                                        {:action=>"show", :controller=>"admin/contact_categories"}
#                                                          PUT    /admin/contact_categories/:id(.:format)                                                        {:action=>"update", :controller=>"admin/contact_categories"}
#                                                          DELETE /admin/contact_categories/:id(.:format)                                                        {:action=>"destroy", :controller=>"admin/contact_categories"}
#                                             admin_phones GET    /admin/phones(.:format)                                                                        {:action=>"index", :controller=>"admin/phones"}
#                                                          POST   /admin/phones(.:format)                                                                        {:action=>"create", :controller=>"admin/phones"}
#                                          new_admin_phone GET    /admin/phones/new(.:format)                                                                    {:action=>"new", :controller=>"admin/phones"}
#                                         edit_admin_phone GET    /admin/phones/:id/edit(.:format)                                                               {:action=>"edit", :controller=>"admin/phones"}
#                                              admin_phone GET    /admin/phones/:id(.:format)                                                                    {:action=>"show", :controller=>"admin/phones"}
#                                                          PUT    /admin/phones/:id(.:format)                                                                    {:action=>"update", :controller=>"admin/phones"}
#                                                          DELETE /admin/phones/:id(.:format)                                                                    {:action=>"destroy", :controller=>"admin/phones"}
#                                        admin_phone_types GET    /admin/phone_types(.:format)                                                                   {:action=>"index", :controller=>"admin/phone_types"}
#                                                          POST   /admin/phone_types(.:format)                                                                   {:action=>"create", :controller=>"admin/phone_types"}
#                                     new_admin_phone_type GET    /admin/phone_types/new(.:format)                                                               {:action=>"new", :controller=>"admin/phone_types"}
#                                    edit_admin_phone_type GET    /admin/phone_types/:id/edit(.:format)                                                          {:action=>"edit", :controller=>"admin/phone_types"}
#                                         admin_phone_type GET    /admin/phone_types/:id(.:format)                                                               {:action=>"show", :controller=>"admin/phone_types"}
#                                                          PUT    /admin/phone_types/:id(.:format)                                                               {:action=>"update", :controller=>"admin/phone_types"}
#                                                          DELETE /admin/phone_types/:id(.:format)                                                               {:action=>"destroy", :controller=>"admin/phone_types"}
#                              admin_internet_comunicators GET    /admin/internet_comunicators(.:format)                                                         {:action=>"index", :controller=>"admin/internet_comunicators"}
#                                                          POST   /admin/internet_comunicators(.:format)                                                         {:action=>"create", :controller=>"admin/internet_comunicators"}
#                           new_admin_internet_comunicator GET    /admin/internet_comunicators/new(.:format)                                                     {:action=>"new", :controller=>"admin/internet_comunicators"}
#                          edit_admin_internet_comunicator GET    /admin/internet_comunicators/:id/edit(.:format)                                                {:action=>"edit", :controller=>"admin/internet_comunicators"}
#                               admin_internet_comunicator GET    /admin/internet_comunicators/:id(.:format)                                                     {:action=>"show", :controller=>"admin/internet_comunicators"}
#                                                          PUT    /admin/internet_comunicators/:id(.:format)                                                     {:action=>"update", :controller=>"admin/internet_comunicators"}
#                                                          DELETE /admin/internet_comunicators/:id(.:format)                                                     {:action=>"destroy", :controller=>"admin/internet_comunicators"}
#                         admin_internet_comunicator_types GET    /admin/internet_comunicator_types(.:format)                                                    {:action=>"index", :controller=>"admin/internet_comunicator_types"}
#                                                          POST   /admin/internet_comunicator_types(.:format)                                                    {:action=>"create", :controller=>"admin/internet_comunicator_types"}
#                      new_admin_internet_comunicator_type GET    /admin/internet_comunicator_types/new(.:format)                                                {:action=>"new", :controller=>"admin/internet_comunicator_types"}
#                     edit_admin_internet_comunicator_type GET    /admin/internet_comunicator_types/:id/edit(.:format)                                           {:action=>"edit", :controller=>"admin/internet_comunicator_types"}
#                          admin_internet_comunicator_type GET    /admin/internet_comunicator_types/:id(.:format)                                                {:action=>"show", :controller=>"admin/internet_comunicator_types"}
#                                                          PUT    /admin/internet_comunicator_types/:id(.:format)                                                {:action=>"update", :controller=>"admin/internet_comunicator_types"}
#                                                          DELETE /admin/internet_comunicator_types/:id(.:format)                                                {:action=>"destroy", :controller=>"admin/internet_comunicator_types"}
#                                     admin_exposure_types GET    /admin/exposure_types(.:format)                                                                {:action=>"index", :controller=>"admin/exposure_types"}
#                                                          POST   /admin/exposure_types(.:format)                                                                {:action=>"create", :controller=>"admin/exposure_types"}
#                                  new_admin_exposure_type GET    /admin/exposure_types/new(.:format)                                                            {:action=>"new", :controller=>"admin/exposure_types"}
#                                 edit_admin_exposure_type GET    /admin/exposure_types/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"admin/exposure_types"}
#                                      admin_exposure_type GET    /admin/exposure_types/:id(.:format)                                                            {:action=>"show", :controller=>"admin/exposure_types"}
#                                                          PUT    /admin/exposure_types/:id(.:format)                                                            {:action=>"update", :controller=>"admin/exposure_types"}
#                                                          DELETE /admin/exposure_types/:id(.:format)                                                            {:action=>"destroy", :controller=>"admin/exposure_types"}
#                                 admin_construction_types GET    /admin/construction_types(.:format)                                                            {:action=>"index", :controller=>"admin/construction_types"}
#                                                          POST   /admin/construction_types(.:format)                                                            {:action=>"create", :controller=>"admin/construction_types"}
#                              new_admin_construction_type GET    /admin/construction_types/new(.:format)                                                        {:action=>"new", :controller=>"admin/construction_types"}
#                             edit_admin_construction_type GET    /admin/construction_types/:id/edit(.:format)                                                   {:action=>"edit", :controller=>"admin/construction_types"}
#                                  admin_construction_type GET    /admin/construction_types/:id(.:format)                                                        {:action=>"show", :controller=>"admin/construction_types"}
#                                                          PUT    /admin/construction_types/:id(.:format)                                                        {:action=>"update", :controller=>"admin/construction_types"}
#                                                          DELETE /admin/construction_types/:id(.:format)                                                        {:action=>"destroy", :controller=>"admin/construction_types"}
#                                 admin_property_functions GET    /admin/property_functions(.:format)                                                            {:action=>"index", :controller=>"admin/property_functions"}
#                                                          POST   /admin/property_functions(.:format)                                                            {:action=>"create", :controller=>"admin/property_functions"}
#                              new_admin_property_function GET    /admin/property_functions/new(.:format)                                                        {:action=>"new", :controller=>"admin/property_functions"}
#                             edit_admin_property_function GET    /admin/property_functions/:id/edit(.:format)                                                   {:action=>"edit", :controller=>"admin/property_functions"}
#                                  admin_property_function GET    /admin/property_functions/:id(.:format)                                                        {:action=>"show", :controller=>"admin/property_functions"}
#                                                          PUT    /admin/property_functions/:id(.:format)                                                        {:action=>"update", :controller=>"admin/property_functions"}
#                                                          DELETE /admin/property_functions/:id(.:format)                                                        {:action=>"destroy", :controller=>"admin/property_functions"}
#                                     admin_property_types GET    /admin/property_types(.:format)                                                                {:action=>"index", :controller=>"admin/property_types"}
#                                                          POST   /admin/property_types(.:format)                                                                {:action=>"create", :controller=>"admin/property_types"}
#                                  new_admin_property_type GET    /admin/property_types/new(.:format)                                                            {:action=>"new", :controller=>"admin/property_types"}
#                                 edit_admin_property_type GET    /admin/property_types/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"admin/property_types"}
#                                      admin_property_type GET    /admin/property_types/:id(.:format)                                                            {:action=>"show", :controller=>"admin/property_types"}
#                                                          PUT    /admin/property_types/:id(.:format)                                                            {:action=>"update", :controller=>"admin/property_types"}
#                                                          DELETE /admin/property_types/:id(.:format)                                                            {:action=>"destroy", :controller=>"admin/property_types"}
#                                      admin_heating_types GET    /admin/heating_types(.:format)                                                                 {:action=>"index", :controller=>"admin/heating_types"}
#                                                          POST   /admin/heating_types(.:format)                                                                 {:action=>"create", :controller=>"admin/heating_types"}
#                                   new_admin_heating_type GET    /admin/heating_types/new(.:format)                                                             {:action=>"new", :controller=>"admin/heating_types"}
#                                  edit_admin_heating_type GET    /admin/heating_types/:id/edit(.:format)                                                        {:action=>"edit", :controller=>"admin/heating_types"}
#                                       admin_heating_type GET    /admin/heating_types/:id(.:format)                                                             {:action=>"show", :controller=>"admin/heating_types"}
#                                                          PUT    /admin/heating_types/:id(.:format)                                                             {:action=>"update", :controller=>"admin/heating_types"}
#                                                          DELETE /admin/heating_types/:id(.:format)                                                             {:action=>"destroy", :controller=>"admin/heating_types"}
#                               admin_infrastructure_types GET    /admin/infrastructure_types(.:format)                                                          {:action=>"index", :controller=>"admin/infrastructure_types"}
#                                                          POST   /admin/infrastructure_types(.:format)                                                          {:action=>"create", :controller=>"admin/infrastructure_types"}
#                            new_admin_infrastructure_type GET    /admin/infrastructure_types/new(.:format)                                                      {:action=>"new", :controller=>"admin/infrastructure_types"}
#                           edit_admin_infrastructure_type GET    /admin/infrastructure_types/:id/edit(.:format)                                                 {:action=>"edit", :controller=>"admin/infrastructure_types"}
#                                admin_infrastructure_type GET    /admin/infrastructure_types/:id(.:format)                                                      {:action=>"show", :controller=>"admin/infrastructure_types"}
#                                                          PUT    /admin/infrastructure_types/:id(.:format)                                                      {:action=>"update", :controller=>"admin/infrastructure_types"}
#                                                          DELETE /admin/infrastructure_types/:id(.:format)                                                      {:action=>"destroy", :controller=>"admin/infrastructure_types"}
#                                         admin_road_types GET    /admin/road_types(.:format)                                                                    {:action=>"index", :controller=>"admin/road_types"}
#                                                          POST   /admin/road_types(.:format)                                                                    {:action=>"create", :controller=>"admin/road_types"}
#                                      new_admin_road_type GET    /admin/road_types/new(.:format)                                                                {:action=>"new", :controller=>"admin/road_types"}
#                                     edit_admin_road_type GET    /admin/road_types/:id/edit(.:format)                                                           {:action=>"edit", :controller=>"admin/road_types"}
#                                          admin_road_type GET    /admin/road_types/:id(.:format)                                                                {:action=>"show", :controller=>"admin/road_types"}
#                                                          PUT    /admin/road_types/:id(.:format)                                                                {:action=>"update", :controller=>"admin/road_types"}
#                                                          DELETE /admin/road_types/:id(.:format)                                                                {:action=>"destroy", :controller=>"admin/road_types"}
#                                         admin_room_types GET    /admin/room_types(.:format)                                                                    {:action=>"index", :controller=>"admin/room_types"}
#                                                          POST   /admin/room_types(.:format)                                                                    {:action=>"create", :controller=>"admin/room_types"}
#                                      new_admin_room_type GET    /admin/room_types/new(.:format)                                                                {:action=>"new", :controller=>"admin/room_types"}
#                                     edit_admin_room_type GET    /admin/room_types/:id/edit(.:format)                                                           {:action=>"edit", :controller=>"admin/room_types"}
#                                          admin_room_type GET    /admin/room_types/:id(.:format)                                                                {:action=>"show", :controller=>"admin/room_types"}
#                                                          PUT    /admin/room_types/:id(.:format)                                                                {:action=>"update", :controller=>"admin/room_types"}
#                                                          DELETE /admin/room_types/:id(.:format)                                                                {:action=>"destroy", :controller=>"admin/room_types"}
#                                    admin_apartment_types GET    /admin/apartment_types(.:format)                                                               {:action=>"index", :controller=>"admin/apartment_types"}
#                                                          POST   /admin/apartment_types(.:format)                                                               {:action=>"create", :controller=>"admin/apartment_types"}
#                                 new_admin_apartment_type GET    /admin/apartment_types/new(.:format)                                                           {:action=>"new", :controller=>"admin/apartment_types"}
#                                edit_admin_apartment_type GET    /admin/apartment_types/:id/edit(.:format)                                                      {:action=>"edit", :controller=>"admin/apartment_types"}
#                                     admin_apartment_type GET    /admin/apartment_types/:id(.:format)                                                           {:action=>"show", :controller=>"admin/apartment_types"}
#                                                          PUT    /admin/apartment_types/:id(.:format)                                                           {:action=>"update", :controller=>"admin/apartment_types"}
#                                                          DELETE /admin/apartment_types/:id(.:format)                                                           {:action=>"destroy", :controller=>"admin/apartment_types"}
#                                              admin_rooms GET    /admin/rooms(.:format)                                                                         {:action=>"index", :controller=>"admin/rooms"}
#                                                          POST   /admin/rooms(.:format)                                                                         {:action=>"create", :controller=>"admin/rooms"}
#                                           new_admin_room GET    /admin/rooms/new(.:format)                                                                     {:action=>"new", :controller=>"admin/rooms"}
#                                          edit_admin_room GET    /admin/rooms/:id/edit(.:format)                                                                {:action=>"edit", :controller=>"admin/rooms"}
#                                               admin_room GET    /admin/rooms/:id(.:format)                                                                     {:action=>"show", :controller=>"admin/rooms"}
#                                                          PUT    /admin/rooms/:id(.:format)                                                                     {:action=>"update", :controller=>"admin/rooms"}
#                                                          DELETE /admin/rooms/:id(.:format)                                                                     {:action=>"destroy", :controller=>"admin/rooms"}
#                                          admin_buildings GET    /admin/buildings(.:format)                                                                     {:action=>"index", :controller=>"admin/buildings"}
#                                                          POST   /admin/buildings(.:format)                                                                     {:action=>"create", :controller=>"admin/buildings"}
#                                       new_admin_building GET    /admin/buildings/new(.:format)                                                                 {:action=>"new", :controller=>"admin/buildings"}
#                                      edit_admin_building GET    /admin/buildings/:id/edit(.:format)                                                            {:action=>"edit", :controller=>"admin/buildings"}
#                                           admin_building GET    /admin/buildings/:id(.:format)                                                                 {:action=>"show", :controller=>"admin/buildings"}
#                                                          PUT    /admin/buildings/:id(.:format)                                                                 {:action=>"update", :controller=>"admin/buildings"}
#                                                          DELETE /admin/buildings/:id(.:format)                                                                 {:action=>"destroy", :controller=>"admin/buildings"}
#                                     admin_building_types GET    /admin/building_types(.:format)                                                                {:action=>"index", :controller=>"admin/building_types"}
#                                                          POST   /admin/building_types(.:format)                                                                {:action=>"create", :controller=>"admin/building_types"}
#                                  new_admin_building_type GET    /admin/building_types/new(.:format)                                                            {:action=>"new", :controller=>"admin/building_types"}
#                                 edit_admin_building_type GET    /admin/building_types/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"admin/building_types"}
#                                      admin_building_type GET    /admin/building_types/:id(.:format)                                                            {:action=>"show", :controller=>"admin/building_types"}
#                                                          PUT    /admin/building_types/:id(.:format)                                                            {:action=>"update", :controller=>"admin/building_types"}
#                                                          DELETE /admin/building_types/:id(.:format)                                                            {:action=>"destroy", :controller=>"admin/building_types"}
#                                        admin_fence_types GET    /admin/fence_types(.:format)                                                                   {:action=>"index", :controller=>"admin/fence_types"}
#                                                          POST   /admin/fence_types(.:format)                                                                   {:action=>"create", :controller=>"admin/fence_types"}
#                                     new_admin_fence_type GET    /admin/fence_types/new(.:format)                                                               {:action=>"new", :controller=>"admin/fence_types"}
#                                    edit_admin_fence_type GET    /admin/fence_types/:id/edit(.:format)                                                          {:action=>"edit", :controller=>"admin/fence_types"}
#                                         admin_fence_type GET    /admin/fence_types/:id(.:format)                                                               {:action=>"show", :controller=>"admin/fence_types"}
#                                                          PUT    /admin/fence_types/:id(.:format)                                                               {:action=>"update", :controller=>"admin/fence_types"}
#                                                          DELETE /admin/fence_types/:id(.:format)                                                               {:action=>"destroy", :controller=>"admin/fence_types"}
#                                 admin_property_locations GET    /admin/property_locations(.:format)                                                            {:action=>"index", :controller=>"admin/property_locations"}
#                                                          POST   /admin/property_locations(.:format)                                                            {:action=>"create", :controller=>"admin/property_locations"}
#                              new_admin_property_location GET    /admin/property_locations/new(.:format)                                                        {:action=>"new", :controller=>"admin/property_locations"}
#                             edit_admin_property_location GET    /admin/property_locations/:id/edit(.:format)                                                   {:action=>"edit", :controller=>"admin/property_locations"}
#                                  admin_property_location GET    /admin/property_locations/:id(.:format)                                                        {:action=>"show", :controller=>"admin/property_locations"}
#                                                          PUT    /admin/property_locations/:id(.:format)                                                        {:action=>"update", :controller=>"admin/property_locations"}
#                                                          DELETE /admin/property_locations/:id(.:format)                                                        {:action=>"destroy", :controller=>"admin/property_locations"}
#                        admin_property_category_locations GET    /admin/property_category_locations(.:format)                                                   {:action=>"index", :controller=>"admin/property_category_locations"}
#                                                          POST   /admin/property_category_locations(.:format)                                                   {:action=>"create", :controller=>"admin/property_category_locations"}
#                     new_admin_property_category_location GET    /admin/property_category_locations/new(.:format)                                               {:action=>"new", :controller=>"admin/property_category_locations"}
#                    edit_admin_property_category_location GET    /admin/property_category_locations/:id/edit(.:format)                                          {:action=>"edit", :controller=>"admin/property_category_locations"}
#                         admin_property_category_location GET    /admin/property_category_locations/:id(.:format)                                               {:action=>"show", :controller=>"admin/property_category_locations"}
#                                                          PUT    /admin/property_category_locations/:id(.:format)                                               {:action=>"update", :controller=>"admin/property_category_locations"}
#                                                          DELETE /admin/property_category_locations/:id(.:format)                                               {:action=>"destroy", :controller=>"admin/property_category_locations"}
#                                           admin_keywords GET    /admin/keywords(.:format)                                                                      {:action=>"index", :controller=>"admin/keywords"}
#                                                          POST   /admin/keywords(.:format)                                                                      {:action=>"create", :controller=>"admin/keywords"}
#                                        new_admin_keyword GET    /admin/keywords/new(.:format)                                                                  {:action=>"new", :controller=>"admin/keywords"}
#                                       edit_admin_keyword GET    /admin/keywords/:id/edit(.:format)                                                             {:action=>"edit", :controller=>"admin/keywords"}
#                                            admin_keyword GET    /admin/keywords/:id(.:format)                                                                  {:action=>"show", :controller=>"admin/keywords"}
#                                                          PUT    /admin/keywords/:id(.:format)                                                                  {:action=>"update", :controller=>"admin/keywords"}
#                                                          DELETE /admin/keywords/:id(.:format)                                                                  {:action=>"destroy", :controller=>"admin/keywords"}
#                                   admin_validation_types GET    /admin/validation_types(.:format)                                                              {:action=>"index", :controller=>"admin/validation_types"}
#                                                          POST   /admin/validation_types(.:format)                                                              {:action=>"create", :controller=>"admin/validation_types"}
#                                new_admin_validation_type GET    /admin/validation_types/new(.:format)                                                          {:action=>"new", :controller=>"admin/validation_types"}
#                               edit_admin_validation_type GET    /admin/validation_types/:id/edit(.:format)                                                     {:action=>"edit", :controller=>"admin/validation_types"}
#                                    admin_validation_type GET    /admin/validation_types/:id(.:format)                                                          {:action=>"show", :controller=>"admin/validation_types"}
#                                                          PUT    /admin/validation_types/:id(.:format)                                                          {:action=>"update", :controller=>"admin/validation_types"}
#                                                          DELETE /admin/validation_types/:id(.:format)                                                          {:action=>"destroy", :controller=>"admin/validation_types"}
#                                        admin_offer_types GET    /admin/offer_types(.:format)                                                                   {:action=>"index", :controller=>"admin/offer_types"}
#                                                          POST   /admin/offer_types(.:format)                                                                   {:action=>"create", :controller=>"admin/offer_types"}
#                                     new_admin_offer_type GET    /admin/offer_types/new(.:format)                                                               {:action=>"new", :controller=>"admin/offer_types"}
#                                    edit_admin_offer_type GET    /admin/offer_types/:id/edit(.:format)                                                          {:action=>"edit", :controller=>"admin/offer_types"}
#                                         admin_offer_type GET    /admin/offer_types/:id(.:format)                                                               {:action=>"show", :controller=>"admin/offer_types"}
#                                                          PUT    /admin/offer_types/:id(.:format)                                                               {:action=>"update", :controller=>"admin/offer_types"}
#                                                          DELETE /admin/offer_types/:id(.:format)                                                               {:action=>"destroy", :controller=>"admin/offer_types"}
#                                        admin_inspections GET    /admin/inspections(.:format)                                                                   {:action=>"index", :controller=>"admin/inspections"}
#                                                          POST   /admin/inspections(.:format)                                                                   {:action=>"create", :controller=>"admin/inspections"}
#                                     new_admin_inspection GET    /admin/inspections/new(.:format)                                                               {:action=>"new", :controller=>"admin/inspections"}
#                                    edit_admin_inspection GET    /admin/inspections/:id/edit(.:format)                                                          {:action=>"edit", :controller=>"admin/inspections"}
#                                         admin_inspection GET    /admin/inspections/:id(.:format)                                                               {:action=>"show", :controller=>"admin/inspections"}
#                                                          PUT    /admin/inspections/:id(.:format)                                                               {:action=>"update", :controller=>"admin/inspections"}
#                                                          DELETE /admin/inspections/:id(.:format)                                                               {:action=>"destroy", :controller=>"admin/inspections"}
#                                           admin_pictures GET    /admin/pictures(.:format)                                                                      {:action=>"index", :controller=>"admin/pictures"}
#                                                          POST   /admin/pictures(.:format)                                                                      {:action=>"create", :controller=>"admin/pictures"}
#                                        new_admin_picture GET    /admin/pictures/new(.:format)                                                                  {:action=>"new", :controller=>"admin/pictures"}
#                                       edit_admin_picture GET    /admin/pictures/:id/edit(.:format)                                                             {:action=>"edit", :controller=>"admin/pictures"}
#                                            admin_picture GET    /admin/pictures/:id(.:format)                                                                  {:action=>"show", :controller=>"admin/pictures"}
#                                                          PUT    /admin/pictures/:id(.:format)                                                                  {:action=>"update", :controller=>"admin/pictures"}
#                                                          DELETE /admin/pictures/:id(.:format)                                                                  {:action=>"destroy", :controller=>"admin/pictures"}
#                                          admin_furnishes GET    /admin/furnishes(.:format)                                                                     {:action=>"index", :controller=>"admin/furnishes"}
#                                                          POST   /admin/furnishes(.:format)                                                                     {:action=>"create", :controller=>"admin/furnishes"}
#                                        new_admin_furnish GET    /admin/furnishes/new(.:format)                                                                 {:action=>"new", :controller=>"admin/furnishes"}
#                                       edit_admin_furnish GET    /admin/furnishes/:id/edit(.:format)                                                            {:action=>"edit", :controller=>"admin/furnishes"}
#                                            admin_furnish GET    /admin/furnishes/:id(.:format)                                                                 {:action=>"show", :controller=>"admin/furnishes"}
#                                                          PUT    /admin/furnishes/:id(.:format)                                                                 {:action=>"update", :controller=>"admin/furnishes"}
#                                                          DELETE /admin/furnishes/:id(.:format)                                                                 {:action=>"destroy", :controller=>"admin/furnishes"}
#                                            admin_sources GET    /admin/sources(.:format)                                                                       {:action=>"index", :controller=>"admin/sources"}
#                                                          POST   /admin/sources(.:format)                                                                       {:action=>"create", :controller=>"admin/sources"}
#                                         new_admin_source GET    /admin/sources/new(.:format)                                                                   {:action=>"new", :controller=>"admin/sources"}
#                                        edit_admin_source GET    /admin/sources/:id/edit(.:format)                                                              {:action=>"edit", :controller=>"admin/sources"}
#                                             admin_source GET    /admin/sources/:id(.:format)                                                                   {:action=>"show", :controller=>"admin/sources"}
#                                                          PUT    /admin/sources/:id(.:format)                                                                   {:action=>"update", :controller=>"admin/sources"}
#                                                          DELETE /admin/sources/:id(.:format)                                                                   {:action=>"destroy", :controller=>"admin/sources"}
#                                           admin_statuses GET    /admin/statuses(.:format)                                                                      {:action=>"index", :controller=>"admin/statuses"}
#                                                          POST   /admin/statuses(.:format)                                                                      {:action=>"create", :controller=>"admin/statuses"}
#                                         new_admin_status GET    /admin/statuses/new(.:format)                                                                  {:action=>"new", :controller=>"admin/statuses"}
#                                        edit_admin_status GET    /admin/statuses/:id/edit(.:format)                                                             {:action=>"edit", :controller=>"admin/statuses"}
#                                             admin_status GET    /admin/statuses/:id(.:format)                                                                  {:action=>"show", :controller=>"admin/statuses"}
#                                                          PUT    /admin/statuses/:id(.:format)                                                                  {:action=>"update", :controller=>"admin/statuses"}
#                                                          DELETE /admin/statuses/:id(.:format)                                                                  {:action=>"destroy", :controller=>"admin/statuses"}
#                                       admin_buy_statuses GET    /admin/buy_statuses(.:format)                                                                  {:action=>"index", :controller=>"admin/buy_statuses"}
#                                                          POST   /admin/buy_statuses(.:format)                                                                  {:action=>"create", :controller=>"admin/buy_statuses"}
#                                     new_admin_buy_status GET    /admin/buy_statuses/new(.:format)                                                              {:action=>"new", :controller=>"admin/buy_statuses"}
#                                    edit_admin_buy_status GET    /admin/buy_statuses/:id/edit(.:format)                                                         {:action=>"edit", :controller=>"admin/buy_statuses"}
#                                         admin_buy_status GET    /admin/buy_statuses/:id(.:format)                                                              {:action=>"show", :controller=>"admin/buy_statuses"}
#                                                          PUT    /admin/buy_statuses/:id(.:format)                                                              {:action=>"update", :controller=>"admin/buy_statuses"}
#                                                          DELETE /admin/buy_statuses/:id(.:format)                                                              {:action=>"destroy", :controller=>"admin/buy_statuses"}
#                                   admin_standart_choices GET    /admin/standart_choices(.:format)                                                              {:action=>"index", :controller=>"admin/standart_choices"}
#                                                          POST   /admin/standart_choices(.:format)                                                              {:action=>"create", :controller=>"admin/standart_choices"}
#                                new_admin_standart_choice GET    /admin/standart_choices/new(.:format)                                                          {:action=>"new", :controller=>"admin/standart_choices"}
#                               edit_admin_standart_choice GET    /admin/standart_choices/:id/edit(.:format)                                                     {:action=>"edit", :controller=>"admin/standart_choices"}
#                                    admin_standart_choice GET    /admin/standart_choices/:id(.:format)                                                          {:action=>"show", :controller=>"admin/standart_choices"}
#                                                          PUT    /admin/standart_choices/:id(.:format)                                                          {:action=>"update", :controller=>"admin/standart_choices"}
#                                                          DELETE /admin/standart_choices/:id(.:format)                                                          {:action=>"destroy", :controller=>"admin/standart_choices"}
#                                     admin_project_stages GET    /admin/project_stages(.:format)                                                                {:action=>"index", :controller=>"admin/project_stages"}
#                                                          POST   /admin/project_stages(.:format)                                                                {:action=>"create", :controller=>"admin/project_stages"}
#                                  new_admin_project_stage GET    /admin/project_stages/new(.:format)                                                            {:action=>"new", :controller=>"admin/project_stages"}
#                                 edit_admin_project_stage GET    /admin/project_stages/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"admin/project_stages"}
#                                      admin_project_stage GET    /admin/project_stages/:id(.:format)                                                            {:action=>"show", :controller=>"admin/project_stages"}
#                                                          PUT    /admin/project_stages/:id(.:format)                                                            {:action=>"update", :controller=>"admin/project_stages"}
#                                                          DELETE /admin/project_stages/:id(.:format)                                                            {:action=>"destroy", :controller=>"admin/project_stages"}
#                                        admin_floor_types GET    /admin/floor_types(.:format)                                                                   {:action=>"index", :controller=>"admin/floor_types"}
#                                                          POST   /admin/floor_types(.:format)                                                                   {:action=>"create", :controller=>"admin/floor_types"}
#                                     new_admin_floor_type GET    /admin/floor_types/new(.:format)                                                               {:action=>"new", :controller=>"admin/floor_types"}
#                                    edit_admin_floor_type GET    /admin/floor_types/:id/edit(.:format)                                                          {:action=>"edit", :controller=>"admin/floor_types"}
#                                         admin_floor_type GET    /admin/floor_types/:id(.:format)                                                               {:action=>"show", :controller=>"admin/floor_types"}
#                                                          PUT    /admin/floor_types/:id(.:format)                                                               {:action=>"update", :controller=>"admin/floor_types"}
#                                                          DELETE /admin/floor_types/:id(.:format)                                                               {:action=>"destroy", :controller=>"admin/floor_types"}
#                                       admin_street_types GET    /admin/street_types(.:format)                                                                  {:action=>"index", :controller=>"admin/street_types"}
#                                                          POST   /admin/street_types(.:format)                                                                  {:action=>"create", :controller=>"admin/street_types"}
#                                    new_admin_street_type GET    /admin/street_types/new(.:format)                                                              {:action=>"new", :controller=>"admin/street_types"}
#                                   edit_admin_street_type GET    /admin/street_types/:id/edit(.:format)                                                         {:action=>"edit", :controller=>"admin/street_types"}
#                                        admin_street_type GET    /admin/street_types/:id(.:format)                                                              {:action=>"show", :controller=>"admin/street_types"}
#                                                          PUT    /admin/street_types/:id(.:format)                                                              {:action=>"update", :controller=>"admin/street_types"}
#                                                          DELETE /admin/street_types/:id(.:format)                                                              {:action=>"destroy", :controller=>"admin/street_types"}
#                                     admin_canceled_types GET    /admin/canceled_types(.:format)                                                                {:action=>"index", :controller=>"admin/canceled_types"}
#                                                          POST   /admin/canceled_types(.:format)                                                                {:action=>"create", :controller=>"admin/canceled_types"}
#                                  new_admin_canceled_type GET    /admin/canceled_types/new(.:format)                                                            {:action=>"new", :controller=>"admin/canceled_types"}
#                                 edit_admin_canceled_type GET    /admin/canceled_types/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"admin/canceled_types"}
#                                      admin_canceled_type GET    /admin/canceled_types/:id(.:format)                                                            {:action=>"show", :controller=>"admin/canceled_types"}
#                                                          PUT    /admin/canceled_types/:id(.:format)                                                            {:action=>"update", :controller=>"admin/canceled_types"}
#                                                          DELETE /admin/canceled_types/:id(.:format)                                                            {:action=>"destroy", :controller=>"admin/canceled_types"}
#                                   print_admin_index_sell GET    /admin/index_sells/:id/print(.:format)                                                         {:action=>"print", :controller=>"admin/index_sells"}
#                                        admin_index_sells GET    /admin/index_sells(.:format)                                                                   {:action=>"index", :controller=>"admin/index_sells"}
#                                                          POST   /admin/index_sells(.:format)                                                                   {:action=>"create", :controller=>"admin/index_sells"}
#                                     new_admin_index_sell GET    /admin/index_sells/new(.:format)                                                               {:action=>"new", :controller=>"admin/index_sells"}
#                                    edit_admin_index_sell GET    /admin/index_sells/:id/edit(.:format)                                                          {:action=>"edit", :controller=>"admin/index_sells"}
#                                         admin_index_sell GET    /admin/index_sells/:id(.:format)                                                               {:action=>"show", :controller=>"admin/index_sells"}
#                                                          PUT    /admin/index_sells/:id(.:format)                                                               {:action=>"update", :controller=>"admin/index_sells"}
#                                                          DELETE /admin/index_sells/:id(.:format)                                                               {:action=>"destroy", :controller=>"admin/index_sells"}
#                                print_admin_index_project GET    /admin/index_projects/:id/print(.:format)                                                      {:action=>"print", :controller=>"admin/index_projects"}
#                                sells_admin_index_project GET    /admin/index_projects/:id/sells(.:format)                                                      {:action=>"sells", :controller=>"admin/index_projects"}
#                                     admin_index_projects GET    /admin/index_projects(.:format)                                                                {:action=>"index", :controller=>"admin/index_projects"}
#                                                          POST   /admin/index_projects(.:format)                                                                {:action=>"create", :controller=>"admin/index_projects"}
#                                  new_admin_index_project GET    /admin/index_projects/new(.:format)                                                            {:action=>"new", :controller=>"admin/index_projects"}
#                                 edit_admin_index_project GET    /admin/index_projects/:id/edit(.:format)                                                       {:action=>"edit", :controller=>"admin/index_projects"}
#                                      admin_index_project GET    /admin/index_projects/:id(.:format)                                                            {:action=>"show", :controller=>"admin/index_projects"}
#                                                          PUT    /admin/index_projects/:id(.:format)                                                            {:action=>"update", :controller=>"admin/index_projects"}
#                                                          DELETE /admin/index_projects/:id(.:format)                                                            {:action=>"destroy", :controller=>"admin/index_projects"}
#                            get_districts_admin_addresses GET    /admin/addresses/get_districts(.:format)                                                       {:action=>"get_districts", :controller=>"admin/addresses"}
#                               get_cities_admin_addresses GET    /admin/addresses/get_cities(.:format)                                                          {:action=>"get_cities", :controller=>"admin/addresses"}
#                                          admin_addresses GET    /admin/addresses(.:format)                                                                     {:action=>"index", :controller=>"admin/addresses"}
#                                                          POST   /admin/addresses(.:format)                                                                     {:action=>"create", :controller=>"admin/addresses"}
#                                        new_admin_address GET    /admin/addresses/new(.:format)                                                                 {:action=>"new", :controller=>"admin/addresses"}
#                                       edit_admin_address GET    /admin/addresses/:id/edit(.:format)                                                            {:action=>"edit", :controller=>"admin/addresses"}
#                                            admin_address GET    /admin/addresses/:id(.:format)                                                                 {:action=>"show", :controller=>"admin/addresses"}
#                                                          PUT    /admin/addresses/:id(.:format)                                                                 {:action=>"update", :controller=>"admin/addresses"}
#                                                          DELETE /admin/addresses/:id(.:format)                                                                 {:action=>"destroy", :controller=>"admin/addresses"}
#                                                                 /(.:format)                                                                                    {:action=>"index", :controller=>"admin/contacts"}
#                                                  account POST   /account(.:format)                                                                             {:action=>"create", :controller=>"users"}
#                                              new_account GET    /account/new(.:format)                                                                         {:action=>"new", :controller=>"users"}
#                                             edit_account GET    /account/edit(.:format)                                                                        {:action=>"edit", :controller=>"users"}
#                                                          GET    /account(.:format)                                                                             {:action=>"show", :controller=>"users"}
#                                                          PUT    /account(.:format)                                                                             {:action=>"update", :controller=>"users"}
#                                                          DELETE /account(.:format)                                                                             {:action=>"destroy", :controller=>"users"}
#                                                    users GET    /users(.:format)                                                                               {:action=>"index", :controller=>"users"}
#                                                          POST   /users(.:format)                                                                               {:action=>"create", :controller=>"users"}
#                                                 new_user GET    /users/new(.:format)                                                                           {:action=>"new", :controller=>"users"}
#                                                edit_user GET    /users/:id/edit(.:format)                                                                      {:action=>"edit", :controller=>"users"}
#                                                     user GET    /users/:id(.:format)                                                                           {:action=>"show", :controller=>"users"}
#                                                          PUT    /users/:id(.:format)                                                                           {:action=>"update", :controller=>"users"}
#                                                          DELETE /users/:id(.:format)                                                                           {:action=>"destroy", :controller=>"users"}
#                                             user_session POST   /user_session(.:format)                                                                        {:action=>"create", :controller=>"user_sessions"}
#                                         new_user_session GET    /user_session/new(.:format)                                                                    {:action=>"new", :controller=>"user_sessions"}
#                                        edit_user_session GET    /user_session/edit(.:format)                                                                   {:action=>"edit", :controller=>"user_sessions"}
#                                                          GET    /user_session(.:format)                                                                        {:action=>"show", :controller=>"user_sessions"}
#                                                          PUT    /user_session(.:format)                                                                        {:action=>"update", :controller=>"user_sessions"}
#                                                          DELETE /user_session(.:format)                                                                        {:action=>"destroy", :controller=>"user_sessions"}
#                                          password_resets GET    /password_resets(.:format)                                                                     {:action=>"index", :controller=>"password_resets"}
#                                                          POST   /password_resets(.:format)                                                                     {:action=>"create", :controller=>"password_resets"}
#                                       new_password_reset GET    /password_resets/new(.:format)                                                                 {:action=>"new", :controller=>"password_resets"}
#                                      edit_password_reset GET    /password_resets/:id/edit(.:format)                                                            {:action=>"edit", :controller=>"password_resets"}
#                                           password_reset GET    /password_resets/:id(.:format)                                                                 {:action=>"show", :controller=>"password_resets"}
#                                                          PUT    /password_resets/:id(.:format)                                                                 {:action=>"update", :controller=>"password_resets"}
#                                                          DELETE /password_resets/:id(.:format)                                                                 {:action=>"destroy", :controller=>"password_resets"}
#                                                                 /:controller(/:action(/:id))(.:format)                                                         
