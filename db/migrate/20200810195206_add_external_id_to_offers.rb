class AddExternalIdToOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :external_id, :integer
  end
end
