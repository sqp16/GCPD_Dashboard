class HomeController < ApplicationController
  before_action :check_login

  def index
    @my_notes = @current_user.officer.investigation_notes.paginate(page: params[:my_notes_page]).per_page(10)
    @units = Unit.alphabetical.active.paginate(page: params[:page]).per_page(5)
    @officers = Officer.alphabetical.active.paginate(page: params[:page]).per_page(5)
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
