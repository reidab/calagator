class MyEvent < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :event

  # Allowed status values
  STATUSES = %w[yes maybe no]

  # Validations
  validates_inclusion_of :status, :in => STATUSES
  validates_presence_of :user_id
  validates_presence_of :event_id

  # Return a human-readable status label for the given +status+.
  def self.status_label_for(status)
    return status.titleize
  end

  # Return a human-readable status label for this MyEvent instance.
  def status_label
    return self.class.status_label_for(self.status)
  end
end
