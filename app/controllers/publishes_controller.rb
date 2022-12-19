class PublishesController < ApplicationController
    before_action :set_publish, only: %i[ show edit update destroy ]
    before_action :authenticate_user!, except:[ :index, :likes_publish ]

    def index
        if !params[:search].blank?
            q = params[:search]
            @publishes = Publish.order("published_at DESC").search_content(q).page params[:page]
            if @publishes.size > 0
                @publishes
                @more_likes = Publish.more_likes
                @total_publish = Publish.all
            else
                flash.now[:alert] = "No matches found for the word: #{q}"
                @publishes = Publish.order("published_at DESC").page params[:page]
                @more_likes = Publish.more_likes
                @total_publish = Publish.all
            end
        else
            @publishes = Publish.order("published_at DESC").page params[:page]
            @more_likes = Publish.more_likes
            @total_publish = Publish.all
        end
    end

    def user_publish
        @publishes = Publish.where("user_id = #{params[:id]}").page params[:page]
    end

    def show
        @comments = Comment.where(publish_id: @publish.id).page params[:page]
    end

    def new
        @publish = Publish.new
    end

    def edit
    end

    def create
        @publish = Publish.new(publish_params)

        @publish.user_id = current_user.id
        @publish.published_at = Time.now
        respond_to do |format|
            if @publish.save
                format.html { redirect_to publish_url(@publish), notice: "Publish was successfully create."}
            else
                format.html { render :edit, status: :unprocessable_entity}
            end
        end
    end

    def update
        respond_to do |format|
            if @publish.update(publish_params)
                format.html { redirect_to publish_url(@publish), notice: "Publish was successfully update."}
            else
                format.html { render :edit, status: :unprocessable_entity}
            end
        end
    end

    def destroy
        @publish.destroy

        respond_to do |format|
            format.html { redirect_to publishes_url, notice: "Publish was successfully delete."}
        end
    end

    def likes_publish
        publish = Publish.find(params[:id])
        publish.likes = publish.counterLikes(params[:id]) if params[:format] == "likes"
        publish.dislikes = publish.counterDislikes(params[:id]) if params[:format] == "dislikes"
        publish.save(validate: false) 

        redirect_back(fallback_location: { action: "index", id: publish.id})
    end

    private

    def set_publish
        @publish = Publish.find(params[:id])
    end

    def publish_params
        params.require(:publish).permit(:title, :content, :likes, :dislikes)
    end
end
