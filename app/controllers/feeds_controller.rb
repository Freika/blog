class FeedsController < ApplicationController
  layout false

  def rss
    @posts = Post.published
  end
end
