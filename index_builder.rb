module IndexBuilder
  extend self

  def rebuild!
    `cp ./.generators/index_layout ./_layouts/index.html`
    index_file = File.open('./_layouts/index.html','a')
    index_file.puts(generate_title('Instapaper'))
    index_file.puts("<ul class='unstyled'>")
    File.open('./.generators/instapaper_recent').readlines.each{|l|index_file.puts(l)}
    index_file.puts("</ul>")
    index_file.puts(generate_title('Metafilter'))
    index_file.puts("<ul class='unstyled'>")
    File.open('./.generators/mefi_recent)').readlines.each{|l|index_file.puts(l)}
    index_file.puts("</ul>")
    4.times{index_file.puts("</div>")}
    index_file.puts("</body>")
    index_file.puts("</html>")
    index_file.close
  end

  def generate_title section
    "<h3 class='sidebar'>#{section}</h3>"
  end

end
