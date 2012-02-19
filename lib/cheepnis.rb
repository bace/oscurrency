module Cheepnis

  # starts up a Heroku worker if none are active
  # Author: Mike Travers Feb 2010

  # usage: set environment variables HEROKU_USER and HEROKU_PASSWORD
  # Call Cheepnis.enqueue(obj) in place of Delayed::Job.enqueue(obj)
  # A cron job that calls Cheepnis.maybe_stop is a good idea; will terminate workers if the usual method fails .
  # (hm, should have called this DownSizer, since it kills off workers)

  # Relevant environment variables:

  # CHEEPNIS_MODE: 
  #   ON (default) -- like Delayed::Job, but will try to turn workers on and off to meet demand
  #   OFF -- acts as normal Delayed::Job (no manipulation of workers)
  #   IMMEDIATE -- tasks are performed immediately rather than being queued

  # CHEEPNIS_INDIRECT
  #   if set, use a connector object which prevents overly aggressive object serialization

  def self.enqueue(object)
    if ENV["CHEEPNIS_MODE"] == "IMMEDIATE"
      object.perform
    else

      if ENV["CHEEPNIS_INDIRECT"] != nil
        object = Connector.new(object) 
      end

      # enqueue the object in the normal way
      Delayed::Job.enqueue(object)
      if on_heroku && CHEEPNIS_MODE != "OFF"
        # start a worker if necessary
        start
        # and enqueue something that calls maybe_stop, at low priortity
        terminator = Terminator.new
        Delayed::Job.enqueue(terminator, -10)    
      end
    end
  end

  def self.on_heroku
    ENV["HEROKU_UPID"] != nil
  end

  def self.get_client
    Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
  end

  def self.start
    heroku = get_client
    info = heroku.info(ENV['APP_NAME'])
    workers = info[:workers].to_i
    if workers == 0
      heroku.set_workers(ENV['APP_NAME'], 1)
      Rails.logger.info('worker started')
    end
  end

  def self.stop
    heroku = get_client
    heroku.set_workers(ENV['APP_NAME'], 0)
    Rails.logger.info('worker stopped')
  end

  # this needs some experimentation
  def self.maybe_stop
    count = Delayed::Job.count
    if count <= 1 
      stop
    else
      # if there are actual jobs, fail so we will run again
      # won't work because jobs that fail many times get terminated
      # so just fall through and assume that a later terminator will run
      # throw "Not time to stop yet"
    end
  end

  class Terminator
    def perform
      Cheepnis.maybe_stop
    end
  end

  # This is an object whose job is to be the object of a Delayed Job task, and points to the real object that implements the perform method
  # The problem this fixes is that using ActiveRecord objects directly tends to serialize too many related objects.  
  class Connector 
    
    def self.make(object)
      self.new(object)
    end

    def initialize(object)
      @klass = object.class.name
      @id = object.id
    end

    def actual_object
      @klass.constantize.find(@id)
    end

    def perform
      actual_object.perform
    end

  end


end
