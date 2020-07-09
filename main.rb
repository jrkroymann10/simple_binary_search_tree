require_relative 'tree.rb'
require_relative 'node.rb'

x = Tree.new(Array.new(15) { rand(1..100) })

puts "\n" + 'Current Tree:'
puts "\n"
x.pretty_print

puts "\n" + "is the tree balanced? #{x.balanced?}"
puts "\n" + 'Traversal Methods:'
puts "\n" + "level order: #{x.level_order}"
puts "\n" + "preorder: #{x.preorder}"
puts "\n" + "postorder: #{x.postorder}"
puts "\n" + "inorder: #{x.inorder}"
x.insert(101)
x.insert(102)
x.insert(103)
x.insert(104)
puts "\n" + "Modified Tree"
puts "\n"
x.pretty_print
puts "\n" + "is the tree balanced? #{x.balanced?}"
x.rebalance!
puts "\n" + "Rebalanced Tree"
puts "\n"
x.pretty_print
puts "\n" + "is the tree balanced? #{x.balanced?}"
puts "\n" + 'Updated Traversal Methods:'
puts "\n" + "level order: #{x.level_order}"
puts "\n" + "preorder: #{x.preorder}"
puts "\n" + "postorder: #{x.postorder}"
puts "\n" + "inorder: #{x.inorder}"

