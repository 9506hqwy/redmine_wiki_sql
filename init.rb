# frozen_string_literal: true

require 'redmine'
require 'open-uri'
require 'issue'

Redmine::Plugin.register :redmine_wiki_sql do
  name 'Redmine Wiki SQL'
  author 'Rodrigo Ramalho'
  author_url 'http://www.rodrigoramalho.com/'
  description 'Allows you to run SQL queries and have them shown on your wiki in table format'
  version '0.3.0'

  Redmine::WikiFormatting::Macros.register do
    desc "Run SQL query"
    macro :sql do |obj, args, text|
      sentence = args.join(",")
      sentence = sentence.gsub("\\(", "(")
      sentence = sentence.gsub("\\)", ")")
      sentence = sentence.gsub("\\*", "*")

      result = ActiveRecord::Base.connection.exec_query(sentence)
      thead = +'<thead><tr>'
      result.columns.each do |column|
        thead << '<th>' + column.to_s + '</th>'
      end
      thead << '</tr></thead>'

      if result.empty?
        tbody = ''
      else
        tbody = +'<tbody>'
        result.each do |row|
          tbody << '<tr>'
          result.columns.each do |column|
            tbody << '<td>' + row[column.to_s].to_s + '</td>'
          end
          tbody << '</tr>'
        end
        tbody << '</tbody>'
      end
      table = +'<table class="list issue-report">' << thead << tbody << '</table>'
      table.html_safe
    end
  end
end
