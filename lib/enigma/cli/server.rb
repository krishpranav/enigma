module Enigma
    class CLI < Thor
      check_unknown_options!
  
      namespace :server
  
      desc 'server [OPTIONS]', 'Starts Enigma server'
      method_option :port,
                    aliases: :p,
                    type: :numeric,
                    default: 9292,
                    desc: 'The port Enigma will listen on'
  
      method_option :host,
                    aliases: :h,
                    type: :string,
                    default: '127.0.0.1',
                    desc: 'The host address Enigma will bind to'
  
      def server
        Rack::Server.start config: 'config.ru', Port: options['port'], Host: options['host']
      end
    end
  end