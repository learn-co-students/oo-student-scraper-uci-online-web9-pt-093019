require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []

    index_page.css(".roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        name = student.css(".student-name").text
        location = student.css(".student-location").text
        link = student.attributes["href"].value
        student_hash = {
          :name => name,
          :location => location,
          :profile_url => link
        }

        students << student_hash
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student_hash = {}
    profile_page.css(".profile").each do |profile|
      profile.css(".social-icon-container a").each do |social|
        link = social.attributes["href"].value
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
        student_hash[:profile_quote] = profile.css(".vitals-text-container .profile-quote").text
        student_hash[:bio] = profile.css(".description-holder p").text
    end
    student_hash
  end

end
