class CriminalsController < ApplicationController
    before_action :set_criminal, only: [:show, :edit, :update, :destroy]
    # before_action :check_login
    
    def index
        @all_criminals = Criminal.alphabetical.paginate(page: params[:crim_page]).per_page(10)
        @convicted_felon = Criminal.prior_record.alphabetical.paginate(page: params[:pr_page]).per_page(10)
        @enhanced_criminals = Criminal.enhanced.alphabetical.paginate(page: params[:e_crim_page]).per_page(10)
    end
    
    def show
        @current_suspect_in = @criminal.investigations.alphabetical
    end
    
    def new
        @criminal = Criminal.new
    end
    
    def edit
    end
    
    def create
        @criminal = Criminal.new(criminal_params)
        if @criminal.save
            flash[:notice] = "Successfully created #{@criminal.proper_name}."
            redirect_to criminal_path(@criminal)
        else
            render action: 'new'
        end
    end
    
    def update
        respond_to do |format|
            if @criminal.update_attributes(criminal_params)
                format.html { redirect_to @criminal, notice: "Updated #{criminal.proper_name}." }
            else
                format.html { render :action => "edit" }
            end
        end
    end
    
    def search
        if params[:query].blank?
          redirect_back(fallback_location: @criminals) 
        end
        @query = params[:query]
        @criminals = Criminal.search(@query)
        @total_hits = @criminals.size
        if @total_hits == 0
          flash[:error] = "There are no criminals found with the term #{@query}."
          redirect_back(fallback_location: @criminals) 
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_criminal
        @criminal = Criminal.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def criminal_params
        params.require(:criminal).permit(:first_name, :last_name, :aka, :convicted_felon, :enhanced_powers, :notes)
    end

    
end