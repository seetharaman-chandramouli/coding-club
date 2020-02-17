class CreateAnswervotes < ActiveRecord::Migration
  def change
    create_table :answervotes do |t|
    	t.integer :answer_id
    	t.integer :user_id
    end
  end
end
