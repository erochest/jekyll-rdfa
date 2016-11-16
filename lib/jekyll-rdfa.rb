module Jekyll
  class RdfaPage < Page
  end

  class RdfaGenerator < Generator
    priority :low
    safe true

    def generate(site)
      require 'fileutils'
      require 'pathname'
      require 'json'
      require 'json/ld'
      require 'rdf'
      require 'rdf/turtle'
      require 'rdf/rdfxml'
      require 'rdf/rdfa'

      outputs = site.config['rdfa']['outputs'] || ['_linked-data/posts.ttl',
                                                   '_linked-data/posts.json']

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

      outputs.each do |output|
        outpath = Pathname.new(output)
        dirname = outpath.dirname
        dirname.mkpath unless dirname.exist?
        self.write_graph(site, graph, outpath)
      end
    end

    def write_graph(site, graph, pathname)
      case pathname.extname
      when ".ttl"
        RDF::Turtle::Writer.open(pathname) do |writer|
          writer << graph
        end
      when ".json"
        JSON::LD::Writer.open(pathname) do |writer|
          writer << graph
        end
      when ".rdf"
        RDF::RDFXML::Writer.open(pathname) do |writer|
          writer << graph
        end
      when ".xml"
        RDF::RDFXML::Writer.open(pathname) do |writer|
          writer << graph
        end
      end

      dir, base = pathname.split
      site.static_files << Jekyll::StaticFile.new(site, dir.to_s, "", base.to_s)
    end
  end
end
