# Chef server

This image contains a default configuration of Chef Server 11 based on [jakubzapletal/ubuntu:14.04.1](https://github.com/jakubzapletal/docker-ubuntu/tree/14.04.1).

## Using the Docker Hub

### Ports

This image is published under [Jakub Zapletal's repository on the Docker Hub](https://hub.docker.com/u/jakubzapletal/) and all you need as a prerequisite is having Docker installed on your machine.
The container exposes the following ports:

- `443`: Chef port

Chef is running over HTTPS/443 by default.

### Volumes

There are prepared volumes `/root` and `/var/log` where logs are saved.

### Running

To start a container **with log output** you just need to run the following command:

```bash
docker run -d --privileged -e CHEF_PORT=443 -p 443:443 -v <LOCAL_PATH>:/var/log -v <LOCAL_PATH>:/root --name chef-server jakubzapletal/chef-server:11
```

To start a container **without log output** you just need to run the following command:

```bash
docker run -d --privileged -e CHEF_PORT=443 -p 443:443 --name chef-server jakubzapletal/chef-server:11
```

If you already have services running on your host that are using any of these ports, you may wish to map the container
ports to whatever you want by changing the `CHEF_PORT` variable and left side number in the `-p` parameters. Find more 
details about mapping ports in the [Docker documentation](http://docs.docker.com/userguide/dockerlinks/).

### Certificates

Once the Chef server is configured, you can download the Knife admin keys here:

```bash
wget https://IP:CHEF_PORT/knife_admin_key.tar.gz
```

Then un-tar that archive and point your knife.rb to the `admin.pem` and `chef-validator.pem` files.

### Knife.rb configuration

There is a working example of `knife.rb`:

```ruby
current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "admin"
client_key               "#{current_dir}/admin.pem"
validation_client_name   "chef-validator"
validation_key           "#{current_dir}/chef-validator.pem"
chef_server_url          "https://chef-server"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
```

## Building the image yourself

The Dockerfile and supporting configuration files are available in the Github repository. This comes specially handy if you want to change any configuration or simply if you want to know how the image was built.
