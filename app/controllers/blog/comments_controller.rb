class Blog::CommentsController < BlogController
  before_action :require_login

  def create
    @bicycle = Bicycle.friendly.find(params[:bicycle_id])
    @comment = @bicycle.comments.create(comment_params)
    @comment.author_id = current_author.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to [:blog, @bicycle], notice: 'Comment was successfully created.' }
        format.js
      else
        format.html { redirect_to [:blog, @bicycle], notice: 'Fill in your comment' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if current_author.id == @comment.author_id
    respond_to do |format|
      format.html { redirect_to [:blog, @bicycle], notice: 'Comment was successfully destroyed.' }
      format.js
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:content)
  end

  def require_login
    unless current_author
      redirect_to new_author_session_path, notice: 'You must be logged in to leave comments'
    end
  end
end
