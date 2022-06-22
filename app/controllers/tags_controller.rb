class TagsController < ApplicationController
  def create
    @book = current_book
    @tag = @book.tags.build(tag_params)
    @tag.save
  end

  def destroy
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
