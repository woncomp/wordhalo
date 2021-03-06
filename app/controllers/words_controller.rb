class WordsController < ApplicationController
  def index
  end
  
  def show
    @word = Word.find(params[:id])
    
    @added = false
    if signed_in?
      new_word = current_user.new_words.find_by( word_id: @word.id )
      card = current_user.cards.find_by( word_id: @word.id )
      if new_word == nil && card == nil
        @added = false
      else
        @added = true
      end
    end
  end

  def new
  end

  def edit
  end
  
  def search
    word_title = params[:q]
    if word_title.length == 0
      redirect_to root_path
    else
      @word = query(word_title)
      if @word == nil || @word.version < 0
        redirect_to root_path
      else
        puts @word.inspect
        redirect_to @word
      end
    end
  end
  
  def update_content
    @word = Word.find(params[:word_id])
    @word = Word.fetch_content @word
    redirect_to @word
  end
  
  def api_get #get
    word = Word.find(params[:id])
    return head(404) if word == nil
    
    render json: word.client_format
  end
end
