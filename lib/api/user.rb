class Api::User < Api::Base
  attribute :id, Integer
  attribute :email, String

  def self.from_token(access_token)
    load_resource access_token, 'api/v2/users/whoami.json', {}, self, access_token: access_token
  end
end
