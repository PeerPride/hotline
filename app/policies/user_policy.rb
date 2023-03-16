# frozen_string_literal: true

# :nodoc:
class UserPolicy < ApplicationPolicy
  attr_reader :accessing_user, :target_user

  def initialize(accessing_user, target_user)
    super
    @accessing_user = accessing_user
    @target_user = target_user
  end

  def show?
    @accessing_user.id == @target_user.id
    # true
  end

  def update?
    # Simple test, only a user can update themselves
    @accessing_user.id == @target_user.id
  end

  # :nodoc:
  class Scope < Scope
    def initialize(user, scope)
      super
      @user = user
      @scope = scope
    end

    def resolve
      if user.id == 1
        scope.all
      else
        # scope.where(1) Filter to allowable
      end
    end

    private

    attr_reader :user, :scope
  end
end
