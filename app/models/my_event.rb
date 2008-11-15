class MyEvent < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :event

  # Allowed status values
  STATUSES = %w[yes maybe no]

  # Statuses interpreted as "interesting" enough to list
  INTERESTING_STATUSES = %w[yes maybe]

  # Validations
  validates_inclusion_of :status, :in => STATUSES
  validates_presence_of :user_id
  validates_presence_of :event_id

  # Scopes
  named_scope :interesting, :conditions => ['status in (?)', INTERESTING_STATUSES]

  # Return a human-readable status label for the given +status+.
  def self.status_label_for(status)
    return status.titleize
  end

  # Return a human-readable status label for this MyEvent instance.
  def status_label
    return self.class.status_label_for(self.status)
  end
end
