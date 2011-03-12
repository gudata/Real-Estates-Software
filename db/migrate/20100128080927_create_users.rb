class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :login,               :null => false                # optional, you can use email instead, or both
      t.string    :email,               :null => false                # optional, you can use login instead, or both
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

      # magic states
      t.boolean    :active, :null => false, :default => true
      
      # Custom fields
      t.text :signature
      t.text :chat
      
      # http://github.com/karmi/localized_country_select/tree/master
#      t.text :country
#      t.text :city
      t.string :webpage
      t.string :first_name
      t.string :last_name
      t.string :second_name
      t.boolean :assistant, :default => false
      t.string :company_webpage
      t.string :phone
      t.string :mobile
      t.datetime :birth
      t.string :locale

      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size

      #      t.belongs_to :job_type


      t.integer :role_id

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string  :real_name

      t.timestamps
    end
    
    add_index(:users, :role_id)
    add_index(:users, [:parent_id, :lft, :rgt])
  end

  
  def self.down
    remove_table :users
    remove_index(:users, :role_id)
    remove_index(:users, [:parent_id, :lft, :rgt])
  end
end
