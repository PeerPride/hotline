# frozen_string_literal: true

# :nodoc:
class LinePolicy < ApplicationPolicy
  attr_reader :accessing_user, :target_user

  def initialize(accessing_user, target_user)
    super
    @accessing_user = accessing_user
    @target_user = target_user
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    # TODO
    true
  end

  # :nodoc:
  class Scope < Scope
    def initialize(user, scope)
      super
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
      # if user.id == 1
      #   scope.all
      # else
      #   # scope.where(1) Filter to allowable
      # end
    end

    private

    attr_reader :user, :scope
  end
end
