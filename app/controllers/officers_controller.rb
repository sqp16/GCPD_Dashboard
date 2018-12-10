class OfficersController < ApplicationController
  before_action :set_officer, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    @active_officers = Officer.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_officers = Officer.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    @current_assignments = @officer.assignments.current.chronological
    @past_assignments = @officer.assignments.past.chronological
  end

  def new
    @officer = Officer.new
  end

  def edit
  end

  def create
    @officer = Officer.new(officer_params)
    @user = User.new(user_params)
    unless current_user.role? (:commish)
      @user.role = "officer"
    end
    @user.active = true
    if !@user.save
      @officer.valid?
      render action: 'new'
    else 
      @officer.user_id = @user.id
      if @officer.save
        flash[:notice] = "Successfully created '#{@officer.proper_name}'."
        redirect_to officer_path(@officer) 
      else
        render action: 'new'
      end
    end
  end
  
  def destroy
    @officer = Officer.find(params[:id])
    if @officer.destroy
      flash[:notice] = "Successfully removed '#{@officer.proper_name}'."
      redirect_to officers_url
    else
      render action: 'show'
    end
  end

  def update
    respond_to do |format|
      if @officer.update_attributes(officer_params)
        format.html { redirect_to @officer, notice: "Updated '#{@officer.proper_name}'." }
      else
        format.html { render :action => "edit" }
        
      end
    end
  end
  
  #New Search Function
  def search
    if params[:query].blank?
      redirect_back(fallback_location: @officers) 
    end
    @query = params[:query]
    @officers = Officer.search(@query)
    @total_hits = @officers.size
    if @total_hits == 0
      flash[:error] = "There are no officers found with the term '#{@query}'."
      redirect_back(fallback_location: @officers) 
    elsif @total_hits == 1
      flash[:notice] = "Your search '#{@query}' resulted in 1 hit in the officers."
      redirect_to @officers[0]
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_officer
    @officer = Officer.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def officer_params
    params.require(:officer).permit(:first_name, :last_name, :rank, :ssn, :active, :unit_id)
  end
  
   def user_params      
    params.require(:officer).permit(:username, :password, :password_confirmation, :active, :role)
  end


end
