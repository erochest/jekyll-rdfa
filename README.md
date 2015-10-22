# jekyll-rdfa

This scans all the posts in a Jekyll site for [RDFa][rdfa]-encoded
data. It gathers all of these into one graph and outputs it as
[Turtle][ttl] in `posts.ttl` and as [JSON-LD][json-ld] in
`posts.json`.

## Installation

You can install and use this the way you do with Ruby gems/Jekyll
plugins:

```bash
gem install jekyll-rdfa
```

Also see the [Jekyll page on Plugins][plugins] for more information on
how to apply this to your site.

## YAML Metadata

`jekyll-rdfa` also pays attention to a number of keys in the
[YAML][yaml] post [frontmatter][frontmatter].

`vocab`
A default vocabulary URI for the page.

`resource`
The URI for the topic of the page.

`typeof`
The URI [rdf:type][rdf_type] of the topic of the page.

`prefix`
A YAML hash mapping prefixes to URIs that you will use in the page.

For example, here are some fields from a YAML frontmatter:

```yaml
vocab: http://bibframe.org/vocab/
resource: http://dbpedia.org/c/8CCRUT
typeof: Person
prefix:
  purdom: http://purdom.org/reading#
  err:    http://www.ericrochester.com/reading#
```

rdfa: http://rdfa.info/ RDFa
ttl: http://www.w3.org/TR/turtle/ Turtle
json-ld: http://json-ld.org/ JSON-LD
plugins: https://jekyllrb.com/docs/plugins/
frontmatter: http://jekyllrb.com/docs/frontmatter/
yaml: http://yaml.org/
rdf_type: http://www.w3.org/TR/rdf-schema/#ch_type
