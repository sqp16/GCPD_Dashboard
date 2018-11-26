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
            
            #they can update their own unit
            can :update, Unit do |u|
                u.id == user.officer.unit_id
            end
            
            #can manage officers in their unit
            can :manage, Officer do |a|
                officers_in_unit = user.officer.unit.officers.map{|o| o.id}
                officers_in_unit.include? a.id
            end
            
            #can read and update own user info
            can :manage, User do |u|
                u.id == user.id
            end
        end
            
            
            
            
            
                
                
    
    end
    
    
end
