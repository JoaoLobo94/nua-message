class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

  validates :body, presence: true
  scope :unread, -> { where(read: false) }

end