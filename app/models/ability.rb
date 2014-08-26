class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, List
    can :read, List, is_private: false
    can :read, List, is_private: true, user_id: user.id
    can :update, List, user_id: user.id
    can :destroy, List, user_id: user.id
    cannot :destroy, List do |list|
      ['Watchlist', 'Watched', 'Favorites', 'Favorite People'].include? list.name
    end
    can :toggle, List, user_id: user.id
  end
end
