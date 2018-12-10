class CrimeInvestigationsController < ApplicationController
    before_action :check_login
    
    def new
        @crime_investigation = CrimeInvestigation
        @investigation = Investigation.find(params[:investigation_id])
        @crime = Crime.find(params[:crime_id])
    end 
    
    def create
        @crime_investigation = CrimeInvestigation.new(crime_investigation_params)
        if @crime_investigation.save
            flash[:notice] = "Successfully added crime to investigation."
            redirect_to investigation_path(@crime_investigation.investigation)
        else
            @investigation = Investigation.find(params[:crime_investigation][:investigation_id])
            @crime = Crime.find(params[:crime_investigation][:crime_id])
            flash[:alert] = "Failed to add crime to investigation because either crime is inactive or investigation is closed."
            redirect_to investigation_path(@investigation)
        end
    end
    
    private
        
        def crime_investigation_params
            params.require(:crime_investigation).permit(:investigation_id, :crime_id)
        end
end

    