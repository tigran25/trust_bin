class SnippetsController < ApplicationController
  def index
    if params[:show].blank?
      @pagy, @snippets = pagy(Snippet.active.org.newest.root.all)
    else
      @pagy, @snippets = pagy(Snippet.active.newest.root)
    end
  end

  def show
      if params[:version].present?
        @snippet = Snippet.find_by(uuid: params[:uuid])
      else
        @snippet = Snippet.where("uuid = ? OR parent_uuid = ?", params[:uuid], params[:uuid]).order(version: :desc).first
      end    
      @pagy, @versions = pagy(Snippet.active.where("parent_uuid = ?", @snippet.parent_uuid).order(version: :desc))
  end

  def raw
    @snippet = Snippet.find_by(uuid: params[:snippet_uuid])

    render layout: false
  end

  def new
    @snippet = Snippet.new
  end

  def edit
    snippet = Snippet.active.find_by(uuid: params[:uuid])
    @snippet = Snippet.new(
      name: snippet.name,
      content: snippet.content,
      parent_uuid: snippet.parent_uuid,
      version: snippet.version + 1,
      description: snippet.description,
      language: snippet.language,
      visibility: snippet.visibility
    )
    render :new
  end

  def fork
    snippet = Snippet.active.find_by(uuid: params[:snippet_uuid])
    @snippet = Snippet.new(
      name: "#{snippet.name} [FORK]",
      content: snippet.content,
      version: 1,
      description: '',
      language: snippet.language,
      visibility: snippet.visibility
    )

    render :new
  end

  def create
    @snippet = Snippet.new(snippet_params)
    @snippet.user_id = current_user.id
    uuid = SecureRandom.uuid
    @snippet.uuid = uuid
    @snippet.parent_uuid = uuid if params[:snippet][:parent_uuid].blank?
    if @snippet.save
      flash[:success] = "Snippet successfully created"
      redirect_to snippet_path(uuid: @snippet.uuid)
    else
      render :new
    end
  end

  def destroy
    snippets = Snippet.where(parent_uuid: params[:uuid])
    snippets.update_all(deleted_at: Time.now)

    flash[:success] = "Snippet successfully deleted"
    redirect_to snippets_path
  end

  private

  def snippet_params
    params.require(:snippet).permit(
      :name,
      :description,
      :language,
      :content,
      :parent_uuid,
      :version,
      :visibility
    )
  end
end
