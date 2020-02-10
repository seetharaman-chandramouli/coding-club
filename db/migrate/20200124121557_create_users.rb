class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :first_name, null: false
    	t.string :last_name, null: false
    	t.bigint :mobile_number, null: false
    	t.integer :age, null: false
    	t.string :batch, null: false
    	t.string :degree, null: false
    	t.string :college_name, null: false
    	t.string :register_number, null: false
    	t.string :company_name
    	t.string :designation
    	t.string :location
    	t.string :email, unique: true
    	t.string :password_digest, null: false
    	t.boolean :active, default: false
        t.boolean :admin, default: false
    end
  end 
end
