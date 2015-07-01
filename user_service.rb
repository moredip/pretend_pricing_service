require 'grape'

module UserService
  class API < Grape::API
    format :json

    get do
      {oh: "yay"}
    end
  end
end
