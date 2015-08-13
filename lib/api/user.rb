class Api::User < Api::Base
  attribute :email, String

  def self.from_token(access_token)
    new load_resource(access_token, 'api/v2/users/whoami.json').merge(access_token: access_token)
  end

  def tasks(reload = false)
    @tasks = nil if reload

    @tasks ||= load_resource('api/v2/tasks.json').map do |task_attrs|
      Api::Task.new task_attrs.merge(user: self)
    end
  end

  def search_tasks(title, options = {})
    load_resource('api/v2/tasks/search.json', options.merge(title: title)).map do |task_attrs|
      Api::Task.new task_attrs.merge(user: self)
    end
  end
end
