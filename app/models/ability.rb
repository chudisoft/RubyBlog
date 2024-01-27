class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role == 'admin'
      can :manage, :all
    else
      can :read, :all
      can %i[update destroy], Post, author_id: user.id
      can %i[update destroy], Comment, user_id: user.id
    end
  end
end
