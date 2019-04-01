# UserPolicy
# frozen_string_literal: true
class TransactionPolicy < ApplicationPolicy

  def new?
    user.manager? || user.sales_person?
  end

  def create?
    user.manager? || user.sales_person?
  end

  def edit?
    user.manager? || user.sales_person?
  end

  def update?
    user.manager? || user.sales_person?
  end

  def index?
    user.manager? || user.sales_person?
  end

  def destroy?
    user.manager?
  end
end
