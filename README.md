# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version - 2.7.2

* Databse - sqlite

* ...
# 1. Modified the Gemfile and added below contents:
		gem 'aws-sdk-s3', require: false
		gem 'ox'
		gem 'uuid', '~> 2.3', '>= 2.3.8'
		
  Ran below commands:

    bundle install  
    bundle update

# 2. Modified the index.html.erb under the photos and changed the static reference to a variable

# 3. Modified photo_controller.rb to add below lines:


	require 'rubygems'
	require 'bundler/setup'
	require 'aws-sdk-s3'
	require 'uuid'
	
	@comments = @users.comments

	s3_client = Aws::S3::Client.new(region: 'us-east-1')
    signer = Aws::S3::Presigner.new(client: s3_client)
    @photos.each do |photo|
      fname = photo.file_name
      url = signer.presigned_url(
        :get_object,
        bucket: 'photobooth-rubyonrails',
        key: fname
      )
      photo.file_name = url
    end
    
# 3. Modified the rails & rake file by adding as : #!/usr/bin/env ruby
  	
# 4. Downloaded and ran below commands as part of Amazon Active storage installation:

	rails active_storage:install
	rails generate scaffold post title:string body:string

# 5. Below contents got added in schema file after this installation:

     create_table "active_storage_attachments", force: :cascade do |t|
        t.string "name", null: false
        t.string "record_type", null: false
        t.integer "record_id", null: false
        t.integer "blob_id", null: false
        t.datetime "created_at", null: false
        t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
        t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
      end

    create_table "active_storage_blobs", force: :cascade do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.string "service_name", null: false
      t.bigint "byte_size", null: false
      t.string "checksum", null: false
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end

    create_table "active_storage_variant_records", force: :cascade do |t|
      t.integer "blob_id", null: false
      t.string "variation_digest", null: false
      t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    end
  

# 6. Configuring the credentials.yml.enc file to add credentials:

    ran below command: EDITOR="code --wait" bin/rails credentials:edit

In order to re-generate the cred file and open it rean below commands:

    rails credentials:edit #to create a new master key with credentials
    EDITOR="vim" bin/rails credentials:edit #Then run this to edit the cred file and added:
 
     aws:
      access_key_id: "XXXX"
      secret_access_key: "XXXX"
      region: "us-east-1"
      dev:
        bucket: "BUCKET-NAME-DEV"
      prod:
        bucket: "BUCKET-NAME-PROD"
	
	
To edit in Windows run Powershell. Run the following commands. 
	 $env:EDITOR="notepad"
	  rails credentials:edit

    
# 7. Added below details in storage.yaml file
    amazon_dev:
      service: S3
      access_key_id: <%= Rails.application.credentials.aws[:access_key_id] %>
      secret_access_key:
      <%= Rails.application.credentials.aws[:secret_access_key] %>
      region: <%= Rails.application.credentials.aws[:region] %>
      bucket: <%= Rails.application.credentials.aws[:dev][:bucket] %>

    amazon_prod:
      service: S3
      access_key_id: <%= Rails.application.credentials.aws[:access_key_id] %>
      secret_access_key:
      <%= Rails.application.credentials.aws[:secret_access_key] %>
      region: <%= Rails.application.credentials.aws[:region] %>
      bucket: <%= Rails.application.credentials.aws[:prod][:bucket] %>
 
# 8. Modified both production.rb and develppment .rb to add below lines:

    config.active_storage.service = :amazon_prod

    config.active_storage.service = :amazon_dev

# 9. AWS S3 Bucket creation
Logged into AWS console and created a bucket in S3 named as : photobooth-rubyonrails
Uploaded images in S3 bucket and made the images public

# 10. Docker setup in local.

 * Install Docker Desktop App in windows
 * Start the Docker 
 * Go to the directoryof the project. 
 * Create a Dockerfile there, the name should be exact 'Dockerfile'

After creating the Dockerfile on the same path where the code for Rails application is lying, created the docker image using the below command:
 docker build -t photositetry .
Check the created docker images
 docker images
 
