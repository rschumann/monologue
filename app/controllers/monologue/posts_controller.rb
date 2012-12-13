class Monologue::PostsController < Monologue::ApplicationController
  caches_page :index, :show, :feed , :if => Proc.new { monologue_page_cache_enabled? }
  
  layout :choose_layout

  def index
    @page = params[:page].nil? ? 1 : params[:page]
    @posts = Monologue::Post.published.page(@page)
  end
  
  def blank_index
    @posts = Monologue::Post.published.limit(5)
  end

  def show
    if current_user
      post = Monologue::Post.default.where("monologue_posts_revisions.url = :url", {:url => params[:post_url]}).first
    else
      post = Monologue::Post.published.where("monologue_posts_revisions.url = :url", {:url => params[:post_url]}).first
    end
    if post.nil?
      not_found
      return
    end
    @revision = post.active_revision
  end

  def feed
    @posts = Monologue::Post.published.limit(25)
  end
  
  def choose_layout
    current_uri = request.env['PATH_INFO']
    if current_uri.include?('jevvel-home')
      return 'monologue/blank'
    else
      return 'monologue/application'
    end
  end
end