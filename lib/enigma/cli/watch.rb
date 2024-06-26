#!/usr/bin/env/ruby

module Enigma
    class CLI < Thor
        include Thor::Actions

        check_unknown_options!

        desc 'watch [OPTIONS]', 'Watch files and build Enigma app'

        method_option :force,
            aliases: :f,
            type: :boolean,
            default: true,
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

        def watch 
            puts 'building..'
            safe_build
            puts 'done.'
            Listen.to(options[:source_dir]) do |_modified, _added, _removed|
                puts "rebuilding..."
                safe_build
                puts "done."
            end.start

            loop { sleep 1000 }
        end

        no_commands do
            def safe_build
                begin 
                    build
                rescue => e
                    puts 'build error:'
                    puts e
                end
            end
        end
    end
end