module BicyclesHelper

  def author_name(author_id)
    author = Author.find_by_id(author_id)
    if author.name.blank?
      return author.email
    else
      return author.name
    end
  end
end
