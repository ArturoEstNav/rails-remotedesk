class AddSourceToOffers < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :source, :string
  end
end
