require 'open-uri'
require 'pry'

class Scraper


  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    collection = [] #collection of each student hash
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        link = student.attributes["href"].value
        name = student.css(".student-name").text
        location = student.css(".student-location").text
        student_hash = {
          :name => name,
          :location => location,
          :profile_url => link
        }
      collection << student_hash
    end
  end
  collection
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student_hash = {}

    profile_page.css(".social-icon-container a").each do |profile|
      link = profile.attributes["href"].value
      if link.include?("twitter")
        student_hash[:twitter] = link
      elsif link.include?("linkedin")
        student_hash[:linkedin] = link
      elsif link.include?("github")
        student_hash[:github] = link
      else
        student_hash[:blog] = link
      end
    end
    student_hash[:profile_quote] = profile_page.css("div.vitals-text-container div.profile-quote").text
    student_hash[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text
    student_hash
  end


end #end of class
