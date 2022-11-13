class ShortUrl < ApplicationRecord

  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :full_url, url: true, presence: true, uniqueness: { case_sensitive: false }
  validates :short_code, presence: true, uniqueness: { case_sensitive: true }
  before_validation :add_short_code

  def increment_clicks!
    self.click_count += 1
    self.save
  end

  def self.find_by_short_code(short_code)
     ShortUrl.find_by(short_code: short_code)
  end

  def update_title!
    UpdateTitleJob.perform_later(self.id)
  end

  private

  def add_short_code
    self.short_code = SecureRandom.alphanumeric(8)
  end

end
