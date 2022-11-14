require 'json'

class Api::V1::ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # Retrieves top 100 urls by click counts
  def index
    @short_urls = ShortUrl.order(click_count: :desc)
                          .take(100)
    render json: JSON.generate({ urls: @short_urls.to_json })
  end

  # Creates a new short url
  # Retrieves page title by using UpdateTitleJob job
  def create
    @short_url = ShortUrl.create(full_url: params[:full_url])
    if @short_url.valid?
      UpdateTitleJob.perform_later(@short_url.id)
      render json: JSON.generate({short_url: "#{request.host_with_port}/#{@short_url.short_code}"}), status: :created
    else
      @previously_added = ShortUrl.find_by_full_url(params[:full_url])
      unless @previously_added.nil?
        render json: JSON.generate({short_url: "#{request.host_with_port}/#{@previously_added.short_code}"}), status: :created
      else
        render json: JSON.generate({ errors: @short_url.errors.to_json }), status: :unprocessable_entity
      end
    end
  end

  # Redirect to a url by its short code
  # Increments short url clicks count
  def show
    @short_url = ShortUrl.find_by_short_code(params[:short_code])
    unless @short_url.nil?
      redirect_to @short_url.full_url
      @short_url.increment_clicks!
    else
      redirect_to '/404.html'
    end
  end

  def options
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
    headers['Access-Control-Request-Method'] = '*',
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-type'
    head :ok
  end

end
