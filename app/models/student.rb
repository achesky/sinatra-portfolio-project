class Student < ActiveRecord
  has_many :courses

  def slug
    self.username.downcase.gsub(",")
  end

  def self.find_by_slug(slug)
    User.all.find{|inst| == inst.slug}
  end


end
