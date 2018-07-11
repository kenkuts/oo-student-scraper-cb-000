require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_index_array = []
    data = Nokogiri::HTML(open(index_url))

    data.css("div.student-card").each do |profile|
      student_index_array << {
        :name => profile.css("h4.student-name").text,
        :location => profile.css("p.student-location").text,
        :profile_url => profile.css("a").attribute("href").value
       }
    end # each
    student_index_array
  end # class method

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))

    # social_media = [:twitter, :linkedin, :github, :blog]
    social_hash = {}

    profile.css('div.social-icon-container a').each do |link|
    account = link.attribute('href').value
    # binding.pry
      case account
      when account.include?("twitter")
        social_hash[:twitter] = account
      when account.include?("github")
        social_hash[:github] = account
      when account.include?("linkedin")
        social_hash[:linkedin] = account
      else
        social_hash[:blog] = account
      end # case

    end # each

    student_hash = {
      :profile_quote => profile.css('div.profile-quote').text,
      :bio => profile.css('div.description-holder p').text
    }

    social_hash.merge!(student_hash)
    social_hash
  end # class method
end
# binding.pry
