class ShortUrl < ApplicationRecord

  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :full_url, url: true, presence: true, uniqueness: { case_sensitive: false }
  validates :short_code, presence: true, uniqueness: { case_sensitive: true }
  validates :full_url, url: true, if: :full_url_changed?
  before_validation :add_short_code

  def increment_clicks!
    self.click_count += 1
    self.save
  end

end
