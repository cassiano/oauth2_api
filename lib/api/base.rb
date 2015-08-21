class Api::Base
  include Virtus.model

  attribute :access_token, OAuth2::AccessToken
  attribute :links, Array

  def self.load_resource(access_token, uri, params, klass, additional_attrs = {})
    result = access_token.get(uri, params: params).parsed

    case result
      when Hash   then klass.new(result.merge(additional_attrs))
      when Array  then result.map { |attrs| klass.new(attrs.merge(additional_attrs)) }
    end
  end

  def follow_link(link_name, params, klass, additional_attrs = {})
    self.class.load_resource access_token, link(link_name), params, klass, additional_attrs
  end

  def link(name)
    links && (link = links.find { |link| link['rel'] == name.to_s }) && link['href']
  end
end
