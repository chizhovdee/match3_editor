class LevelsController < ApplicationController
  def new
  end

  def create
    result = Editor.create_level(params[:data])

    render :json => {:result => result.error ? result.error : "Новый уровень создан успешно!"}
  end

  def edit
    @editor = Editor.level_by_id(params[:id])
  end

  def update
    result = Editor.update_level(params[:id], params[:data])

    render :json => {:result => result.error ? result.error : "Yровень #{ params[:id] } обновлен успешно!"}
  end
end