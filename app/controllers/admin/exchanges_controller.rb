class Admin::ExchangesController < ApplicationController
  before_filter :login_required, :admin_required
  active_scaffold :exchange do |config|
    config.label = "Exchanges"
    config.actions.exclude :update
    config.list.columns = [:amount,:customer,:metadata,:worker,:created_at]
    list.columns.exclude :group
    show.columns.exclude :group
  end

  protected

  def before_create_save(record)
    @req = Req.new
    @req.name = 'admin transfer'
    @req.estimated_hours = record.amount
    @req.due_date = Time.now
    @req.person = record.customer
    @req.active = false
    @req.save!

    record.metadata = @req
  end
end
