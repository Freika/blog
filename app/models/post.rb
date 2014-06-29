class Post < ActiveRecord::Base
  validates :title, :url, :content, presence: true
  validates :url, uniqueness: true
end
