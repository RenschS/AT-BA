class Comment < ActiveRecord::Base
  belongs_to :tool
  validates :commenter, presence: true, length: {minimum: 4}
  validates :body, presence: true, length: {minimum: 4}
end
