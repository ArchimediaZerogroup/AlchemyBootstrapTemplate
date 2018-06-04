class ArgumentAbility
  include CanCan::Ability

  def initialize(user)
    if user.present? && user.is_admin?
      can :manage, Argument
      can :manage, :admin_arguments
    end
  end

end