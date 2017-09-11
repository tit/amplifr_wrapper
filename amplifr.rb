# encoding: utf-8

require 'unirest'

# Wrapper for Amplifr API
# http://amplifr.com
# http://docs.amplifr.apiary.io
# @author Sergey Blohin
# @email sblohin@yandex.ru
class Amplifr
  def initialize(access_token, project_id)
    @api_url = 'https://amplifr.com/api/v1/projects'.freeze

    @access_token = access_token
    @project_id = project_id
  end

  # Get Available Projects List
  # Returns all projects from the system that the user has access to.
  # This is the only call you'll need to do to
  # get all the information you'll need to start scheduling posts.
  # It alreay has Accounts and Users bundled in the response.
  # @return [Hash]
  def available_projects_list
    uri = "#{@api_url}?access_token=#{@access_token}"
    get uri
  end

  # Get Social Accounts for a Project
  # Returns all social accounts from the project that the user has access to.
  # @return [Hash]
  def social_accounts_for_a_project
    uri = "#{@api_url}/#{@project_id}/accounts?access_token=#{@access_token}"
    get uri
  end

  # Get Users for a Project
  # Returns all users from the project with their roles
  # @return [Hash]
  def users_for_a_project
    uri = "#{@api_url}/#{@project_id}/users?access_token=#{@access_token}"
    get uri
  end

  # Get Scheduled Posts
  # Returns paginated scheduled posts from the project.
  # @return [Hash]
  def scheduled_posts(page = 1, per_page = 1, today = true, order = 'DESC')
    uri = "#{@api_url}/#{@project_id}/posts?page=#{page}&per_page=#{per_page}&today=#{today}&order=#{order}&access_token=#{@access_token}"
    get uri
  end

  # Create (schedule) a Post
  # Creates a new post in the Project's schedule.
  # You can schedule a post to be published to choosen Social Media Accounts right now, or schedule it for later.
  # Keep in mind that if you want to use images and videos in your post,
  # you should provide those via uploading them via the appropriate methods of this API.
  # @param [Hash] post_data
  # @return [Hash]
  def create_schedule_post(post_data)
    uri = "#{@api_url}/#{@project_id}/posts?access_token=#{@access_token}"
    post uri, post_data
  end

  # Get a Post
  # Returns detailed information about one post.
  def get_post(post_id)
    uri = "#{@api_url}/#{@project_id}/posts/#{post_id}?access_token=#{@access_token}"
    get uri
  end

  # Update a Post
  # Edit and update a scheduled post.
  def update_post(post_id, post_data)
    uri = "#{@api_url}/#{@project_id}/posts/#{post_id}?access_token=#{@access_token}"
    put uri, post_data
  end

  # Delete a Post
  # Edit and update a scheduled post.
  def delete_post(post_id, post_data)
    uri = "#{@api_url}/#{@project_id}/posts/#{post_id}?access_token=#{@access_token}"
    delete uri, post_data
  end

  # Returns url to image
  # @param [Fixnum] image_id
  # @return [String] URL to image
  # @return [FalseClass]
  def image_url(image_id)
    uri = "#{@api_url}/#{@project_id}/images/#{image_id}?access_token=#{@access_token}"
    result = get uri
    result['ok'] ? result['result']['url'] : false
  end

  # Returns server url for image uploading
  def server_image_url(filename)
    uri = "#{@api_url}/#{@project_id}/images/get_upload_url?filename=#{filename}&access_token=#{@access_token}"
    get uri
  end

  # Uploads image from provided url
  # @param [String] image_url
  # @return [Fixnum] image_id
  # @return [FalseClass]
  def upload_image(image_url)
    uri = "#{@api_url}/#{@project_id}/images/upload_from_url?url=#{image_url}&access_token=#{@access_token}"
    result = post uri
    result['ok'] ? result['result']['id'] : false
  end

  # Commits image and allows Amplifr to use the image for publication later.
  # @param [Fixnum] image_id
  # @return [Hash]
  def commit_image(image_id)
    uri = "#{@api_url}/#{@project_id}/images/#{image_id}/commit?access_token=#{@access_token}"
    post uri
  end

  private

  # Send HTTP GET request
  # @param [String] uri
  # @return [Hash]
  def get(uri)
    response = Unirest.get uri
    response.body
  end

  # Send HTTP POST request
  # @param [String] uri
  # @param [Hash] parameters
  # @return [Hash]
  def post(uri, parameters = nil)
    response = Unirest.post uri, parameters: parameters
    response.body
  end

  # Send HTTP PUT request
  # @param [String] uri
  # @param [Hash] parameters
  # @return [Hash]
  def put(uri, parameters)
    response = Unirest.put uri, parameters: parameters
    response.body
  end

  # Send HTTP DELETE request
  # @param [String] uri
  # @param [Hash] parameters
  # @return [Hash]
  def delete(uri, parameters)
    response = Unirest.delete uri, parameters: parameters
    response.body
  end
end
