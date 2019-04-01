# UserPolicy
# frozen_string_literal: true
class CategoryPolicy < ApplicationPolicy

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

  def destroy?
    user.manager?
  end

  def index?
    user.manager? || user.sales_person?
  end
end
