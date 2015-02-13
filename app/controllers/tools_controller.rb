class ToolsController < ApplicationController

  #http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]

  def new
    @tool = Tool.new
  end
  
  def create
    @tool = Tool.new(tool_params)
    
    if @tool.save
      redirect_to @tool
    else
      render 'new'
    end
    
  end
  
  def index
    @tools =Tool.all
  end
  
  def edit
    @tool = Tool.find(params[:id])
  end

  def update
    @tool = Tool.find(params[:id])

    if @tool.update(tool_params)
      redirect_to @tool
    else
      render 'edit'
    end
  end
  
  def show
    @tool = Tool.find(params[:id])
    #@tool = Tool.all
  end
  
  def destroy

    @tool = Tool.find(params[:id])
    @tool.destroy

    redirect_to tools_path
  end
  
  private
    def tool_params
      params.require(:tool).permit(:title)
    end
end
