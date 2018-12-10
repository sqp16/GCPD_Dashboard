class HomeController < ApplicationController
  before_action :check_login

  def index
    @my_notes = @current_user.officer.investigation_notes.paginate(page: params[:my_notes_page]).per_page(5)
    @units = Unit.alphabetical.active.paginate(page: params[:page]).per_page(5)
    @officers = Officer.alphabetical.active.paginate(page: params[:page]).per_page(5)
    @my_unit = @current_user.officer.unit
    @my_officers= @current_user.officer.unit.officers.active.alphabetical.paginate(page: params[:page]).per_page(5)
    @crimes = Crime.alphabetical.active.paginate(page: params[:page]).per_page(5)
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
  end
end
