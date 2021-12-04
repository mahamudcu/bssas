class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page]

  # GET /users or /users.json
  def index
    render layout: 'admin_layout'
  end

  def landing_page
    render layout: 'landing_page_layout'
  end

  end
