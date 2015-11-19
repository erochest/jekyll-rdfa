module Jekyll
  class RdfaPage < Page
  end

  class RdfaGenerator < Generator
    priority :low
    safe true

    def generate(site)
      require 'fileutils'
      require 'json'
      require 'json/ld'
      require 'rdf'
      require 'rdf/turtle'
      require 'rdf/rdfa'

      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      graph = RDF::Graph.new
      site.posts.docs.each do |post|
        html = converter.convert(post.content)

        attribs = {}
        attribs[:vocab] = post.data["vocab"] if post.data.member? "vocab"

        needs_typeof = false
        if post.data.member? "resource"
          attribs[:resource] = post.data["resource"]
          needs_typeof = true
        end
        if post.data.member? "about"
          attribs[:about] = post.data["about"]
          needs_typeof = true
        end
        if post.data.member? "typeof" and needs_typeof
          attribs[:typeof] = post.data["typeof"]
        end

        if post.data.member? "prefix"
          prefixes = post.data["prefix"]
                     .to_a.map { |key, value| "#{key}: #{value}" }
                     .join " "
          attribs[:prefix] = prefixes
        end

        unless attribs.empty?
          markup = attribs
                   .to_a
                   .map { |key, value| " #{key}='#{value}'"}
                   .join ""
          html = "<div#{markup}>#{html}</div>"
        end
        count = 0
        RDF::Reader.for(:rdfa).new(html) do |reader|
          reader.each_statement do |statement|
            graph << statement
            count += 1
          end
        end
      end

      dirname = "_linked-data"
      FileUtils.mkpath(dirname) unless File.exists?(dirname)

      File.open("#{dirname}/posts.ttl", 'w') do |file|
        file.write(graph.to_ttl)
      end
      site.static_files << Jekyll::StaticFile.new(
        site, "_linked-data", "", "posts.ttl"
      )
      File.open("#{dirname}/posts.json", 'w') do |file|
        file.write(graph.dump(:jsonld, standard_prefixes: true))
      end
      site.static_files << Jekyll::StaticFile.new(
        site, "_linked-data", "", "posts.json"
      )
    end
  end
end
