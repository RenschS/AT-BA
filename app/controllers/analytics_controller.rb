class AnalyticsController < ApplicationController

  def new
    @analytic = Analytic.new
  end

  def create
    @analytic = Analytic.new(analytic_params)

    if @analytic.save

      redirect_to @analytic

    else
      render 'new'
    end
  end

  def index
    @analytic = Analytic.all
  end


  def edit
    @analytic = Analytic.find(params[:id])
  end

  def update
    @analytic = Analytic.find(params[:id])

    if @analytic.update(analytic_params)
      redirect_to @analytic
    else
      render 'edit'
    end
  end

  def show
    @analytic = Analytic.find(params[:id])

  end

  def destroy

    @analytic = Analytic.find(params[:id])
    @analytic.destroy

    redirect_to analytics_path
  end

  private
  def analytic_params
    params.require(:analytic).permit(:title, :date1, :date2, :android_key, :iphone_key, :ipad_key)
  end





end
