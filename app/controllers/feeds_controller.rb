class FeedsController < ApplicationController
  layout false

  def rss
    @posts = Post.published
  end

  def sitemap
    respond_to do |format|
      format.xml { render file: 'public/sitemaps/sitemap.xml' }
      format.html { redirect_to root_url }
    end
  end

  def robots
    @posts = Post.where(published: false)
    render 'feeds/robots.txt.erb'
  end

end
