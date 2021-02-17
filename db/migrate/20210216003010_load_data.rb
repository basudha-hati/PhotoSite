class LoadData < ActiveRecord::Migration[6.1]
  def up
    # Create initial users.
    jb = User.new(:first_name => "Justin", :last_name => "Bieber")
    jb.save(:validate => false)
    ph = User.new(:first_name => "Paris",  :last_name => "Hilton")
    ph.save(:validate => false)
    mt = User.new(:first_name => "Megan",  :last_name => "Trainor")
    mt.save(:validate => false)
    bo = User.new(:first_name => "Barack", :last_name => "Obama")
    bo.save(:validate => false)
    sc = User.new(:first_name => "Santa", :last_name => "Claus")
    sc.save(:validate => false)
    jo = User.new(:first_name => "John", :last_name => "Ousterhout")
    jo.save(:validate => false)
  end
end
