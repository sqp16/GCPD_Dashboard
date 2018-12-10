class InvestigationsController < ApplicationController
  before_action :set_investigation, only: [:show, :edit, :update, :close, :crimes, :investigation_notes, :crime_investigations]
  before_action :check_login
  authorize_resource

  def index
    @open_investigations = Investigation.is_open.chronological.paginate(page: params[:page]).per_page(10)
    @closed_investigations = Investigation.is_closed.chronological.paginate(page: params[:page]).per_page(10)
    @closed_unsolved = Investigation.is_closed.unsolved.chronological.to_a.reverse.take(5)
    @with_batman = Investigation.with_batman.chronological.to_a.reverse.take(5)
  end

  def show
    @current_assignments = @investigation.assignments.current.by_officer
    @past_assignments = @investigation.assignments.past.by_officer
    @current_suspects = @investigation.suspects.current.alphabetical.to_a
    @previous_suspects = @investigation.suspects.alphabetical.to_a - @current_suspects
    @case_crimes = @investigation.crimes.alphabetical.to_a
    @officer = Officer.new
    @notes = @investigation.investigation_notes.chronological
  end

  def new
    @investigation = Investigation.new
  end

  def edit
  end
  
  def create 
    @investigation = Investigation.new(investigation_params)
    if @investigation.save
      redirect_to investigations_path, notice: "Successfully added '#{@investigation.title}' to GCPD."
    else
      render action: 'new'
    end
  end
  
  def investigation_notes
    @investigation_notes = @investigation.investigation_notes.to_a.map {|note| {note: note, officer: note.officer, url: officer_path(note.officer)}}
  end
  
  def crime_investigations
    @crime_investigations = CrimeInvestigation.for_investigation(@investigation.id).joins(:crime).select('crime_investigations.*, crimes.name as crime_name')
  end
  
    #New Search Function
  def search
    if params[:query].blank?
      redirect_back(fallback_location: @investigations) 
    end
    @query = params[:query]
    @investigations = Investigation.title_search(@query)
    @total_hits = @investigations.size
    if @total_hits == 0
      flash[:error] = "There are no investigations found with the term '#{@query}'."
      redirect_back(fallback_location: @investigations) 
    elsif @total_hits == 1
      flash[:notice] = "Your search '#{@query}' resulted in 1 hit in investigations."
      redirect_to @investigations[0]
    end
  end
  
  def close
    @investigation.date_closed = Date.today
    @investigation.save
    flash[:notice] = "Investigation '#{@investigation.title}' has been closed."
    redirect_to investigations_path
  end
  
  def update
    @investigation = Investigation.find(params[:id])
    respond_to do |format|
      if @investigation.update_attributes(investigation_params)
        format.html { redirect_to @investigation, notice: "Updated information for '#{@investigation.title}.' " }
        # format.json { respond_with_bip(@investigation) }
      else
        format.html { render :action => "edit" }
        # format.json { respond_with_bip(@investigation) }
      end
    end
  end













  private
  def set_investigation
    @investigation = Investigation.find(params[:id])
  end

  def investigation_params
    params.require(:investigation).permit(:title, :description, :crime_location, :date_opened, :date_closed, :solved, :batman_involved)
  end
end
