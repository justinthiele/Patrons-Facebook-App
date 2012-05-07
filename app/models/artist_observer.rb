class ArtistObserver < ActiveRecord::Observer
  
  def after_create(artist)
    Notifier.welcome_new_artist(artist).deliver
  end
  
end
