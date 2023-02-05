class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    # assigns a value 0 if the current value is nil or false
    session[:page_views] ||= 0
    # adds 1 to :page_views
    session[:page_views] += 1
    
    # if :page_views is less than 3, it will return all articles, otherwise it'll give the max pageview error message
    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
    else
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
