class Grab < ActiveRecord::Base
  KEY = "bewstptmhvbxsc7xcj5wbdbu"
  MOVIE_LIST = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies"

  def self.in_theatres
    self.get_response
    self.construct_list
    self.sort_order
  end
  
  def self.get_response
    response = HTTParty.get(MOVIE_LIST+'/in_theaters.json?apikey='+KEY)
    @response = response["movies"]
  end
  
  def self.construct_list
    @list = [] # create the movie array
    
    @response.each do |movie|
     title = movie['title']
     critics_score = movie['ratings']['critics_score']
     audience_score = movie['ratings']['audience_score']
     poster_url = movie['posters']['original']
     desc = movie['critics_consensus']
     date = movie['release_dates']['theater']
     imdb = "http://www.imdb.com/title/tt"+movie['alternate_ids']['imdb']+"/combined"
     
     @list += [[critics_score,audience_score,title,poster_url,desc,date,imdb]] 
     # puts "Movie: #{title}, Score: #{score}"
    end
  end

  def self.sort_order
    @list = @list.sort_by{|critics_score| critics_score*+1}.reverse
  end


=begin
  def self.opening
    response = HTTParty.get(MOVIE_LIST+'/opening.json?apikey='+KEY)
    puts response.body
    
    #puts "I say #{response.message}, #{response.code}"
    #puts response.headers.inspect
  end
  
  def self.upcoming
    response = HTTParty.get(MOVIE_LIST+'/upcoming.json?apikey='+KEY)
    puts response.body
    
    #puts "I say #{response.message}, #{response.code}"
    #puts response.headers.inspect
  end
  
  def sort_by_rating
    # Do so here, return the hash again with highest-rated first and so-on
  end
=end

end