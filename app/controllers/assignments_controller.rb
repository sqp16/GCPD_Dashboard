class AssignmentsController < ApplicationController
  before_action :check_login
  authorize_resource
  
  def new
    @assignment = Assignment.new
    @active_officers = Officer.active.alphabetical.paginate(page: params[:page]).per_page(5)
    unless params[:officer_id].nil?
      @officer = Officer.find(params[:officer_id])
      @officer_investigations = @officer.assignments.current.map{|a| a.investigation }
    end
    unless params[:investigation_id].nil?
      @investigation = Investigation.find(params[:investigation_id])
      @investigation_officers = @investigation.officers.map{|o| o.id }
    end
  end
  
  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.start_date = Date.current
    if @assignment.save
      if params[:assignment][:from] == 'officer'
        flash[:notice] = "Successfully assigned '#{@assignment.officer.proper_name}' to '#{@assignment.investigation.title}'."
        redirect_to officer_path(@assignment.officer)
      elsif params[:assignment][:from] == 'investigation'
        flash[:notice] = "Successfully assigned '#{@assignment.officer.proper_name}' to '#{@assignment.investigation.title}'."
        redirect_to investigation_path(@assignment.investigation)
      else
        flash[:notice] = "Successfully assigned '#{@assignment.officer.proper_name}' to '#{@assignment.investigation.title}'."
        redirect_to investigation_path(@assignment.investigation)
      end
    else
      if params[:assignment][:from] == 'officer'
        @officer = Officer.find(params[:assignment][:officer_id])
        render action: 'new', locals: { officer: @officer }
      elsif params[:assignment][:from] == 'investigation'
        @investigation = Investigation.find(params[:assignment][:investigation_id])
        render action: 'new', locals: { investigation: @investigation }
      else
        @officer = Officer.find([:officer_id])
        @investigation = Investigation.find([:investigation_id])
        render action: 'new', locals: { investigation: @investigation, officer: @officer }
      end
    end
  end

  def terminate
    @assignment = Assignment.find(params[:id])
    @assignment.end_date = Date.current
    @assignment.save
    if params[:from] == 'officer'
      flash[:notice] = "'#{@assignment.officer.proper_name}' is no longer assignmed to '#{@assignment.investigation.title}'."
      redirect_to officer_path(@assignment.officer)
    elsif params[:from] == 'investigation'
      flash[:notice] = "'#{@assignment.officer.proper_name}' is no longer assignmed to '#{@assignment.investigation.title}'."
      redirect_to investigation_path(@assignment.investigation)
    end   
  end

  private
    def assignment_params
      params.require(:assignment).permit(:investigation_id, :officer_id, :start_date, :end_date)
    end
end
