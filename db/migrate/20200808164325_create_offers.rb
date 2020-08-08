class CreateOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :offers do |t|
      t.string :company
      t.string :title
      t.text :description
      t.integer :salary
      t.string :category
      t.string :job_type
      t.string :location
      t.string :position
      t.datetime :posting_date
      t.string :listing_url
      t.boolean :active

      t.timestamps
    end
  end
end
