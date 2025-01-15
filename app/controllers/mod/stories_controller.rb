class Mod::StoriesController < Mod::ModeratorController
  include StoryFinder

  before_action :find_story!
  before_action :show_title_h1

  def edit
    @title = "Edit Story"

    if @story.merged_into_story
      @story.merge_story_short_id = @story.merged_into_story.short_id
      User.update_counters @story.user_id, karma: (@story.votes.count * -2)
    end
  end

  def update
    @story.is_deleted = false
    @story.editor = @user
    @story.attributes = story_params

    if @story.save
      redirect_to @story.comments_path
    else
      render action: "edit"
    end
  end

  private

  def story_params
    params.require(:story).permit(
      :title, :url, :description, :moderation_reason,
      :merge_story_short_id, :is_unavailable, :user_is_author, :user_is_following,
      tags_a: []
    )
  end
end