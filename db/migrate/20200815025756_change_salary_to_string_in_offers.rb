class ChangeSalaryToStringInOffers < ActiveRecord::Migration[6.0]
  def change
    change_column :offers, :salary, :string
  end
end
