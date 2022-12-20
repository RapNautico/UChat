class CommentsController < ApplicationController
    before_action :set_comment, only: %i[ show edit update destroy ]
    before_action :auth_user

    def index
        @comments = Comment.where("user_id = #{current_user.id}").page params[:page]
        @publish = Publish.where("id = #{@comments.first.id}").page params[:page]
    end

    def show
        @publicacion = Publish.where("id = #{@comment.id}").page params[:page]
        @publish = Publish.where("id = #{@comment.id}").page params[:page]
    end

    def new
        @publicacion = Publish.where("id = #{params[:format]}")
        @comment = Comment.new
    end

    def edit
    end

    def create
        @comment = Comment.new(comment_params)
        @comment.publish_id = comment_params[:publish_id]
        @comment.user_id = current_user.id
        respond_to do |format|
          if @comment.save
            format.html { redirect_to comment_url(@comment), notice: "Comment was successfully create" }
            format.json { render :show, status: :created, location: @comment }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        end
    end

    def update
        respond_to do |format|
          if @comment.update(comment_params)
            format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
            format.json { render :show, status: :ok, location: @comment }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        end
    end

    def destroy
        @comment.destroy
    
        respond_to do |format|
          format.html { redirect_to comments_url, notice: "Comment was successfully delete" }
          format.json { head :no_content }
        end
    end

    private 

    def auth_user
      if !user_signed_in?
          redirect_to root_path
          flash[:alert] = "Nedd Login"
      end
    end

    def set_comment
        @comment = Comment.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:commenter, :body, :publish_id)
    end
end
