# UserPolicy
# frozen_string_literal: true
class ReviewPolicy < ApplicationPolicy

  def new?
    user.customer?
  end

  def create?
    user.customer?
  end

  def edit?
    (user.customer? && user.id == record.user.id)
  end

  def update?
    (user.customer? && user.id == record.user.id)
  end

  def destroy
    (user.customer? && user.id == record.user.id)
  end

  def index
    user.customer? || user.manager? || user.sales_person?
  end
end
