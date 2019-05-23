module TreeTraversal
  def in_order_traversal(node: self,
                         level: 0,
                         method: :visit,
                         result_proc: nil)
    results = []

    if node
      results << in_order_traversal(node: node.left, level: level + 1, method: method)

      results << if block_given?
                 yield(node, level)
               elsif method && node.respond_to?(method)
                 node.send(method)
               end

      results << in_order_traversal(node: node.right, level: level + 1, method: method)

      results.flatten!.compact!
    end

    result_proc && !results.empty? ? result_proc[results] : results
  end
end
