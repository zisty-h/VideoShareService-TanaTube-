require "sinatra"
require 'securerandom'

UUID = SecureRandom
def video_tag_load
  json = ""
  File.open(path="./video_tag.json", mode="r") do |file|
    file.each do |text|
      json += text
    end
  end
  JSON.parse json
end
get "/" do
  send_file "./web/index.html"
end

get "/post" do
  send_file "./web/post.html"
end

post "/video" do
  title = params[:title]
  text = params[:text]
  video_byte = params[:video][:tempfile].read
  img_byte = params[:img][:tempfile].read
  puts "title: #{title}"
  video_titles = video_tag_load
  video_token = UUID.uuid_v4
  Save_file_name = "./videos/#{video_token}.mp4"
  Save_img_path = "./img/#{video_token}.img"
  video_titles[video_token] = {
    "title" => title,
    "text" => text,
    "img" => Save_img_path,
    "views" => 0,
    "comment" => {},
    "good" => 0,
    "bad" => 0
  }
  #Seve video info
  File.open(path="./video_tag.json", mode="w") do |file|
    file.puts JSON.generate video_titles
  end
  #Write video
  File.open(path=Save_file_name, mode="wb") do |file|
    file.write video_byte
  end
  #Write img
  File.open(path=Save_img_path, mode="wb") do |file|
    file.write img_byte
  end
  video_token
end

get "/watch" do
  send_file "./web/watch.html"
end

get "/video_watch" do
  video_id = params[:v]
  send_file "./videos/#{video_id}.mp4"
end

get "/getTitle" do
  video_id = params[:id]
  puts "video_id: #{video_id}"
  json = ""
  File.open(path="./video_tag.json", mode="r") do |file|
    file.each do |text|
      json += text
    end
  end
  json = JSON.parse json
  json[video_id]["views"] += 1
  File.open(path="./video_tag.json", mode="w") do |file|
    file.write JSON.generate json
  end
  puts json[video_id]
  JSON.generate json[video_id]
end

post "/video_value" do
  data = params
  video_id = data[:video_id]
  video_value = data[:value]
  puts "video_id: #{video_id}.\nvalue: #{video_value}"
  video_data = ""
  File.open(path="./video_tag.json", mode="r") do |file|
    file.each do |text|
      video_data += text
    end
  end
  video_data = JSON.parse video_data
  puts "video_data: #{video_data}"
  video_data[video_id][video_value] += 1

  File.open(path="./video_tag.json", mode="w") do |file|
    file.write JSON.generate(video_data)
  end

  JSON.generate video_data
end

post "/comments" do
  puts params
  video_id = params[:video_id]
  comment_text = params[:comment]
  user_name = params[:user]
  puts "video_id: #{video_id}\nuser: #{user_name}\ncomment: #{comment_text}"

  video_data = ""
  File.open(path="./video_tag.json", mode="r") do |file|
    file.each do |text|
      video_data += text
    end
  end
  video_data = JSON.parse video_data

  video_data[video_id]["comment"][comment_text] = user_name

  File.open(path="./video_tag.json", mode="w") do |file|
    file.write JSON.generate(video_data)
  end

  JSON.generate(video_data)
end

get "/img" do
  img_id = params[:img_id]
  send_file "./img/#{img_id}.img"
end

get "/img_list" do
  img_list = ""
  File.open(path="./video_tag.json", mode="r") do |file|
    file.each do |text|
      img_list += text
    end
  end
  img_list
end