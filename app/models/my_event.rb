class MyEvent < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :event

  # Allowed status values
  STATUSES = %w[yes no maybe]

  # Validations
  validates_inclusion_of :status, :in => STATUSES
  validates_presence_of :user_id
  validates_presence_of :event_id
end
