class Authors::SuggestionsController < AuthorController
  before_action :set_bicycle, except: [:index, :suggested]
  before_action :set_suggestion, only: [:edit, :update, :destroy]

  def index
    @suggestions = current_author.suggestions
  end

  def suggested
    @suggested = Suggestion.where(bicycle_id: current_author.bicycles.map(&:id)).where(approved: nil)
  end

  def approve
    @suggestion = Suggestion.find(params[:id])
    @bicycle.name = @suggestion.name
    @bicycle.content = @suggestion.content
    @bicycle.category_id = @suggestion.category_id
    if @bicycle.save
      @suggestion.update_attributes(approved: true)
      redirect_to blog_bicycle_path(@bicycle), notice: 'Suggestion approved'
    else
      redirect_to :back, alert: 'Something went wrong'
    end
  end

  def disapprove
    @suggestion = Suggestion.find(params[:id])
    @suggestion.approved = false
    if @suggestion.save
      redirect_to :back,notice: 'Suggestion disapproved'
    else
      redirect_to :back, notice: 'Something went wrong'
    end
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  def new
    if @bicycle.suggestions.where(bicycle_id: @bicycle.id, approved: nil).exists?
      redirect_to :back, notice: 'Bicycle has already suggestion, wait until owner make some action'
    else
      @suggestion = current_author.suggestions.new(@bicycle.attributes.slice(*Suggestion.attribute_names))
    end
  end

  def edit
    if @bicycle.suggestions.where(bicycle_id: @bicycle.id, approved: nil).exists?
      redirect_to :back, notice: 'Bicycle has already suggestion, wait until owner make some action'
    end
  end

  def create
    @suggestion = current_author.suggestions.new(suggestion_params)
    @suggestion.bicycle_id = params[:bicycle_id]
    respond_to do |format|
      if @suggestion.save
        format.html { redirect_to authors_suggestions_path, notice: 'Suggestion was successfully created.' }
        format.json { render :show, status: :created, location: @suggestion }
      else
        format.html { render :new }
        format.json { render json: @suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @suggestion.update(suggestion_params)
        @suggestion.update_attributes(approved: nil)
        format.html { redirect_to authors_suggestions_path, notice: 'Suggestion was successfully updated.' }
        format.json { render :show, status: :ok, location: @suggestion }
      else
        format.html { render :edit }
        format.json { render json: @suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @suggestion.destroy
    respond_to do |format|
      format.html { redirect_to authors_suggestions_url, notice: 'Suggestion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private

  def set_bicycle
    @bicycle = Bicycle.friendly.find(params[:bicycle_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_suggestion
    @suggestion = current_author.suggestions.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def suggestion_params
    params.require(:suggestion).permit(:name, :content, :category_id)
  end
end