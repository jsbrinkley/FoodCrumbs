class CreatePlacesFinders < ActiveRecord::Migration
  def change
    create_table :places_finders do |t|

      t.timestamps
    end
  end
end
