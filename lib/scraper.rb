require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_array = []
    web_data = Nokogiri::HTML(open("#{index_url}"))
    web_data.css(".student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      student_array << {:name => name, :location => location, :profile_url => profile_url}
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    profile_hash = {}
    web_data = Nokogiri::HTML(open(profile_url))
    web_data.css(".social-icon-container a").each do |item|
      link = item.attributes["href"].value
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      else
        profile_hash[:blog] = link
      end
    end
    profile_hash[:profile_quote] = web_data.css(".profile-quote").text
    profile_hash[:bio] = web_data.css(".description-holder p").text
    profile_hash
  end
end
