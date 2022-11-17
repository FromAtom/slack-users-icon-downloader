ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"])

require 'open-uri'
require 'slack-ruby-client'

IMAGE_DIR = 'images'

Slack.configure do |config|
    config.token = ENV['SLACK_OAUTH_TOKEN']
end

client = Slack::Web::Client.new

all_members = []
client.users_list(presence: true, limit: 300) do |response|
    all_members.concat(response.members)
end

Dir.mkdir(IMAGE_DIR) if not Dir.exist?(IMAGE_DIR)

all_members.each do |member|
    next if member.is_bot
    next if member.deleted
    if member.profile.image_1024.nil?
        puts "#{member.name} さんのアイコンが見つかりませんでした。"
        next
    end

    icon_path = member.profile.image_1024
    ext = File.extname(icon_path)
    path = "./#{IMAGE_DIR}/#{member.name}#{ext}"

    URI.open(icon_path) do |file|
        open(path, "w+b") do |out|
            out.write(file.read)
        end
    end
end