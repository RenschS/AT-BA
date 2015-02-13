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

    iphone =  @analytic.iphone_key
    ipad =  @analytic.ipad_key
    android =  @analytic.ipad_key


    options = {
        "flurry_iphone_api_key"  => iphone,
        "flurry_ipad_api_key"    => ipad,
        "flurry_android_api_key" => android
      }

    @para = MegFlurryAnalytics.new(options)

    analyticparameter = {:title => @analytic.title,
                      :date1 => @analytic.date1,
                      :date2 => @analytic.date2,
                      :android_key => @analytic.android_key,
                      :iphone_key => @analytic.iphone_key,
                      :ipad_key => @analytic.ipad_key,
                      :iPhoneUser=> @para.iphone_data,
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

    params.require(:analytic).permit(analyticparameter)
  end

  def withAnalyticparams(analyticpara)


  end



end
