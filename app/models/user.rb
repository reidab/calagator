require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :my_events

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login
  validates_presence_of     :email,                       :unless => :using_openid?
  validates_presence_of     :password,                    :if => :password_required?
  validates_presence_of     :password_confirmation,       :if => :password_required?
  validates_length_of       :password, :within => 4..40,  :if => :password_required?
  validates_confirmation_of :password,                    :if => :password_required?
  validates_length_of       :login,    :within => 3..40,  :unless => :using_openid?
  validates_length_of       :email,    :within => 3..100, :unless => :using_openid?
  validates_uniqueness_of   :login,                       :case_sensitive => false
  before_save :encrypt_password

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def change_password(password)
    self.password = self.password_confirmation = password
    save!
  end

  def self.create_from_openid!(identity_url, registration)
    user = User.new
    user.login = identity_url
    user.email = registration["email"]
    user.fullname = registration["fullname"]
    user.using_openid = true
    user.save!
    return user
  end

  def self.find_by_openid(identity_url)
    self.find(:first, :conditions => {:login => identity_url, :using_openid => true})
  end

  def label
    return(self.fullname || self.login || URI.parse(login).host)
  end

  # Return nil or the MyEvent instance for the this user and the given Event (instance or ID).
  def my_event_for(event)
    event_id = event.kind_of?(Event) ? event.id : event
    return self.my_events.find_by_event_id(event_id)
  end

  # Return data structure that's a hash of MyEvent statuses to arrays of events this user listed as interesting. E.g.,
  #
  #   {
  #     "yes" => [<Event1>, <Event2>, ...],
  #     "no"  => [<Event3>, ...],
  #     ...
  #   }
  def my_events_by_status(opts={})
    # TODO reuse code from find_by_dates to find current events
    # TODO consider making use of named scopes
    result = {}
    my_filtered_events = \
      if opts[:current]
        self.my_events.find(:all, :include => :event, :conditions => ['events.start_time >= ?', Time.now.utc])
      else
        my_events
      end
    my_filtered_events.each do |my_event|
      result[my_event.status] ||= []
      result[my_event.status] << my_event.event
    end
    result.each_pair do |status, events|
      result[status] = events.sort_by{|event| event.start_time}
    end
    return result
  end

  # Is the user interested in this event?
  def interested_in?(event)
    event_id = event.kind_of?(Event) ? event.id : event
    return self.my_events.count(:conditions => ['event_id = ? and status in (?)', event_id, MyEvent::INTERESTING_STATUSES]) > 0
  end

protected

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    !using_openid? && (crypted_password.blank? || !password.blank?)
  end

end
