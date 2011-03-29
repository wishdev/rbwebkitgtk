=begin
extconf.rb for Ruby/GtkMozEmbed extention library
=end
require 'rubygems'
require 'mkmf-gnome2'
gems_dir = File.expand_path(Gem.dir + "/gems/")
top_dir = File.dirname(__FILE__)
top_build_dir = File.expand_path(top_dir + "/src")
package_name = "rbwebkitgtk"
package_ids = ["webkit-1.0"]


["glib2", "gtk2"].each do |package|
  Dir.entries(gems_dir).each do |entry|
    if /#{package}(-\d+\.\d+\.\d+)\z/ =~ entry
      version_suffix = $1
      $CFLAGS << ' ' + "-I #{gems_dir}/#{package}#{version_suffix}/lib"
    end
  end
end


package_id = nil
package_ids.each do |v|
  if PKGConfig.exist?(v)
    package_id = v
    $stderr.puts "#{v} is found."
    break
  else
    $stderr.puts "#{v} is not found."
  end
end

unless package_id
  $stderr.puts "No webkit is found. Abort."
  exit 1
end


#
# detect GTK+ configurations
#

PKGConfig.have_package('gtk+-2.0')
PKGConfig.have_package(package_id)

make_version_header("WEBKITGTK", package_id)

create_makefile_at_srcdir(package_name, File.expand_path(top_dir + "/src"), 
                          "-DRUBY_WEBKITGTK_COMPILATION")

create_top_makefile
