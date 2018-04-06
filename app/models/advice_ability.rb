class AdviceAbility
  include CanCan::Ability

  def initialize(user)
    if user.present? && user.is_admin?
      can :manage, Advice
      can :manage, :admin_advices
    end
  end

end