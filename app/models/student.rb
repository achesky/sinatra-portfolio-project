class Student < ActiveRecord::Base
  has_many :courses

  def slug
    self.username.downcase.gsub(",")
  end

  def self.find_by_slug(slug)
    Student.all.find{|inst| inst.slug == slug}
  end

  def authenticate(pw_attempt)
    pw_attempt == self.password ? self : false
  end
end
