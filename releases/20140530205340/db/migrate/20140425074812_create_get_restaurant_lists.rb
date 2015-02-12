class CreateGetRestaurantLists < ActiveRecord::Migration
  def change
    create_table :get_restaurant_lists do |t|
      t.integer :errorCode
      t.string :message
      t.string :googleRoute
      t.string :listOfRestaurants

      t.timestamps
    end
  end
end
