class TopicsController < ApplicationController
  load_resource :forum
  authorize_resource :topic, :through => :forum
  
  before_action :login_required
  
  def index
    redirect_to forum_url(params[:forum_id])
  end

  def show
    @topic = Topic.find(params[:id])
    @group = @forum.group
    @authorized = @group.authorized_to_view_forum?(current_person)
    if @authorized
      @posts = @topic.posts.paginate(:page => params[:page], :per_page => ajax_posts_per_page)
    else
      @posts = ForumPost.where('1=0').paginate(:page => 1, :per_page => ajax_posts_per_page)
    end
    @post = ForumPost.new
    respond_to do |format|
      format.js do
        if request.xhr?
          @refresh_milliseconds = global_prefs.topic_refresh_seconds * 1000
        else
          render :action => 'reject'
        end
      end
    end
  end

  def create
    @topic = @forum.topics.build(topic_params)
    @body = "yui-skin-sam" 
    @topic.person = current_person
    @post = ForumPost.new

    respond_to do |format|
      if @topic.save
        flash[:notice] = t('success_topic_created')
        format.js
      end
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      flash[:notice] = t('success_topic_destroyed')
      format.js
    end
  end

  private
    def topic_params
      params.require(:topic).permit(:name)
    end
end
