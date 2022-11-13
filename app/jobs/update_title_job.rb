require 'open-uri'

class UpdateTitleJob < ApplicationJob
  queue_as :default

  # Gets a given page content by its url
  # Turns the page content into a string
  # Uses parse function to retrieve the title
  def perform(id)
    short_url = ShortUrl.find(id)
    html = URI.open(short_url.full_url)
    html_str = html.read

    page_title = parse_page_title(html_str)

    short_url.title = page_title
    short_url.save
  end

  private

  # Gets the title content
  def parse_page_title(html_str)
    title_start =  html_str.index('title')

    nil if title_start.nil?

    str_cleaned = html_str[title_start + 6, html_str.size - 1]
    title_end = str_cleaned.index('title')

    nil if title_end.nil?

    str_cleaned = str_cleaned[0, title_end - 2]
    str_cleaned
  end

end
