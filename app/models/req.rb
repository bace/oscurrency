class Req < ApplicationRecord
  include ActivityLogger
  include AnnouncementBase
  include HasPhotos

  extend PreferencesHelper

  scope :active, lambda { where("active = ? AND due_date >= ?", true, DateTime.now) }
  scope :biddable, -> { where(biddable: true) }
  scope :current, lambda { where("due_date >= ?", DateTime.now) }
  scope :without_approved_bid,
    -> {joins("LEFT JOIN bids AS approved_bids ON approved_bids.req_id = reqs.id AND approved_bids.state = 'approved'").
    where("approved_bids.id IS NULL") }

  has_many :workers, :through => :categories, :source => :people
  has_many :bids, -> { order('created_at DESC') }, :dependent => :destroy
  has_many :accepted_bids, -> { where("accepted_at IS NOT NULL") }, :class_name => "Bid"
  has_many :completed_bids, -> { where("completed_at IS NOT NULL") }, :class_name => "Bid"
  has_many :committed_bids, -> { where("committed_at IS NOT NULL") }, :class_name => "Bid"
  has_many :approved_bids, -> { where("approved_at IS NOT NULL") }, :class_name => "Bid"

  attr_accessor :ability
  attr_readonly :estimated_hours

  validates :due_date, :presence => true

  before_create :make_active, :if => :biddable
  after_create :send_req_notifications, :if => :notifications

  class << self

    def current_and_active(page=1)
      self.biddable.current.without_approved_bid.page(page).order('created_at DESC')
    end

    def all_active(page=1)
      self.biddable.page(page).order('created_at DESC')
    end

  end

  def self.searchable_columns
    [:name, :description]
  end

  def considered_active?
    active?
  end

  def deactivate
    update(active: false, biddable: false)
  end

  def has_accepted_bid?
    return bids.any? &:accepted_at if bids.loaded?
    accepted_bids.exists?
  end

  def has_completed?
    return bids.any? &:completed_at if bids.loaded?
    completed_bids.exists?
  end

  def has_commitment?
    return bids.any? &:committed_at if bids.loaded?
    committed_bids.exists?
  end

  def has_approved?
    return bids.any? &:approved_at if bids.loaded?
    approved_bids.exists?
  end

  def log_activity
    super if active?
  end

  def notifiable_workers
    workers.active.connection_notifications.uniq
  end

  def should_send_notifications?
    active and Req.global_prefs.can_send_email? and Req.global_prefs.email_notifications?
  end

  # private

  def make_active
    self.active = true
  end

  def send_req_notifications
    notifiable_workers.each do |worker|
      after_transaction { PersonMailerQueue.req_notification(self, worker) }
    end if should_send_notifications?
  end

end
