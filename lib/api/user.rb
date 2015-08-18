class Api::User < Api::Base
  attribute :id, Integer
  attribute :email, String

  def self.from_token(access_token)
    load_resource access_token, 'api/v2/users/whoami.json', {}, self, access_token: access_token
  end

  def tasks(reload = false)
    @tasks = nil if reload

    @tasks ||= load_resource(:tasks, {}, Api::Task, user: self)
  end

  def search_tasks(title, options = {})
    load_resource :search, options.merge(title: title), Api::Task, user: self
  end
end
