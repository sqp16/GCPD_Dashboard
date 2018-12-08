class AssignmentsController < ApplicationController
    before_action :check_login
    
    def new
        @suspect = Suspect.new
        @criminals = Criminal.alphabetical.map{|o| o}
        unless params[:criminal_id].nil?
            @criminal = Criminal.find(params[:criminal_id])
            @criminal_investigations = @criminal.investigations.is_open.map{|i| i.id}
        end
        unless params[:investigation_id].nil?
            @investigation = Investigation.find(params[:investigation_id])
            @investigation_criminals = @investigation.criminals.map{|c| c.id}
        end
    end
    
    def create
        @suspect = Suspect.new(suspect_params)
        @suspect.added_on = Date.current
        if @suspect.save
            flash[:notice] = "Successfully added '#{@suspect.criminal.proper_name}' to '#{@suspect.investigation.title}'."
            redirect_to criminal_path(@suspect.criminal)
        else
            @criminal = Criminal.find(params[:suspect][:criminal_id])
            render action: 'new', locals: { criminal: @criminal }
        end
    end
    
    def remove
        @suspect = Suspect.find(params[:id])
        @suspect.dropped_on = Date.current
        @suspect.save
        flash[:notice] = "#{@suspect.criminal.proper_name} is no longer a suspect in '#{@suspect.investigation.title}'."
    end
    
    private
        def suspect_params
            params.require(:suspect).permit(:investigation_id, :criminal_id, :added_on, :dropped_on)
        end
end

    