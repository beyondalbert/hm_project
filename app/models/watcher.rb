class Watcher < ActiveRecord::Base
  belongs_to :device
  validates :user_id, uniqueness: { scope: :device_id }

  def email
    User.find(self.user_id).email
  end
end
