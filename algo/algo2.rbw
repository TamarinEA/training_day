class Stack
  def initialize(size)
    @size = size
    @stack = Array.new(@size)
    @top = -1
  end
  
  def pop
    if empty?
      nil
    else
      pop_elem = @stack[@top]
      @stack[@top] = nil
      @top -= 1
      pop_elem
    end
  end
  
  def push(element)
    if full? || element.nil?
      nil
    else
      @top += 1
      @stack[@top] = element
      self
    end    
  end
  
  def size
    @size
  end
  
  def look
    @stack[@top]
  end
  
  private
  
  def full?
    @top == @size - 1
  end
  
  def empty?
    @top == -1
  end
  
  def makenull
    @top = -1
  end
end

my_stack = Stack.new(3)
my_stack.push(1)
my_stack.push(3)
my_stack.push(5)
puts my_stack.pop
puts my_stack.look