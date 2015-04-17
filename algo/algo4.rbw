class Node
  attr_accessor :left, :right
  
  def initialize(val)
    @node = val
    @node_left = nil
    @node_right = nil
  end
  
  def value
    @node
  end
end

class Bin_Tree
  
  def initialize
    @root = nil
  end

  def add_elem(val)
    if @root == nil
      @root = Node.new(val)
    else
      now_node = @root
      loop do
        if now_node == nil
          now_node = Node.new(val)
          break
        elsif val < now_node.value
          if now_node.left == nil
            now_node.left = Node.new(val)
            break
          else
            now_node = now_node.left
          end
        elsif val > now_node.value
          if now_node.right == nil
            now_node.right = Node.new(val)
            break
          else
            now_node = now_node.right
          end
        else
          break
        end
      end
    end
  end

  def puts_node(node, str)
    if node != nil
      puts_node(node.left, str + '    ')
      puts str + node.value.to_s
      puts_node(node.right, str + '    ')
    end
  end
  
  def puts_tree
    puts_node(@root, '')
  end

  def balance_tree(array, i, j)
    if i < j
      n = i + (j - i) / 2
      add_elem(array[n])
      balance_tree(array, i, n - 1)
      balance_tree(array, n + 1, j)
    else
      add_elem(array[i])
    end
  end
  
  def balance(array)
    array.sort!
    balance_tree(array, 0, array.size - 1)
  end
  
  def pre_order_bypass(node, str)
    if node != nil
      puts str + node.value.to_s
      pre_order_bypass(node.left, str + '    ')
      pre_order_bypass(node.right, str + '    ')
    end
  end
  
  def puts_pre_order_bypass
    pre_order_bypass(@root, '')
  end
    
  def post_order_bypass(node, str)
    if node != nil
      post_order_bypass(node.left, str + '    ')
      post_order_bypass(node.right, str + '    ')
      puts str + node.value.to_s
    end
  end
  
  def puts_post_order_bypass
    post_order_bypass(@root, '')
  end
end

puts 'Give me the number of nodes: '
count_node = gets.chomp
a = (0...count_node.to_i).to_a.sort_by{rand}
puts a.inspect
balanced_tree = Bin_Tree.new
balanced_tree.balance(a)
puts 'in order bypass: '
balanced_tree.puts_tree
puts "\r\n" + 'pre order bypass: '
balanced_tree.puts_pre_order_bypass
puts "\r\n" + 'post order bypass: '
balanced_tree.puts_post_order_bypass