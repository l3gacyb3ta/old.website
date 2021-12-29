require "markd"
require "uri"

class NebulaRenderEngine < Markd::HTMLRenderer
  private def resolve_uri(destination, node)
    base_url = @options.base_url
    return destination unless base_url

    uri = URI.parse(destination)
    return destination if uri.absolute?

    base_url.resolve(uri).to_s
  end

  def image(node : Markd::Node, entering : Bool)
    if entering
      if @disable_tag == 0
        destination = node.data["destination"].as(String)
        destination = resolve_uri(destination, node)
        literal(%(<div class='imgcontainer'><img src="#{escape(destination)}" /> <p class='image-alt'>~ "))
      end
      @disable_tag += 1
    else
      @disable_tag -= 1
      if @disable_tag == 0
        if (title = node.data["title"].as(String)) && !title.empty?
          literal(%(" title="#{escape(title)}))
        end
        literal(%("</p></div>))
      end
    end
  end
end
