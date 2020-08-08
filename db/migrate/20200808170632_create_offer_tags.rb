class CreateOfferTags < ActiveRecord::Migration[6.0]
  def change
    create_table :offer_tags do |t|
      t.references :offer, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
