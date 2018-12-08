class AssignmentsController < ApplicationController
  before_action :check_login

  def new
    @assignment = Assignment.new
    @active_officers = Officer.active.alphabetical.map{|o| o}
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
      flash[:notice] = "Successfully assigned '#{@assignment.officer.proper_name}' to '#{@assignment.investigation.title}'."
      redirect_to officer_path(@assignment.officer)
    else
      @officer = Officer.find(params[:assignment][:officer_id])
      render action: 'new', locals: { officer: @officer }
    end
  end

  def terminate
    @assignment = Assignment.find(params[:id])
    @assignment.end_date = Date.current
    @assignment.save
    flash[:notice] = "'#{@assignment.officer.proper_name}' is no longer assignmed to '#{@assignment.investigation.title}'."
  end

  private
    def assignment_params
      params.require(:assignment).permit(:investigation_id, :officer_id, :start_date, :end_date)
    end
end
