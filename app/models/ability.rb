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
        
        elsif user.role? :officer
            can :read, Investigation
            can :new, Investigation
            can :create, Investigation
            
            #can update investigations that the officer is assigned to
            can :update, Investigation do |i|
                curr_assigned_invest = user.officer.investigations.is_open.map{|a| a.id}
                curr_assigned_invest.include? i.id
            end
            
            can :manage, InvestigationNote
            can :read, Assignment
            can :read, Crime
            can :manage, CrimeInvestigation
            can :manage, Criminal
            can :manage, Suspect
            
            #can manage officer info 
            can :manage, Officer do |o|
                o.id == user.officer.id
            end
            
            #can manage own user info
            can :manage, User do |u|
                u.id == user.id
            end
            
            can :index, Unit
            
            can :show, Unit do |u|
                u.id == user.officer.unit.id
            end
            
        end
            
            
                
                
    
    end
    
    
end
