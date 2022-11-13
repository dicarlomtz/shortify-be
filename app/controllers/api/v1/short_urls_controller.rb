require 'json'

class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    @short_urls = ShortUrl.order(:click_count)
                          .take(100)
    render json: JSON.generate({ urls: @short_urls.to_json })
  end

  def create
  end

  def show
  end

end
