class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @flash_message = params[:flash_message]
    @item = Item.find_by(id: params[:id])
    @tweets = Tweet.where(item_id: params[:id])
    @comments = Comment.all
    @content_type = true
    if params[:tweet_screen] == "false"
      @content_type = false
    end
  end

  def edit
    @item = Item.find_by(id: params[:id])
    @save_path = "/items/save/" + @item.id.to_s
  end

  def save
    @item = Item.find_by(id: params[:id])
    @item.update(
      name: params[:item][:name],
      twitter_user_name: params[:item][:twitter_user_name],
      content: params[:item][:content]
    )
    redirect_to :controller => "items", :action => "index"
  end

  def create
    #redirect_to :controller => "users", :action => "register" if params[:name].empty?
    @item = Item.create(
      name: params[:name],
      twitter_user_name: params[:twitter],
      content: params[:content]
    )
    if @item
      if params[:file]
        File.binwrite("public/post_images/#{@item.id}.jpg", params[:file].read)
          @item.update(image_path: "#{@item.id}.jpg" )
        else
          @item.update(image_path: "default.jpg" )
        end
    else
      error = "もう一度やり直してください"
    end
    redirect_to :controller => "items", :action => "index"
  end

  def delete
    @item = Item.find_by(id: params[:id])
    @item.tweets.each do |tweet|
      tweet.delete
    end
    @item.delete
    redirect_to :controller => "items", :action => "index"
  end

  def sign_in_index
  end

  private
  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ""
      config.consumer_secret = ""
      config.access_token = ""
      config.access_token_secret =""
    end
  end
end
