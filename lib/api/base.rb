class Api::Base
  include Virtus.model

  attribute :access_token, OAuth2::AccessToken
  attribute :links, Array

  def self.load_resource(access_token, uri, params = {})
    access_token.get(uri, params: params).parsed
  end

  def load_resource(link_name, params = {})
    self.class.load_resource(access_token, link(link_name), params)
  end

  def link(name)
    links && (link = links.find { |link| link['rel'] == name.to_s }) && link['href']
  end
end
