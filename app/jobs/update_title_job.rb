class UpdateTitleJob < ApplicationJob
  queue_as :default

  # Uses the update title function from ShortUrl model
  # to get and update the page title
  def perform(id)
    short_url = ShortUrl.find(id)
    short_url.update_title!
  end

end
