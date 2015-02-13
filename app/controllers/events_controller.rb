class EventsController < ApplicationController



  def new






  end



  def create

  end

  def index

  end


  def edit

  end

  def update

  end

  def show


  end

  def destroy


  end

  private
  def event_params
    params.require(:event).permit(:title, :date1, :date2, :android_key, :iphone_key, :ipad_key)
  end

end