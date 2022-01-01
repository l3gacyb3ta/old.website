require "ctoml-cr"
require "file_utils"
require "colorize"

# Final outs is where weput final reminders

def read_config
  raw_config = File.read("./.vangaurd.toml")
  toml = TOML.parse(raw_config)
  return toml
end

def setup
  # Setup the path
  puts "---- Seting up install environment ----".colorize(:yellow)
  puts "-- Creating folders".colorize(:green)

  FileUtils.mkdir_p "#{FileUtils.pwd}/.vangaurd/bin"
  FileUtils.mkdir_p "#{FileUtils.pwd}/.vangaurd/install"

  puts "-- Adding to $PATH".colorize(:green)
  ENV["PATH"] = "#{FileUtils.pwd}/.vangaurd/bin:#{ENV["PATH"]}"
end

def install_deps(deps, final_out)
  # Install dependencies and binaries
  puts "---- Installing dependencies ----".colorize(:yellow)
  puts "-- Installing packages".colorize(:green)
  # oh god types
  pkgs = deps["packages"].as_a
  pkgs.each do |package|
    system "sudo pacman -S #{package}"
  end

  bins = deps["binary_downloads"].as_a

  if bins != nil
    puts "-- Downloading binaries".colorize(:green)
    final_out = "\nPlease add #{FileUtils.pwd}/.vangaurd/bin to your $PATH\n".colorize(:red)
  end

  bins.each do |bin|
    bin = bin.as_a
    puts "-- Downloading #{bin[0]}".colorize(:green)
    puts "wget #{bin[0]} -O #{FileUtils.pwd}/.vangaurd/bin/#{bin[1]}"
    puts "-- Making executable #{bin[1]}".colorize(:green)
    system "chmod +x #{FileUtils.pwd}/.vangaurd/bin/#{bin[1]}"
  end

  return final_out
end

def source(sources)
  puts "---- Extracting/opening sources ----".colorize(:yellow)
  old_path = FileUtils.pwd
  FileUtils.cd sources["dir"].as_s

  return old_path
end

def build(config, final_out)
  # Build the project
  puts "---- Building project ----".colorize(:yellow)

  lines = config["build"]["main"].as_s.split("\n")
  puts "-- Building main".colorize(:green)

  lines.each do |line|
    puts line
    system line
  end

  lines = config["build"]["install"].as_s.split("\n")
  puts "-- Running install".colorize(:green)

  lines.each do |line|
    puts line
    system line
  end

  puts "-- Installing binaries".colorize(:green)

  files = Dir.glob("#{FileUtils.pwd}/.vangaurd/install/*")

  files.each do |file|
    puts "- Installing #{Path[file].stem}".colorize(:green)
    FileUtils.cp "#{file}", "#{Path.home}/.local/bin/"
  end

  return final_out
end

def reset(old_path)
  # Reset the path
  FileUtils.cd old_path
end

# Main routine
def main
  final_out = ""
  puts "---- Vangaurd, building for launch! ----".colorize(:yellow)

  # Check for a .vangaurd.toml file
  if File.exists?("./.vangaurd.toml")
    puts "-- Found .vangaurd.toml".colorize(:green)
  else
    puts "No .vangaurd.toml found, exiting.".colorize(:red)
    exit 1
  end

  config = read_config()
  puts config

  # Setup install environment
  setup

  # install dependencies
  final_out = install_deps config["dependencies"].as_h, final_out

  # go to source
  old_path = source config["source"].as_h

  final_out = build config, final_out

  reset old_path

  puts final_out
end

main
