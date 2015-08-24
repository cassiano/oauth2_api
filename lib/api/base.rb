class Api::Base
  include Virtus.model

  attribute :access_token, OAuth2::AccessToken
  attribute :links, Array

  def self.create(attrs)
    links = attrs[:links]

    new(attrs).tap do |object|
      if links
        links.each do |link|
          link_name = link[:rel].to_sym

          object.define_singleton_method link_name do |link_params, klass, attrs|
            follow_link link_name, link_params, klass, attrs
          end
        end
      end
    end
  end

  def self.load_resource(access_token, uri, params, klass, additional_attrs = {})
    json = access_token.get(uri, params: params).parsed

    case json
      when Hash then
        attrs = HashWithIndifferentAccess.new(json)

        klass.create attrs.merge(additional_attrs)
      when Array then
        json.map do |attrs|
          attrs = HashWithIndifferentAccess.new(attrs)

          klass.create attrs.merge(additional_attrs)
        end
    end
  end

  protected

  def follow_link(link_name, params, klass, additional_attrs = {})
    self.class.load_resource access_token, link(link_name), params, klass, additional_attrs
  end

  def link(name)
    links && (link = links.find { |link| link[:rel] == name.to_s }) && link[:href]
  end
end
