class CreateShortUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :short_urls do |t|
      # Users will look for short urls
      t.string :full_url
      t.string :title
      t.integer :click_count, default: 0
      t.string :short_code, index: true
      t.timestamps
    end
  end
end
