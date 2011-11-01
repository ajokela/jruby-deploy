Simple rake (and configuration file) for deploying a jruby 
project to a tomcat (or other servlet) server

=========================================

+ Put build.rake and warbler.rake into lib/tasks (for Rails)
+ Put build.yml into config (again, for Rails)

Edit config/build.yml to fit your environment.

	production:
		host: awesome-host.biz
		user: root
		tmp: /tmp
		dest: /var/lib/tomcat7/webapps/ROOT.war 
		cmd: /etc/init.d/tomcat7
		use_cmd: true

The configuration file is broken into Rails environment-based
chunks.  The configured options are as follows:

+ host:    the destination host running tomcat
+ user:    the user to connect to the host with
+ tmp:     location to upload the project war file to
+ dest:    final home for the war file
+ use_cmd: true or false - determines whether to run the start/stop command (cmd)
+ cmd:     start/stop command (with path) to tomcat

The rake/task file will give you the following:

	#> rake build:war
	#> rake build:deploy

