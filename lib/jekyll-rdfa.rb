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

      graph = RDF::Graph.new

      count = 0
      site.docs_to_write.each do |document|
        html = Jekyll::Renderer.new(site, document, site.site_payload).run
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
