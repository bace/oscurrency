Rails.configuration.to_prepare do
  unless Rails.env.test?
    begin
      if ActiveRecord::Base.connection.data_source_exists?('preferences')
        global_prefs = Preference.first
        if global_prefs&.using_email?
          ActionMailer::Base.delivery_method = :smtp
          smtp_port = ENV['SMTP_PORT'] ? ENV['SMTP_PORT'].to_i : 587
          starttls_auto = 587==smtp_port ? true : false
          ActionMailer::Base.smtp_settings = {
            :address        => ENV['SMTP_SERVER'] || 'smtp.sendgrid.net',
            :port           => smtp_port,
            :authentication => :plain,
            :enable_starttls_auto => starttls_auto,
            :user_name      => ENV['SMTP_USER'] || ENV['SENDGRID_USERNAME'],
            :password       => ENV['SMTP_PASSWORD'] || ENV['SENDGRID_PASSWORD'],
            :domain         => ENV['SMTP_DOMAIN'] || 'herokuapp.com'
          }
          ActionMailer::Base.default_url_options[:host] = global_prefs.server_name
        end
      end
    rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad => e
      Rails.logger.info "Skipping email settings initializer database query: #{e.message}"
    end
  end
end
