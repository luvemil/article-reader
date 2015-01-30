require 'nokogiri'
require 'words_counted'

module Parser
  # We start our search from the body tag
  ROOT_TAG = "body"

  # Minimum words in a paragraph to call it text.
  MIN_WORDS = 10


  def self.find_article root
    # An article is defined as the smallest tag containing all the text, with
    # an appropriate definition of text, as per the is_text method. 

    # CASE: Document contains <article> tags
    # If the page contains an <article> tag assume good faith and return
    # it verbatim.
    if root.css("article").size > 0
      nodes = root.css("article")

      # Returns the article node if there is just one and a NodeSet if there
      # is more than one article tag.
      if nodes.size == 1
        return nodes[0] # => Nokogiri::XML::Node
      else
        return nodes # => Nokogiri::XML::NodeSet
      end
    end

    # CASE: No <article> tag found
    nodes = root.css("p")

    node1 = nodes.pop
    until is_text node1
      node1 = nodes.pop
    end
    node2 = nodes.pop
    until is_text node2
      node2 = nodes.pop
    end

    article = common_ancestor node1, node2
    return article # => Nokogiri::XML::Node
  end

  def self.is_text node
    # Return true if the node is identified as text.
    # text is any <p> tag containing at least 10 words.
    counter = WordsCounted.count(node.text)
    if counter.word_count >= MIN_WORDS
      return true
    else
      return false
    end
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
