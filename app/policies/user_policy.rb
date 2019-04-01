# UserPolicy
# frozen_string_literal: true
class UserPolicy < ApplicationPolicy

  def new?
    user.manager?
  end

  def create?
    user.manager?
  end

  def edit?
    user.manager?
  end

  def update?
    user.manager?
  end
end
