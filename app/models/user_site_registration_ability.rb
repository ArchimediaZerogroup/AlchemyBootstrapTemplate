class UserSiteRegistrationAbility
  include CanCan::Ability

  def initialize(user)

    if user.present? && user.is_admin?
      # can :manage, ::UserSiteRegistration
      # can :manage, :admin_user_site_registrations

      [
        [::FormNewsletter, :admin_form_newsletters],
        [::ContactForm, :admin_contact_forms]
      ].each do |objs|
        objs.each do |o|
          can :manage, o
          cannot :create, o
          cannot :update, o
        end
      end
    end
  end
end