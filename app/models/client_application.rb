require 'oauth'
class ClientApplication < ApplicationRecord
  extend PreferencesHelper

  belongs_to :person
  has_many :tokens, :class_name => "OauthToken"
  has_many :access_tokens
  has_many :oauth2_verifiers
  has_many :oauth_tokens
  validates_presence_of :name, :url, :key, :secret
  validates_uniqueness_of :key
  before_validation :generate_keys, :on => :create

  validates_format_of :url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i
  validates_format_of :support_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :allow_blank=>true
  validates_format_of :callback_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :allow_blank=>true

  attr_accessor :token_callback_url
  
  def self.find_token(token_key)
    token = OauthToken.find_by_token(token_key, :include => :client_application)
    if token && token.authorized?
      token
    else
      nil
    end
  end
  
  def self.verify_request(request, options = {}, &block)
    begin
      signature = OAuth::Signature.build(request, options, &block)
      return false unless OauthNonce.remember(signature.request.nonce, signature.request.timestamp)
      value = signature.verify
      value
    rescue OAuth::Signature::UnknownSignatureMethod => e
      false
    end
  end
  
  def oauth_server
    server_name = ClientApplication.global_prefs.server_name || ""
    @oauth_server||=OAuth::Server.new( "http://" + server_name )
  end
  
  def credentials
    @oauth_client ||= OAuth::Consumer.new(key, secret)
  end

  def create_request_token(params={}) 
    r=nil
    if params[:scope]
      if ::OauthScope.all_exist?(params[:scope])
        r = RequestToken.create(:client_application => self, 
                                :scope => params[:scope], 
                                :callback_url=>self.token_callback_url)
      end
    end
    r
  end
 
  def as_json
    {:client_id => key, :client_secret => secret, :redirect_url => callback_url, :issued_at => created_at}.as_json
  end

protected
  def generate_keys
    self.key = OAuth::Helper.generate_key(40)[0,40]
    self.secret = OAuth::Helper.generate_key(40)[0,40]
  end
end
