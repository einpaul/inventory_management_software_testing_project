# UserPolicy
# frozen_string_literal: true
class OrderPolicy < ApplicationPolicy

  def new?
    user.manager?
  end

  def create?
    user.manager?
  end

  def index?
    user.manager? || user.sales_person?
  end

  def destroy?
    user.manager?
  end

  def old?
    user.manager? || user.sales_person?
  end

end
