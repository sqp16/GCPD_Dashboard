class InvestigationNotesController < ApplicationController
    # before_action :check_login
    # authorize_resource
    
    def new
        @investigation_note = InvestigationNote
        unless params[:investigation_id].nil?
            @officer = Officer.find(params[:officer_id])
            @assigned = @officer.assignments.current.map{|a| a.investigation}
            @investigation = Investigation.find(params[:investigation_id])
        else
            @officer = Officer.find(params[:officer_id])
            @investigation = Investigation.find(params[:investigation_id])
        end
    end 
    
    def create
        @investigation_note = InvestigationNote.new(investigation_note_params)
        if @investigation_note.save
            flash[:notice] = "Successfully added investigation note."
            redirect_to investigation_path(@investigation_note.investigation)
        else
            if params[:investigation_note][:from] == 'investigation'
                @investigation = Investigation.find(params[:investigation_note][:investigation_id])
                @officer = @current_user.officer
            elsif params[:investigation_note][:from] == 'dashboard'
                @officer = @current_user.officer
                @investigation = Investigation.find([:investigation_id])
                render action: 'new', locals: { investigation: @investigation, officer: @officer }
            else
                flash[:alert] = "Failed to create investigation note because you are not assigned to this investigation."
                redirect_to investigation_path(@investigation)
            end
        end
    end
    
    private
        
        def investigation_note_params
            params.require(:investigation_note).permit(:investigation_id, :officer_id, :content, :date)
        end
end

    