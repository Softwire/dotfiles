# we rely on /c being "C:"
unless File.exist?('/c')
  system "ln -s /cygdrive/c /c"
end

def install
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
	  file = "#{Dir.pwd}/#{file}"
        if File.exist?(real_file)
            if File.identical? file, real_file
              puts "already linked: #{file} <-> #{real_file}"
              next
            elsif same_contents? file, real_file
              puts "already identical contents, converting to symlink: #{real_file} -> #{file}"
              replace_file_with_link(file, real_file)
            elsif replace_all
              replace_file_with_link(file, real_file)
            else
              print "overwrite #{real_file} with link to #{file}? [ynaq] "
              case $stdin.gets.chomp
              when 'a'
                replace_all = true
                replace_file_with_link(file, real_file)
              when 'y'
                replace_file_with_link(file, real_file)
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

def replace_file_with_link(file, real_file)
  puts "deleting #{real_file}"
  system %Q{rm -f "#{real_file}"}
  link_file(file, real_file)
end

def link_file(file, real_file)
  puts "sym linking #{real_file} -> #{file}"
  syscall %Q{ln -s "#{file}" "#{real_file}"}
end

def syscall cmd
  puts cmd
  system cmd or raise "system call failed"
end

install()
