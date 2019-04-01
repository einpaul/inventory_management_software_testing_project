# UserPolicy
# frozen_string_literal: true
class UserPolicy < ApplicationPolicy

  def new?

  end

  def create?

  end

  def edit?
    user.id == record.id
  end

  def update?
    user.id == record.id
  end
end
