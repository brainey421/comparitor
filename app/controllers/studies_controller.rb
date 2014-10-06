class StudiesController < ApplicationController
  before_action :authenticate
  
  # If user is not properly authenticated, 
  # e.g., if the user has no GUID, 
  # or if the GUID does not match the user ID in the session,
  # then log the user out.
  def authenticate
    begin
      if !session[:user_guid]
        redirect_to(root_path)
      elsif session[:user_guid] != User.find_by(id: session[:user_id].to_i).guid
        redirect_to(logout_user_path)
      end
    rescue
      redirect_to(logout_user_path)
    end
  end
  
  # If authenticated, display page with list of active studies.
  def index
    @studies = Study.find_each
    @studies = @studies.reverse_each
  end
  
  # If authenticated, display page with list of active studies 
  # by the specified originator.
  def originator
    begin
      @originator = params[:email]
      @studies = Study.where(originator: @originator)
      @studies = @studies.reverse_each
    rescue
      redirect_to(studies_path)
    end
  end
  
  # If authenticated, display page with list of active studies 
  # with the specified name.
  def name
    begin
      @name = params[:study_name]
      @studies = Study.where(name: @name)
      @studies = @studies.reverse_each
    rescue
      redirect_to(studies_path)
    end
  end
  
  # If authenticated, display page to manage user's studies.
  def manage
    begin
      @studies = Study.where(user_id: session[:user_id])
      @studies = @studies.reverse_each
    end
  end
  
  # If authenticated, and if study is active or belongs to the user, 
  # display items in some study.
  def show
    begin
      @study = Study.find(params[:study_id])
      @items = Item.where(study_id: params[:study_id])
      @items = @items.reverse_each
      
      if @study.active == false && @study.user_id != session[:user_id]
        redirect_to(studies_path)
      end
    rescue
      redirect_to(studies_path)
    end
  end
  
  # If authenticated, create new study.
  def new
    begin
      s = Study.new
      s.name = params[:study_name]
      s.originator = session[:user_email]
      s.user_id = session[:user_id]
      s.active = false
      s.save
    rescue
      
    ensure
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, if study belongs to user, and if study is inactive
  # display page to edit study.
  def edit
    begin
      @study = Study.find(params[:study_id])
      if @study.user_id != session[:user_id] || @study.active == true
        redirect_to(manage_study_path)
        return
      end
      
      @items = Item.where(study_id: params[:study_id])
      @items = @items.reverse_each
    rescue
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, and if study belongs to user, and if study has more than one item,
  # activate study.
  def activate
    begin
      study = Study.find(params[:study_id])
      
      if study.user_id != session[:user_id]
        return
      end
      
      if Item.where(study_id: params[:study_id]).size < 2
        flash[:error] = "Your study must have at least 2 items before activation."
        return
      end
      
      study.active = true
      study.save
    rescue
      
    ensure
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, and if study belongs to user, 
  # destroy study and items in study.
  def destroy
    begin
      study = Study.find(params[:study_id])
      items = Item.where(study_id: params[:study_id])
      comparisons = Comparison.where(study_id: params[:study_id])
      
      unless study.user_id != session[:user_id]
        items.each do |item|
          item.destroy
        end
        
        comparisons.each do |comparison|
          ranks = Rank.where(comparison_id: comparison.id)
          ranks.each do |rank|
            rank.destroy
          end
          comparison.destroy
        end
        
        study.destroy
      end 
    rescue
      
    ensure
      redirect_to(manage_study_path)
    end
  end
  
  # If authenicated, if study belongs to user, and if study is inactive, 
  # add item to study.
  def add_to
    begin
      study = Study.find(params[:study_id])
      unless study.user_id != session[:user_id] || study.active == true
        i = Item.new
        i.study_id = params[:study_id]
        i.name = params[:item_name]
        i.description = params[:item_description]
        i.save
      end
    rescue
      
    ensure
      redirect_to(edit_study_path(params[:study_id]))
    end
  end
  
  # If authenicated, if study belongs to user, and if study is inactive, 
  # import items in category to study.
  def import_to
    begin
      study = Study.find(params[:study_id])
      unless study.user_id != session[:user_id] || study.active == true
        sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
        category = params[:category_name].gsub ' ', '_'
        items = sparql.query("SELECT ?name ?description ?link
        WHERE {
        ?name <http://purl.org/dc/terms/subject> <http://dbpedia.org/resource/Category:#{category}> .
        ?name <http://www.w3.org/2000/01/rdf-schema#comment> ?description . 
        ?name <http://xmlns.com/foaf/0.1/isPrimaryTopicOf> ?link .
        FILTER (LANG(?description) = 'en')
        }")
        
        unless items.size < 1
          items.each do |item|
            description = item[:description].to_s
            link = item[:link].to_s
    
            name = link.split("\n").grep(/http:\/\/en.wikipedia.org\/wiki\/(.*)/){$1}[0]
            name = name.gsub '_', ' '
            
            i = Item.new
            i.study_id = params[:study_id]
            i.name = name
            i.description = description
            i.link = link
            i.save
          end
        end
      end
    rescue
      
    ensure
      redirect_to(edit_study_path(params[:study_id]))
    end
  end
  
  # If authenicated, if study belongs to user, and if study is inactive, 
  # remove items as long as they belong to the study.
  def remove_from
    begin
      study = Study.find(params[:study_id])
      unless study.user_id != session[:user_id] || study.active
        params[:items].each do |i|
          item = Item.find(i)
          unless item.study_id != params[:study_id].to_i
            item.destroy
          end
        end
      end
    rescue
    
    ensure
      redirect_to(edit_study_path(params[:study_id]))
    end
  end
end