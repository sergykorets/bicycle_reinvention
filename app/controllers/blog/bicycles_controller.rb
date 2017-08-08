class Blog::BicyclesController < BlogController

  def index
    if author_signed_in? && current_author.dislikes.any?
      user_dislikes = current_author.dislikes.map(&:bicycle_id)
   	  if params[:category].present?
        @bicycles = published_bicycles.where('id NOT in (?)', user_dislikes).most_recent.where(category_id: params[:category]).search(params[:search]).paginate(:page => params[:page], :per_page => 6)
   	  else
        @bicycles = published_bicycles.where('id NOT in (?)', user_dislikes).most_recent.search(params[:search]).paginate(:page => params[:page], :per_page => 6)
      end
    else
      if params[:category].present?
        @bicycles = published_bicycles.most_recent.where(category_id: params[:category]).search(params[:search]).paginate(:page => params[:page], :per_page => 6)
      else
        @bicycles = published_bicycles.most_recent.search(params[:search]).paginate(:page => params[:page], :per_page => 6)
      end
    end
  end

  def show
    @bicycle = published_bicycles.friendly.find(params[:id])
    @comment = @bicycle.comments.build
  end

  def dislike
    authenticate_author!
    @bicycle = published_bicycles.friendly.find(params[:id])
    @dislike = Dislike.new
    @dislike.author_id = current_author.id
    @dislike.bicycle_id = @bicycle.id
    if @dislike.save
      redirect_to root_path, notice: 'You disliked this bicycle'
    else
      redirect_to :back, alert: 'You have already disliked this bicycle'
    end
  end

  private

  def published_bicycles
    Bicycle.published
  end
end