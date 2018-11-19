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
            
            #they can update officers in their unit
            can :update, Officer do |o|
                officers_in_unit = user.officer.unit.officers.map{|o| o.id}
                officers_in_unit.include? o.id
            end
        
        end
            
            
            
            
            
                
                
    
    end
    
    
end
