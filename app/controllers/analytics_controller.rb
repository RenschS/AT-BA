class AnalyticsController < ApplicationController
  require './meg_flurry_analytics'

  def new
    @analytic = Analytic.new
  end

  def create
    @analytic = Analytic.new(analytic_params)
    if @analytic.nil?
      puts "Analyse konnte nicht erstellt werden"
    else
      #Funktion analyse
      @analytic = getAnalyticPara(@analytic)
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

=begin
    analyticparameter = {:title => @analytic.title,
                      :date1 => @analytic.date1,
                      :date2 => @analytic.date2,
                      :android_key => @analytic.android_key,
                      :iphone_key => @analytic.iphone_key,
                      :ipad_key => @analytic.ipad_key,
                      :iPhoneUser=> nil,
                      :iPadUser=> nil,
                      :androidUser=> nil,
                      :mwUser=> nil,
                      :iPhoneSessions=> nil,
                      :iPadSessions=> nil,
                      :androidSessions=> nil,
                      :mwSessions=> nil,
                      :iPhoneMedianSL=> nil,
                      :iPadMedianSL=> nil,
                      :androidMedianSL=> nil,
                      :iPhoneAvgActiveUsers=> nil,
                      :iPadAvgActiveUsers=> nil,
                      :androidAvgActiveUsers=> nil}
=end

    params.require(:analytic).permit(:title,:date1,:date2,:android_key,:iphone_key,:ipad_key)
  end

  def getAnalyticPara(analyticobject)
    options = {
        "flurry_iphone_api_key"  => analyticobject.iphone_key,
        "flurry_ipad_api_key"    => analyticobject.ipad_key,
        "flurry_android_api_key" =>  analyticobject.ipad_key
    }

    @para = MegFlurryAnalytics.new(options)


    analyticobject.iPhoneUser = @para.iphone(from=analyticobject.date1, to=analyticobject.date2)
    analyticobject.iPadUser = @para.ipad(from=analyticobject.date1, to=analyticobject.date2)
    analyticobject.androidUser = @para.android(from=analyticobject.date1, to=analyticobject.date2)
    analyticobject
  end


end
