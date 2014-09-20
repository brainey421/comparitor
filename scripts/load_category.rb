#! /usr/bin/env ruby

# Usage: ruby load_category.rb "Category"

require 'sparql/client'
require "mysql"

# Check for "Category" argument
if ARGV.size < 1
  puts "Usage: ruby load_category.rb \"Category\""
  exit
end

# Replace spaces in category with underscores
category = ARGV[0]
category = category.gsub ' ', '_'
puts "Loading category: " + category

# Find each item in category
puts "Finding items in category: " + category
sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
items = sparql.query("SELECT ?name ?description ?link
WHERE {
?name <http://purl.org/dc/terms/subject> <http://dbpedia.org/resource/Category:#{category}> .
?name <http://www.w3.org/2000/01/rdf-schema#comment> ?description . 
?name <http://xmlns.com/foaf/0.1/isPrimaryTopicOf> ?link .
FILTER (LANG(?description) = 'en')
}")

# Exit if no items in category
if items.size < 1
  puts "No such category: #{category}"
  exit
end

# Update database with category and items
begin
	connection = Mysql.new "localhost", "root", nil, "comparitor"
	
  category = category.gsub '_', ' '
  connection.query "INSERT INTO categories(name) VALUES('#{category}')"
  id = connection.query("SELECT id FROM categories WHERE name='#{category}'").fetch_row[0]
  puts "Category ID in database: #{id}"
  
  items.each do |item|
    description = item[:description].to_s
    link = item[:link].to_s
    
    name = link.split("\n").grep(/http:\/\/en.wikipedia.org\/wiki\/(.*)/){$1}[0]
    name = name.gsub '_', ' '
    name = name.gsub '\'', %q(\\\')
    description = description.gsub '\'', %q(\\\')
    link = link.gsub '\'', %q(\\\')
    
    connection.query "INSERT INTO items(category_id, name, description, link) VALUES('#{id}', '#{name}', '#{description}', '#{link}')"
  end
  
  puts "Category and items inserted into database!"
rescue Exception => e
  puts "MySQL exception!"
  puts e.message
  exit
ensure
  if connection
    connection.close
  end
end