# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  url        :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
  validates :title, :url, :content, presence: true
  validates :url, uniqueness: true
  extend FriendlyId
  friendly_id :url
end
