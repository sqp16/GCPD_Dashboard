class InvestigationNotesController < ApplicationController
    before_action :check_login
    
    def new
        @investigation_note = InvestigationNote
        @investigation = Investigation.find(params[:investigation_id])
        @officer = @current_user.officer
    end 
    
    def create
        @investigation_note = InvestigationNote.new(investigation_note_params)
        if @investigation_note.save
            flash[:notice] = "Successfully added investigation note."
            redirect_to investigation_path(@investigation_note.investigation)
        else
            @investigation = Investigation.find(params[:investigation_note][:investigation_id])
            @officer = @current_user.officer
            render action: 'new', locals: { investigation: @investigation, officer: @officer }
        end
    end
    
    private
        
        def investigation_note_params
            params.require(:investigation_note).permit(:investigation_id, :officer_id, :content, :date)
        end
end

    