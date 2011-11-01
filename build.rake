require 'net/sftp'

namespace :build do

  desc "Warble the project - package into Java war file"
  task :war do
    require 'warbler'
    Warbler::Task.new
    
    Rake::Task["assets:precompile"].invoke
    Rake::Task["war"].invoke
    
  end
  
  desc "Deploy project"
  task :deploy do
    
    time_start = Time.new.to_i

    require "#{Rails.root.to_s}/config/environment"
    deploy_config = YAML.load_file("#{Rails.root.to_s}/config/build.yml")
    deploy_config = deploy_config[Rails.env]
    
    jar_name = Warbler::Config.new.jar_name
    
    %x{scp #{Rails.root.to_s}/#{jar_name}.war #{deploy_config['user']}@#{deploy_config['host']}:#{deploy_config['tmp']}/#{jar_name}.war}
    
    #Net::SFTP.start(deploy_config['host'], 'root', :password => '') do |sftp|
    #  sftp.upload!("#{Rails.root.to_s}/#{jar_name}.war", "/tmp/#{jar_name}.war")
    #end
    
    dest_dir = deploy_config['dest'].split(/\.war$/)[0]
    
    if deploy_config['use_cmd'] 
      exec = "ssh -Cx #{deploy_config['user']}@#{deploy_config['host']} '#{deploy_config['cmd']} stop && rm -rf #{dest_dir} && sleep 5 && mv #{deploy_config['tmp']}/#{jar_name}.war #{deploy_config['dest']} && #{deploy_config['cmd']} start'"
    else
      exec = "ssh -Cx #{deploy_config['user']}@#{deploy_config['host']} 'mv #{deploy_config['tmp']}/#{jar_name}.war #{deploy_config['dest']}'"
    end
    
    $stderr.puts exec
    
    system(exec)
    
    time_end = Time.new.to_i
    
    $stderr.puts "Deployment Complete: " + ((((time_end - time_start)/60.0)*100).round/100.0).to_s + " minutes..."
    
  end

end
