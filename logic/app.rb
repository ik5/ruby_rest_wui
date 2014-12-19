
class App < Sinatra::Base
  require_relative 'rest'
  require_relative 'testing'

  use ::Testing
  use ::REST
end
