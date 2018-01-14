require 'celluloid/current'

# Example
class TestLoop
  include Celluloid

  def initialize(name)
    @name = name
  end

  def print(word)
    loop do
      p word
      sleep 1
    end
  end

end

tl = TestLoop.new('name')
tl.async.print('dog')

tl1 = TestLoop.new('name1')
tl1.async.print('dog1')

tl2 = TestLoop.new('name2')
tl2.async.print('dog2')

loop do
  sleep 1
end
