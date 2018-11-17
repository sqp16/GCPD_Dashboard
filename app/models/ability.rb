class Ability
    include CanCan::Ability
    
    def initialize(user)
        user ||= User.new
        
        #set authorizations for different user roles
        if user.role? :commish
            #can do everything
            can :manage, :all
        
        elsif user.role? :chief
            can :read, :all
            can :manage, Investigation
            can :manage, InvestigationNote
            can :manage, CrimeInvestigation
            can :manage, Criminal
            can :manage, Suspect
            can :manage, Assignment
            can :read, Unit
    
    end
    
    
end
