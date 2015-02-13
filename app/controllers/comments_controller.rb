class CommentsController < ApplicationController

  #http_basic_authenticate_with name: "dhh", password: "secret",only: :destroy

  def create
    @tool = Tool.find(params[:tool_id])
    @comment = @tool.comments.create(comment_params)
    redirect_to tool_path(@tool)
  end

  def destroy
    @tool = Tool.find(params[:tool_id])
    @comment = @tool.comments.find(params[:id])
    @comment.destroy
    redirect_to tool_path(@tool)
  end

  private
  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end

end
