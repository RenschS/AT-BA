class AnalyticsController < ApplicationController
  require './meg_flurry_analytics'
  attr_reader :analytic

  def new
    @analytic = Analytic.new
  end

  def create
    @analytic = Analytic.new(analytic_params)
    if @analytic.nil?
      puts "Analyse konnte nicht erstellt werden"
    else
      #Funktion analyse
      getAnalyticPara
    end

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
    params.require(:analytic).permit(:title,:date1,:date2,:android_key,:iphone_key,:ipad_key)
  end

  #führt die eigentliche Analysefunktion aus, die Daten der Drittanbieter besorgt
  def getAnalyticPara

    options = {
        "flurry_iphone_api_key"  => @analytic.iphone_key,
        "flurry_ipad_api_key"    => @analytic.ipad_key,
        "flurry_android_api_key" =>  @analytic.ipad_key
    }

    @para = MegFlurryAnalytics.new(options)

    @analytic.iPhoneUser = @para.iphone(from=@analytic.date1, to=@analytic.date2)
    @analytic.iPadUser = @para.ipad(from=@analytic.date1, to=@analytic.date2)
    @analytic.androidUser = @para.android(from=@analytic.date1, to=@analytic.date2)

  end


end
