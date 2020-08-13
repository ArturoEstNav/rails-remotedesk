class ChangeOffersExternalIdType < ActiveRecord::Migration[6.0]
  def change
    change_column :offers, :external_id, :string
  end
end