To connect your docker image from your local to AWS S3 run the below command
 docker run -p 3000:3000 -e AWS_ACCESS_KEY_ID=<> -e AWS_SECRET_ACCESS_KEY=<> -e AWS_SESSION_TOKEN=<> -e REGISTRY_STORAGE_S3_REGION=us-east-1 -e REGISTRY_STORAGE_S3_BUCKET=photosite-on-rubyrails photositetry
 
 While building the docker image mintest error came
 To resolve that run the below commans
  gem update bundler
  bundle update


Application was up and running on:: localhost:3000/index/

Once application was up and running on local pushed the image to DockerHub from where EC2 instance could fetch the image:

  Using image id tag the image:
  
  docker images
  docker tag <IMAGE ID> shivanipathak/photositetry:<TAG NAME>
  
  Then image to the repository:
  
  docker push basudha947/photositetry


# 11. Creating EC2 instance
 Login to AWS account.
* Launch an E2 instance with the following configuration
* * Amazon Linux 2 AMI (HVM), SSD Volume Type
* * Instance type = t2.micro
* * Configure Security Group = Added one more SSH rule with 3000 port number
* * Review & Launch. Download the .pem file

# 12. Add IAM role to the EC2 Instance

To connect S3 to AWS EC2 we need to have new IAM role that gives full access to S3.
IAM-->Roles-->Create Role  with the below configuration

FilterPolicies= AmazonS3FullAccess

From AWS-Console EC2-->Instances-->Select the instance created above-->Actions-->Security-->Modify IAM Role then select Full_S3_access_from_EC2 from drop down and Save it

# 13. Connect EC2 instance, download Docker, pull Docker image from Docker Hub, and run the Rails application on an EC2 instance:
Select the EC2 instance created for the Rails application and click on Connect.

A new tab opens where the below commands are given in order to connect EC2 from the terminal: instance ID

Steps for mac:
  <instance>
  Open an SSH client.
  Locate your private key file. The key used to launch this instance is EC2-docker.pem
  Run this command, if necessary, to ensure your key is not publicly viewable.

  	chmod 400 EC2-docker.pem
  Connect to your instance using its Public DNS:

  ec2-XXXX.compute-1.amazonaws.com
  Example:

  ssh -i "EC2-docker.pem" ec2-user@XXXX.compute-1.amazonaws.com 
Created a new folder on Desktop as EC2

Moved the **EC2-docker.pem **file from Downloads to EC2 folder

Open terminal changed path to cd /Users/Basudha/Desktop/EC2

Within this path ran below commands:

  Changed the permission for EC2-docker.pem file :
  	chmod 400 EC2-docker.pem
  
  Then SSH-ed to the  above path to connect to  EC2 instance:
  	ssh -i "EC2-docker.pem" ec2-user@XXXX.us-east-2.compute-1.amazonaws.com 
	
	
Steps for Windows: We need to have putty and puttyGen installed to run this
 * Convert .pem file to .ppk file using puttyGen
 * Save the private key generated 
 * We need this key to connect to instance using putty 
 follow --> https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html



# 14. Install Docker on EC2 Instance
Once securely connected to the EC2 instance and ran the following commands to install Docker:
  // update
  sudo yum update -y
  
  // install most recent package
  sudo amazon-linux-extras install docker
  
  // start the service docker
  sudo service docker start
  
  // add the ec2-docker user to the group
  sudo usermod -a -G docker ec2-user
  
  // you need to logout to take affect
  logout
  
  // login again
  ssh -i "ec2-docker.pem" ec2-user@XXX.us-east-2.compute.amazonaws.com
  
  // check the docker version
  docker --version
  
# 14. Pull Image from Docker Hub to EC2 Instance
Once Docker gets successfully installed login and pull the Docker image from Docker Hub:

  // create password fileto  store password
  vi password
  
  //login to Docker 
  sudo docker login --username basudha947 --password-stdin < ./password
  
  //Pull the Docker image for Photosite 
  docker pull basudha947/sample:firsttry
  
  //check the image
  docker images
  
  //run the docker image
  docker run -p 3000:3000 basudha947/sample:firsttry
Once docker image is successfully running, click on the Public IPv4 address with :3000






		
