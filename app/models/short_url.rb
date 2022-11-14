require 'open-uri'
class ShortUrl < ApplicationRecord

  validates :full_url, url: true, presence: true, uniqueness: { case_sensitive: false }
  validates :short_code, presence: true, uniqueness: { case_sensitive: true }
  before_validation :add_short_code

  # increments clicks count by 1
  def increment_clicks!
    self.click_count += 1
    self.save
  end

  # Finds a url by short code
  def self.find_by_short_code(short_code)
     ShortUrl.find_by(short_code: short_code)
  end

  # Gets a given page content by its url
  # Turns the page content into a string
  # Uses parse function to retrieve the title
  def update_title!
    html = URI.open(self.full_url)
    html_str = html.read
    page_title = html_str.match(/<title\s*.*>\s*.*<\/title>/)
    title = parse_page_title(page_title[0])
    self.title = title
    self.save
  end

  private

  # Parses a html string to get title element content
  def parse_page_title(page_title)
    title_start =  page_title.index('title')

    nil if title_start.nil?

    str_cleaned = page_title[title_start + 6, page_title.size - 1]

    title_end = str_cleaned.index('title')

    nil if title_end.nil?

    str_cleaned = str_cleaned[0, title_end - 2]
    str_cleaned
  end

  # Generates a random code to identify the url
  def add_short_code
    if self.short_code.nil?
      self.short_code = SecureRandom.alphanumeric(8)
    end
  end

end
