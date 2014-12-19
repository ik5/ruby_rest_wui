
class App < Sinatra::Base
  require_relative 'testing'
  require_relative 'rest'

  use ::Testing
  use ::REST
end
