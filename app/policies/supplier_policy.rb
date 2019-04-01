# UserPolicy
# frozen_string_literal: true
class SupplierPolicy < ApplicationPolicy

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

  def index?
    user.manager? || user.sales_person?
  end

  def destroy?
    user.manager?
  end

  def disable?
    user.manager?
  end

  def revoke?
    user.manager?
  end

  def activate?
    user.manager? || user.sales_person?
  end
end
