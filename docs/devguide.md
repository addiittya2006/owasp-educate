## Developer Guide to the OWASP Knowledge Base

This repository was created as a sister project to OWASP Seraphimdroid. Basically contains an Admin Portal for the Knowledge Base developed for the App as the newest plugin.

Here, on the Admin Portal there exist 2 types of Registered users and Guest users with Restricted Access:
* Admin
    An Admin has basically the Root or the Administrative privileges over all the information that exists on the Knowledge Base whether it be users, articles, categories etc.
* Writer
    A writer has basically the publishing rights for the Knowledge Base, they can go ahead and publish new articles with Tags, Categories, Pictures etc.
* Guest(Restricted Access)
    A guest has basically the viewing access over all the Public Data on the Knowledge Base like the published articles, feedback etc.

```
├── assets
│   ├── images
│   ├── javascripts
│   └── stylesheets
├── controllers
│   ├── concerns
│   └── users
├── helpers
├── mailers
├── models
│   └── concerns
└── views
    ├── articles
    ├── categories
    ├── devise
    │   ├── confirmations
    │   ├── mailer
    │   ├── passwords
    │   ├── registrations
    │   ├── sessions
    │   ├── shared
    │   └── unlocks
    ├── features
    ├── layouts
    ├── main
    ├── pictures
    ├── questions
    └── users
        └── permit
```
<center>The Basic Stricture of our Application.</center>
<br><br>
#### Gem Description
This app has been deployed on Openshift. This Application uses Devise for Authentication and CanCan for Role based user access. For the UI part We used a gem.
```ruby
gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass'
```
And the Bootstrap elements are further customized according to the Best Suitable use using SASS.
<br><br>
The Database that has been used for Testing locally is SQlite but uses MySQL in production on Openshift.

```ruby
group :development, :test do
  gem 'sqlite3'
  gem 'minitest'
  gem 'thor'
end

group :production, :mysql do
  gem 'mysql2'
end
```

