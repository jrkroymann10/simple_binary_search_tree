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