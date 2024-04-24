module Enigma
    class CLI < Thor
      include Thor::Actions
  
      check_unknown_options!
  
      namespace :build
  
      desc 'build [OPTIONS]', 'Build Enigma app'
  
      method_option :force,
                    aliases: :f,
                    type: :boolean,
                    default: false,
                    desc: 'force overwrite'
  
      method_option :destination_dir,
                    aliases: :d,
                    type: :string,
                    default: Enigma::Config::BUILD_DIR,
                    desc: 'destination directory'
  
      method_option :source_dir,
                    aliases: :s,
                    type: :string,
                    default: Enigma::Config::APP_DIR,
                    desc: 'source (app) dir'
  
      method_option :static_dir,
                    aliases: :t,
                    type: :string,
                    default: Enigma::Config::STATIC_DIR,
                    desc: 'static dir'
  
      def build
        empty_directory options[:destination_dir], force: options[:force]
        generate_files
        copy_static
      end
  
    no_commands do
      def generate_files
        rack = Rack::Server.new(config: 'config.ru')
        builder = Enigma::Builder.new(rack.app)
  
        [
          '/index.html',
          Enigma.assets_code.match(/src="([^\"]*?)[?"]/)[1]
        ].each do |url|
            create_file File.join(options[:destination_dir], url),
              builder.fetch(url),
              force: options[:force]
          end
        end
  
        def copy_static
          destination_dir = options[:destination_dir]
          force = options[:force]
          static_dir = options[:static_dir]
  
          Dir.glob("./#{static_dir}/**/*").each do |file|
            if File.directory?(file)
              empty_directory File.join(destination_dir, file), force: force
            else
              copy_file File.absolute_path(file), File.join(destination_dir, file.gsub(static_dir, 'static')), force: force
            end
          end
        end
      end
    end
  end