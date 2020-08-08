class RemoveScheduleFromOffers < ActiveRecord::Migration[6.0]
  def change
    remove_column :offers, :schedule
  end
end
