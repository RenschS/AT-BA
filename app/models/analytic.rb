class Analytic < ActiveRecord::Base
  has_many :events
  validates :title, presence: true, length: {minimum: 4}
  validates :date1, presence: true, length: {is: 10}
  validates :date2, presence: true, length: {is: 10}
  validates :android_key, presence: true, length: {is: 20}
  validates :iphone_key, presence: true, length: {is: 20}
  validates :ipad_key, presence: true, length: {is: 20}
end
