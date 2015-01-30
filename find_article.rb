require 'nokogiri'

module Parser
  # We start our search from the body tag
  ROOT_TAG = "body"


  def self.find_article root
    # An article is defined as the smallest tag containing all the text, with
    # an appropriate definition of text. In this first example text is
    # everything inside a <p> tag, so the article is the smallest tag
    # containing all the <p> tags
    nodes = root.css("p")
    if nodes.size > 2
      article = common_ancestor nodes[1], nodes[2]
    else 
      return nil
    end
    return article
  end

  def self.depth node
    # Depth of a node relative to the root (body)
    if node.name == ROOT_TAG
      return 0
    end
    return 1 + depth(node.parent)
  end

  def self.get_nparent node, n
    if n == 1
      return node.parent
    end
    return get_nparent node.parent, n-1
  end

  def self.same_depth_ancestor node1, node2
    # A helper function for common_ancestor, it assumes that node1 and node2
    # have the same depth, and goes on comparing their direct parents.
    if node1 == node2
      return node1
    else
      return common_ancestor node1.parent, node2.parent
    end 
  end

  def self.common_ancestor node1, node2
    # Returns the smallest common ancestor of node1 and node2. It make sure
    # that both node1 and node2 have the same depth, extract parents if not,
    # and then uses same_depth ancestor.

    first_depth = depth(node1)
    second_depth = depth(node2)
    if first_depth == second_depth
      return same_depth_ancestor node1, node2
    elsif first_depth > second_depth
      deep = node1
      near = node2
      diff = first_depth - second_depth
    else
      deep = node2
      near = node1
      diff = second_depth - first_depth
    end
    new_node = get_nparent deep, diff
    return same_depth_ancestor near, new_node
  end

  def self.main filename
    html_file = filename
    doc = Nokogiri::HTML IO.read(html_file)

    root = doc.css(ROOT_TAG)

    return find_article root
  end
end
