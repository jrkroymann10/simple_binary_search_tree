require 'pry'

class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child, :children
  def <=>(other)
    self.value <=> other.value
  end
  def initialize(value, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
    @children = [left_child, right_child]
  end
end

class Tree
  attr_accessor :root
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    correct_array = sort_and_remove_dups(array) # sort/remove duplicates before building tree
    half = (correct_array.length / 2).floor
    root = Node.new(correct_array[half])
    assign_node(root, correct_array[0...half], correct_array[half + 1...correct_array.length])
    root
  end

  def insert(value, root = @root)
    if root.left_child.nil? && root.right_child.nil?
      if value < root.value
        root.left_child = Node.new(value)
      elsif value > root.value
        root.right_child = Node.new(value)
      end
    elsif value < root.value
      insert(value, root.left_child)
    elsif value > root.value
      insert(value, root.right_child)
    end
  end

  def delete(value, root = @root)
    return root if root.nil?

    if value < root.value
      root.left_child = delete(value, root.left_child)
    elsif value > root.value
      root.right_child = delete(value, root.right_child)
    else
      if root.left_child.nil? && root.right_child.nil?
        root = nil
      elsif root.left_child.nil?
        root = root.right_child
      elsif root.right_child.nil?
        root = root.left_child
      else
        temp = find_min(root.right_child)
        root.value = temp.value
        root.right_child = delete(temp.value, root.right_child)
      end
    end
    root
  end

  def find(value, root = @root)
    if @root.nil?
      puts 'no such node with the given value'
    elsif value == root.value
      root
    elsif value < root.value
      find(value, root.left_child)
    elsif value > root.value
      find(value, root.right_child)
    end
  end

  def level_order(queue = Queue.new.enq(@root))
    until queue.empty?
      node = queue.pop
      queue << node.left_child unless node.left_child.nil?
      queue << node.right_child unless node.right_child.nil?
      puts node.value
    end
  end

  def level_order_recursive(queue = Queue.new.enq(@root))
    return queue if queue.empty?

    node = queue.pop
    yield node
    queue << node.left_child unless node.left_child.nil?
    queue << node.right_child unless node.right_child.nil?
    level_order(queue)
  end

  # LDR - still need to allow for intake of block
  def inorder(root = @root, ary = [])
    return root if root.nil?

    inorder(root.left_child, ary)
    ary.push(root.value)
    inorder(root.right_child, ary)
    ary
  end

  # DLR
  def preorder(root = @root, ary = [])
    return root if root.nil?

    ary.push(root.value)
    preorder(root.left_child, ary)
    preorder(root.right_child, ary)
    ary
  end

  # LRD
  def postorder(root = @root, ary = [])
    return root if root.nil?

    postorder(root.left_child, ary)
    postorder(root.right_child, ary)
    ary.push(root.value)
    ary
  end

  # number of levels below a node
  def depth(node, root = @root)
    count = 0
    until node == root
      if node.value < root.value
        root = root.left_child
      elsif node.value > root.value
        root = root.right_child
      end
      count += 1
    end
    count
  end

  def balanced?(root = @root)
    left = find_height(root.left_child)
    right = find_height(root.right_child)
    [left, right].max - [left, right].min > 1 ? false : true
  end

  private

  def find_height(node)
    return -1 if node.nil?

    [find_height(node.left_child), find_height(node.right_child)].max + 1
  end

  # Finding min in a subtree, left < right
  def find_min(root)
    until root.left_child.nil?
      root = root.left_child
    end
    root
  end

  def assign_node(root, left_half, right_half)
    unless left_half.nil? || right_half.nil? 
      l_half = left_half.length / 2
      r_half = right_half.length / 2
      unless left_half[l_half].nil?
        root.left_child = Node.new(left_half[l_half])
      end
      unless right_half[r_half].nil?
        root.right_child = Node.new(right_half[r_half])
      end
      assign_node(root.left_child, left_half[0...l_half], left_half[l_half + 1...left_half.length])
      assign_node(root.right_child, right_half[0...r_half], right_half[r_half + 1...right_half.length])
    end
  end

  def sort_and_remove_dups(array)
    sorted = merge_sort(array)
    no_dups = remove_duplicates(sorted)
    no_dups
  end

  def merge(left, right)
    if left.empty?
      right
    elsif right.empty?
      left
    elsif left.first == right.first
      [left.first] + [right.first] + merge(left[1...left.length], right[1...right.length])
    elsif left.first < right.first
      [left.first] + merge(left[1...left.length], right)
    elsif right.first < left.first
      [right.first] + merge(left, right[1...right.length])
    end
  end

  def merge_sort(ary)
    if ary.length == 1
      ary
    else
      half = (ary.length / 2).floor
      left = merge_sort(ary[0..(half - 1)])
      right = merge_sort(ary[half..ary.length])
      merge(left, right)
    end
  end

  def remove_duplicates(array)
    new_array = []
    array.each do |char|
      unless new_array.include? char
        new_array.push(char)
      end
    end
    new_array
  end
end

x = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

p x.root
puts ''
x.level_order_recursive { |this_node| puts this_node.value }
puts ''
p x.inorder
puts ''
p x.preorder
puts ''
p x.postorder
puts ''

y = x.find(6345)

puts x.depth(y)

p x.root

puts ''

p x.balanced?
