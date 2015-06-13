module Api
  class ContactsController < ApplicationController

    def index
      render json: {key: "value"}
    end
  end
end
