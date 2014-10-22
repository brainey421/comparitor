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
  
  # If authenticated, display page with list of active and public studies.
  def index
    @studies = Study.where(active: true, public: true)
    @studies = @studies.reverse_each
  end
  
  # If authenticated, display page with list of active and public studies 
  # according to the search results.
  def search
    begin
      if params[:email] != "" && params[:study_name] != ""
        @header = "Studies: #{params[:study_name]} by #{params[:email]}"
        @studies = Study.where(originator: params[:email], name: params[:study_name], active: true, public: true)
      elsif params[:email] != ""
        @header = "Studies: #{params[:email]}"
        @studies = Study.where(originator: params[:email], active: true, public: true)
      elsif params[:study_name] != ""
        @header = "Studies: #{params[:study_name]}"
        @studies = Study.where(name: params[:study_name], active: true, public: true)
      else
        redirect_to(studies_path)
        return
      end
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
      s.public = false
      s.n_way = 2
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
  
  # If authenticated, and if study belongs to user, and if study has enough items,
  # activate study.
  def activate
    begin
      study = Study.find(params[:study_id])
      
      if study.user_id != session[:user_id]
        return
      end
      
      n = params[:n_way].to_i
      if n != 2 && n != 3
        return 
      end
      
      if Item.where(study_id: params[:study_id]).size < n
        flash[:error] = "A #{n}-way comparison study must have at least #{n} items before activation."
        return
      end
      
      study.n_way = n
      study.active = true
      study.save
    rescue
      
    ensure
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, and if study belongs to user, and if study is active, 
  # make study public.
  def publicize
    begin
      study = Study.find(params[:study_id])
      
      if study.user_id == session[:user_id] && study.active
        study.public = true
        study.save
      end
    rescue
      
    ensure
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, and if study belongs to user, and if study is active, 
  # hide study.
  def hide
    begin
      study = Study.find(params[:study_id])
      
      if study.user_id == session[:user_id] && study.active
        study.public = false
        study.save
      end
    rescue
      
    ensure
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, and if study belongs to user, 
  # destroy study, its items, and its comparisons.
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
        
        items = sparql.query("SELECT ?name ?description ?link ?image
        WHERE {
        ?name <http://purl.org/dc/terms/subject> <http://dbpedia.org/resource/Category:#{category}> .
        ?name <http://www.w3.org/2000/01/rdf-schema#comment> ?description . 
        ?name <http://xmlns.com/foaf/0.1/isPrimaryTopicOf> ?link .
        ?name <http://xmlns.com/foaf/0.1/depiction> ?image .
        FILTER (LANG(?description) = 'en')
        }")
        
        unless items.size < 1
          items.each do |item|
            description = item[:description].to_s
            link = item[:link].to_s
            image = item[:image].to_s
    
            name = link.split("\n").grep(/http:\/\/en.wikipedia.org\/wiki\/(.*)/){$1}[0]
            name = name.gsub '_', ' '
            
            i = Item.new
            i.study_id = params[:study_id]
            i.name = name
            i.description = description
            i.link = link
            i.image = image
            i.save
          end
        end
        
        items = sparql.query("SELECT ?name ?description ?link ?image
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
            
            unless Item.where(name: name).size > 0
              i = Item.new
              i.study_id = params[:study_id]
              i.name = name
              i.description = description
              i.link = link
              i.save
            end
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
  
  # If authenticated, if study belongs to user, and if study is active, 
  # export the item data from the study in CSV format.
  def export_items
    begin
      study = Study.find(params[:study_id])
      
      if study.user_id == session[:user_id] && study.active
        headers['Content-Disposition'] = "attachment; filename=\"#{Study.find(params[:study_id]).name}_items\""
        headers['Content-Type'] ||= 'text/csv'
        @headers = ['Item ID', 'Item']
        
        @items = Item.where(study_id: params[:study_id])
      else
        redirect_to(manage_study_path)
      end
    rescue
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, if study belongs to user, and if study is active, 
  # export the comparison data from the study in CSV format.
  def export_comparisons
    begin
      study = Study.find(params[:study_id])
      
      if study.user_id == session[:user_id] && study.active
        headers['Content-Disposition'] = "attachment; filename=\"#{Study.find(params[:study_id]).name}_comparisons\""
        headers['Content-Type'] ||= 'text/csv'
        @headers = ['User', 'Time', 'Item ID 1', 'Rank 1', 'Item ID 2', 'Rank 2']
        
        rawcomparisons = Comparison.where(study_id: params[:study_id])
        @comparisons = []
        salt = SecureRandom.hex(24)
    
        rawcomparisons.each do |rawcomparison|
          ranks = Rank.where(comparison_id: rawcomparison.id)
          if ranks.size >= 2 && Item.find(ranks[0].item_id) && Item.find(ranks[1].item_id)
            first = 0
            last = 1
            if ranks[0].rank > ranks[1].rank
              first = 1
              last = 0
            end
            @comparisons << [(rawcomparison.user_id.to_s + salt).hash,
                              rawcomparison.time,
                              Item.find(ranks[first].item_id).id,
                              ranks[first].rank,
                              Item.find(ranks[last].item_id).id,
                              ranks[last].rank]
          end
        end
      else
        redirect_to(manage_study_path)
      end
    rescue
      redirect_to(manage_study_path)
    end
  end
  
  # If authenticated, if study belongs to user, and if study is active, 
  # export the comparison and item data from the study in CSV format.
  def export_both
    begin
      study = Study.find(params[:study_id])
      
      if study.user_id == session[:user_id] && study.active
        headers['Content-Disposition'] = "attachment; filename=\"#{Study.find(params[:study_id]).name}_comparisons_and_items\""
        headers['Content-Type'] ||= 'text/csv'
        @headers = ['User', 'Time', 'Item 1', 'Rank 1', 'Item 2', 'Rank 2']
        
        rawcomparisons = Comparison.where(study_id: params[:study_id])
        @comparisons = []
        salt = SecureRandom.hex(24)
    
        rawcomparisons.each do |rawcomparison|
          ranks = Rank.where(comparison_id: rawcomparison.id)
          if ranks.size >= 2 && Item.find(ranks[0].item_id) && Item.find(ranks[1].item_id)
            first = 0
            last = 1
            if ranks[0].rank > ranks[1].rank
              first = 1
              last = 0
            end
            @comparisons << [(rawcomparison.user_id.to_s + salt).hash,
                              rawcomparison.time,
                              Item.find(ranks[first].item_id).name,
                              ranks[first].rank,
                              Item.find(ranks[last].item_id).name,
                              ranks[last].rank]
          end
        end
      else
        redirect_to(manage_study_path)
      end
    rescue
      redirect_to(manage_study_path)
    end
  end
end