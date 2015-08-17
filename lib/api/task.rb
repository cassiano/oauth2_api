class Api::Task < Api::Base
  attribute :id, Integer
  attribute :title, String
  attribute :due_date, DateTime
  attribute :user, Api::User
end
