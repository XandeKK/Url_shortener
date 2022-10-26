class Url < ApplicationRecord

  before_validation :update_shortener

  validates :link, presence: true
  validates_format_of :link, with: /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)/

  validates :shortener, presence: true
  validates :shortener, length: { is: 8 }

  validates :expiration_time, presence: true

  def get_url_shortener
    if self.expiration_time < DateTime
      self.update_shortener
    end
  end

  def update_shortener
    loop do
      self.shortener = SecureRandom.alphanumeric(8)
      break unless self.class.exists?(:shortener => shortener)
    end
    self.update_expiration
  end

  def update_expiration
    self.expiration_time = 1.hours.after
  end

  def update_if_expired
    if self.expiration_time < DateTime.now
      self.update_shortener
    end
  end
end
