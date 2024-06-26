module PreferencesHelper

  # Return the global preferences.
  # The separate line for test mode lets the tests change the global prefs
  # on a test-by-test basis.  Without that line, changes to the prefs
  # don't show up because of the ||=.  Usually, this is a feature (avoiding
  # the redundant database hits is the whole point of using ||= here), but
  # in test mode it's a pain in the ass.
  def global_prefs
    return Preference.first || Preference.create() if Rails.env.test?
    @global_prefs ||= Preference.first || Preference.create()
  end
end