We also used a small gem for the Datepicker used to filter the feature usage and the article reads.
```ruby
gem 'bootstrap-datepicker-rails'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.0.0'
```
The app uses the default coffeescript to specify js for the app.
<br><br>
There is Basic Image Upload and handling on the API supported for Articles and adding images to those Articles.
```ruby
# Use Paperclip for image handling and uploads
gem 'paperclip'
```
<br><br>
#### Database Schema
The Realtionships are as defined in the Image below.<br>
![Relationships](https://drive.google.com/uc?export=download&id=0B-lUWKmJuey_MmpKOUJxRG5iTGc)
<br><br>
#### Implementation
<br>
The app basically consists of Majorly these controllers.
```
├── controllers
│   ├── articles_controller.rb
│   ├── categories_controller.rb
│   ├── features_controller.rb
│   ├── main_controller.rb
│   ├── pictures_controller.rb
│   ├── questions_controller.rb
│   └── users
│       ├── approval_controller.rb
│       └── permit_controller.rb
```
The articles, categories, pictures and questions controllers are basic controllers with default actions like, new edit create delete etc.
The articles and categories controller contain authoritative access using devise as Only writers are allowed to create and manage the Articles. The Article's text can contain html text basically minimalistic tags for article styling.
```ruby
sanitize(@article.text, tags: %w(a img h1 h2 h3 b i u p div), attributes: %w(id src href class))
```
Article can searched and tagged upon the basis of the tags defined for the article as comma separated values. That is implemented as it searches for an existing Tag if it exists it assigns and if does not then creates it. The Tags are basically links on basis of which the articles can be filtered.
```ruby
# article.rb
def tag_list
  tags.map(&:name).join(", ")
end

def self.tagged_with(name)
  Tag.find_by_name!(name).articles
end

def tag_list=(names)
  self.tags = names.split(",").map do |n|
    Tag.where(name: n.strip).first_or_create!
  end
end
```
Articles also incorporate this neat feature for logging read request on article reads. That has been implemented using a before_filter on the Show action.
```ruby
# articles_controller.rb
authorize_resource
before_filter :log_read, :only=> [:show]

...

def log_read
  @article = Article.find(params[:id])
  if !request.headers['many'].nil?
    request.headers[:many].to_i.times do
      @article.reads.create(ip_address: request.remote_ip, user_id:current_user.nil? ? 0 : current_user.id)
    end
  else
    @article.reads.create(ip_address: request.remote_ip, user_id:current_user.nil? ? 0 : current_user.id)
  end
end
```
The Article Reads can then be filtered on the Basis of the Params passed as Date to the request as a Parameter, and the unique read counts are calculated on the basis of the IP Address of the logged request.
```ruby
def range_count(start_params, end_params)
  start_date = DateTime.strptime(start_params, '%m/%d/%Y')
  end_date = DateTime.strptime(end_params, '%m/%d/%Y')
  reads.where("created_at < ? AND created_at > ?", end_date, start_date).size
rescue ArgumentError
  reads.size
end
```
But for the Questions controller, any Guest User can provide feedback, but the issues can only be solved by the writers or Admins.
<br>
Admins have specialized access for approving Users to become Writers. So only Writers can use the permit_controller for approving all the new Writers and adding more admins.
```ruby
# permit_controller.rb
def permit_edit
  @user = User.find(params[:id])
  respond_to do |format|
    @user.wflag=false
    if @user.update(user_params)
      format.html { redirect_to users_permit_path, notice: 'Permission was successfully updated.' }
    else
      format.html { redirect_to users_permit_path, notice: 'Permission was not successfully updated.' }
    end
  end
end
```
<br>
The approval_controller has been used for by a User for getting access to becoming a Writer for a User so when a new User Logs in to the Portal and clicks on the **Become a Writer** button, then a request is sent for the User to become a writer so that the Admin can approve that request and update Privileges using the permit_controller.
All the access privileges are defined using CanCan.
```ruby
# models/ability.rb
if user.admin?
  can :manage, :all
elsif user.writer?
  can :manage, [ Article, Category, Picture, Question ]
else
  can [:read, :create, :update], Question
  can :read, [ Article, Category, Picture ]
  can :approve_writer, User
end
```
<br>
All of the access is checked using before_filters either the devise default or custom created methods.
```ruby
# permit_controller.rb
before_filter :is_admin?

...

def is_admin?
  redirect_to(root_path, :alert => 'You can\'t access this Page.') and return unless current_user && current_user.admin?
end
```
<br><br>
```
├── models
│   ├── article.rb
│   ├── category.rb
│   ├── feature.rb
│   ├── picture.rb
│   ├── question.rb
│   ├── read.rb
│   ├── tag.rb
│   ├── tagging.rb
│   ├── usage.rb
│   └── user.rb
```
There are basically these 10 models that construct our app. Out of these Models 1 has been created by devise and 2 of them i.e. usage.rb and tag.rb are basically used to create Relationships for recording API. (using the through relation.)
```ruby
# tag.rb
class Tag < ActiveRecord::Base

  has_many :taggings
  has_many :articles, through: :taggings

end

# tagging.rb
class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :article
end

# Similar for the article Reads and the feature Usages
# feature.rb
class Feature < ActiveRecord::Base

  has_many :usages, :as => :usable
  ...

end

# usage.rb
class Usage < ActiveRecord::Base

  belongs_to :usable, polymorphic: true

end

```
There are very specific Routes defined for the app, according to the Usage of the App.
```ruby
# routes.rb
root 'main#index'

devise_for :users

devise_scope :user do
  get 'users/permit' => 'users/permit#permit'
  patch 'user/:id' => 'users/permit#permit_edit'
  post 'users/approve' => 'users/approval#approve_writer'
end

resources :user

resources :categories

resources :pictures

get 'articles/tags/:tag' => 'articles#index', as: :tag

resources :articles do
  get 'stats' => 'articles#stats', as: :stats
end

resources :features, :only => [:index, :show] do
  put :use
end

resources :questions do
  put :upvote
  put :downvote
end
```
These Routes lead to the following routes.These basically refer to the Open Endpoints for the REST Interface.<br>
![routes](https://drive.google.com/uc?export=download&id=0B-lUWKmJuey_S1YtUUxOSE1MdGM)
