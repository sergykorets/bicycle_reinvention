class Blog::CategoriesController < BlogController

  def index
    @categories = Category.search(params[:search]).paginate(:page => params[:page], :per_page => 10)
  end
end