require 'rake'
require 'erb'

desc "install the managed files"
task :install do
  # we rely on /c being "C:"
  unless File.exist?('/c')
    system "ln -s /cygdrive/c /c"
  end

  # HOME should end with "/Documents", otherwise you
  # haven't set up Cygwin in the way we expect. This may not
  # work properly if so.
  unless ENV['HOME'] =~ /Documents$/
    raise "Expecting $HOME to end with 'Documents'. See http://swiki.zoo.lan/display/training/Cygwin"
  end

  # we only link directories, e.g. "c", "home" -- all files in
  # the root of the repos are ignored
  Dir.glob('*') do |dir|
    if File.directory?(dir)
      puts "installing files in '#{dir}'"
      real_base = (dir == 'home' ? ENV['HOME'] : "/#{dir}")
      replace_all = false
      Dir.chdir dir do
        Dir.glob('**/.*') do |file|
          next if file =~ /(\/|^)\.\.?$/ # file is "." or ".."

          real_file = "#{real_base}/#{file}"
          if File.exist?(real_file)
            if File.identical? file, real_file
              puts "already linked: #{file} <-> #{real_file}"
              next
            elsif same_contents? file, real_file
              puts "already identical contents, converting to hardlink: #{file} <-> #{real_file}"
              replace_file(file, real_file)
            elsif replace_all
              replace_file(file, real_file)
            else
              print "overwrite #{real_file} with link to #{file}? [ynaq] "
              case $stdin.gets.chomp
              when 'a'
                replace_all = true
                replace_file(file, real_file)
              when 'y'
                replace_file(file, real_file)
              when 'q'
                exit
              else
                puts "skipping #{real_file}"
              end
            end
          else
            link_file(file, real_file)
          end
        end
      end
    end
  end
end

def same_contents?(file1, file2)
  system %Q{diff -q "#{file1}" "#{file2}"}
end

def replace_file(file, real_file)
  puts "deleting #{real_file}"
  system %Q{rm -f "#{real_file}"}
  link_file(file, real_file)
end

def link_file(file, real_file)
  puts "hard linking #{file} <-> #{real_file}"
  syscall %Q{ln "#{file}" "#{real_file}"}
end

def syscall cmd
  puts cmd
  system cmd or raise "system call failed"
end

