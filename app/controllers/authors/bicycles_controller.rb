class Authors::BicyclesController < AuthorController
  before_action :set_bicycle, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  def index
    @bicycles = current_author.bicycles.most_recent
  end

  def disliked
    @bicycles = Bicycle.published.includes(:dislikes).where(dislikes: {author_id: current_author.id}).most_recent.paginate(:page => params[:page], :per_page => 10)
  end

  def like
    dislike = Dislike.find_by_author_id_and_bicycle_id(current_author.id, params[:id])
    if dislike.destroy
      redirect_to :back, notice: 'You have returned this bicycle to view'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  def show
  end

  def new
    @bicycle = current_author.bicycles.new
  end

  def edit
  end

  def publish
    @bicycle.update(published: true, published_at: Time.now)
    redirect_to authors_bicycles_url
  end

  def unpublish
    @bicycle.update(published: false, published_at: nil)
    redirect_to authors_bicycles_url
  end

  def create
    @bicycle = current_author.bicycles.new(bicycle_params)
    respond_to do |format|
      if @bicycle.save
        format.html { redirect_to authors_bicycle_path(@bicycle), notice: 'Bicycle was successfully created.' }
        format.json { render :show, status: :created, location: @bicycle }
      else
        format.html { render :new }
        format.json { render json: @bicycle.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bicycle.update(bicycle_params)
        format.html { redirect_to authors_bicycle_path(@bicycle), notice: 'Bicycle was successfully updated.' }
        format.json { render :show, status: :ok, location: @bicycle }
      else
        format.html { render :edit }
        format.json { render json: @bicycle.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bicycle.destroy
    respond_to do |format|
      format.html { redirect_to authors_bicycles_url, notice: 'Bicycle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_bicycle
    @bicycle = current_author.bicycles.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bicycle_params
    params.require(:bicycle).permit(:name, :content, :image, :category_id)
  end
end