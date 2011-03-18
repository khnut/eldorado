#!/usr/bin/env ruby

module Unicorn
  
  class Runner
    
    class << self
      
      def start
        # TODO: check if server is already running
        system "cd #{app_path} && unicorn_rails -c #{config_file} -E #{rails_env} -D"
      end

      def stop
        system "kill -s QUIT #{pid}"
      end

      def restart
        system "kill -s USR2 #{pid}"
        # TODO: send QUIT to old master, if new master is running correctly
      end

      def reload
        system "kill -s HUP #{pid}"
      end
      
      def shutdown
        system "kill -s TERM #{pid}"
      end
      
      def kill
        system "kill #{pid}"
      end
      
      def status
        system "ps axo user,pid,ppid,command | grep #{pid}"
      end

      def stop_workers
        system "kill -s WINCH #{pid}"
      end
      
      def start_worker
        system "kill -s TTIN #{pid}"
      end
      
      def stop_worker
        system "kill -s TTOU #{pid}"
      end
        
      def pid
        File.read(File.join(app_path, "tmp", "pids", "unicorn.pid"))
      rescue
        STDERR.puts "Unicorn Server is not running"
        exit(1)
      end
        
      private
      
      def app_path
        ENV['APP_PATH'] || File.expand_path(File.join(File.dirname(__FILE__), '..'))
      end
      
      def config_file
        path = ENV['CONFIG_FILE'] || File.join('config', 'unicorn.rb')
        File.expand_path(File.join(app_path, path))
      end
      
      def rails_env
        ENV['RAILS_ENV'] || 'production'
      end
      
    end
    
  end
    
end
  
begin
  Unicorn::Runner.send(ARGV[0])
rescue
  STDERR.puts "usage script/unicorn.rb [start|stop|restart|status|monitor|pid]"
  STDERR.puts "Environment variables:"
  STDERR.puts "APP_PATH (default: <script path>/..)"
  STDERR.puts "RAILS_ENV (default: production)"
  STDERR.puts "CONFIG_FILE (default: APP_PATH/config/unicorn.rb)"
  exit(1)
end