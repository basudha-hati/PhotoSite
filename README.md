# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

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


		
