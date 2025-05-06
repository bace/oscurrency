Rails.configuration.to_prepare do
  unless Rails.env.test?
    begin
      if ActiveRecord::Base.connection.data_source_exists?('preferences')
        global_prefs = Preference.first
        Geokit::Geocoders::GoogleGeocoder.api_key = global_prefs&.googlemap_api_key
      end
    rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad => e
      Rails.logger.info "Skipping geokit initializer database query: #{e.message}"
    end

    # These defaults are used in GeoKit::Mappable.distance_to and in acts_as_mappable
    Geokit::default_units = :miles
    Geokit::default_formula = :sphere

    # This is the timeout value in seconds to be used for calls to the geocoder web
    # services.  For no timeout at all, comment out the setting.  The timeout unit
    # is in seconds. 
    Geokit::Geocoders::request_timeout = 3

    # This is your Google Maps geocoder key. 
    # See http://www.google.com/apis/maps/signup.html
    # and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
    #GeoKit::Geocoders::google = 'REPLACE_WITH_YOUR_GOOGLE_KEY'
        

    # This is the order in which the geocoders are called in a failover scenario
    # If you only want to use a single geocoder, put a single symbol in the array.
    # Valid symbols are :google, :yahoo, :us, and :ca.
    # Be aware that there are Terms of Use restrictions on how you can use the 
    # various geocoders.  Make sure you read up on relevant Terms of Use for each
    # geocoder you are going to use.
    Geokit::Geocoders::provider_order = [:google]
  end
end
