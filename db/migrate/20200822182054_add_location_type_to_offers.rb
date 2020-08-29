class AddLocationTypeToOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :location_type, :boolean
  end
end
