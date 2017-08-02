class Authors::CategoriesController < AuthorController

  def create
    @category = Category.where(category_params).first_or_create
    respond_to do |format|
      if @category.save
        format.json { render json: @category }
        format.html { redirect_to blog_categories_path, notice: 'Category was successfully created' }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @category = Category.new
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end
end
