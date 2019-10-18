#!/usr/bin/ruby

# User needs to run the file WITH the name of the directory, i.e. './project_creator.rb test'

require 'fileutils'

class Project
  attr_accessor(:name)

  def initialize(name)
    @name = name
    create()
  end

  private
    def create
      FileUtils.mkdir_p "../#{@name}/lib"
      FileUtils.mkdir_p "../#{@name}/spec"
      FileUtils.mkdir_p "../#{@name}/views"
      FileUtils.mkdir_p "../#{@name}/public"
      gemfile = File.open("../#{@name}/Gemfile", "w")
      gemfile.puts("source 'https://rubygems.org'\n\ngem 'rspec'\ngem 'sinatra'\ngem 'pry'\ngem 'sinatra-contrib'")
      gemfile.close
      layout = File.open("../#{@name}/views/layout.erb", "w")
      layout.puts("")
      layout.close
      script = File.open("../#{@name}/app.rb", "w")
      script.puts("#!/usr/bin/ruby\n\nrequire 'sinatra'\nrequire 'sinatra/reloader'\nalso_reload('lib/**/*.rb')\n\nget(\'/\') do\n\nend")
      script.close
      loop do
        print "Would you like to create any additional classes? (y/n) "
        response = STDIN.gets.chomp.to_s
        if response == "y"
          print "Enter the name of the class you would like to create (first letter capitalized, e.g. Triangle): "
          new_class = STDIN.gets.chomp.to_s
          puts "#{new_class}"
          logic = File.open("../#{@name}/lib/#{new_class.downcase}.rb", "w")
          logic.puts("class #{new_class}\n\nend")
          logic.close
          spec = File.open("../#{@name}/spec/#{new_class.downcase}_spec.rb", "w")
          spec.puts("require('rspec')\nrequire('#{new_class.downcase}')\n\ndescribe('#{new_class}') do\nend")
          spec.close
          spec_int = File.open("../#{@name}/spec/#{new_class.downcase}_integration_spec.rb", "w")
          spec_int.puts("require('rspec')\nrequire('#{new_class.downcase}')\n\ndescribe('#{new_class}') do\nend")
          spec_int.close
        elsif response == "n"
          break
        else
          puts "That's not a valid response"
        end
      end
    end

end

project = Project.new(ARGV[0])
