imgs = Dir.glob("img/*")
videos = Dir.glob("videos/*")
#delete
imgs.each do |path|
  File.delete("#{path}")
end

videos.each do |path|
  File.delete(path)
end

File.open(path="./imgs", mode="w") do |file|
  file.write "[]"
end

File.open(path="./video_tag.json", mode="w") do |file|
  file.write "{}"
end

print "End.\nキーを押して終了..."
gets