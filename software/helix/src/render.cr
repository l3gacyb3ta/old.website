require "markd"
require "uri"
require "crest"
require "json"
require "time"

class NebulaRenderEngine < Markd::HTMLRenderer
  private def resolve_uri(destination, node)
    base_url = @options.base_url
    return destination unless base_url

    uri = URI.parse(destination)
    return destination if uri.absolute?

    base_url.resolve(uri).to_s
  end

  def link(node, entering)
    if entering
      attrs = attrs(node)
      destination = node.data["destination"].as(String)

      unless @options.safe? && potentially_unsafe(destination)
        attrs ||= {} of String => String

        if escape(destination).starts_with? "mastodon:"
          url = escape(destination).split(":")[1]
          domain = url.split("/")[0]
          id = url.split("/")[1]
          # attrs["class"] = "fedi"

          tag("div", {"class" => "fedi"}) # <div>
          data = JSON.parse(Crest.get("https://#{domain}/api/v1/statuses/#{id}").body)
          # puts Crest.get("https://#{domain}/api/v1/statuses/#{id}").body

          tag("img", {"src" => data["account"]["avatar_static"], "title" => "#{data["account"]["username"]}'s avatar", "class" => "profile"})
          tag("img", end_tag: true)

          tag("a", {"href" => data["account"]["url"], "class" => "profile"})
          literal("@#{data["account"]["acct"]}")
          tag("a", end_tag: true)

          tag("time", {"datetime" => data["created_at"]})
          literal(Time.parse_rfc3339(data["created_at"].to_s).to_s(("%H%M %^a%d %m %Y")))
          tag("time", end_tag: true)

          tag("hr")
          tag("hr", end_tag: true)

          tag("article")
          literal(data["content"].to_s)
          tag("article", end_tag: true)

          if data.[]?("media_attachments") != nil
            data.[]("media_attachments").as_a.each do |img|
              tag("img", {"src" => img["url"], "title" => img.[]?("description"), "class" => "media"})
              tag("img", end_tag: true)
            end
          end

          tag("a", {"href" => "#{data["account"]["url"]}/#{id}"})
          literal("Link")
          tag("a", end_tag: true)

          tag("div", end_tag: true) # </div>
        end

        destination = resolve_uri(destination, node)
        attrs["href"] = escape(destination)
      end

      if (title = node.data["title"].as(String)) && !title.empty?
        attrs ||= {} of String => String
        attrs["title"] = escape(title)
      end

      tag("a", attrs)
    else
      tag("a", end_tag: true)
    end
  end

  def image(node : Markd::Node, entering : Bool)
    if entering
      if @disable_tag == 0
        destination = node.data["destination"].as(String)
        destination = resolve_uri(destination, node)
        literal(%(<div class='imgcontainer'><img alt='A description is directly below this image, prefaced by a tilde.' src="#{escape(destination)}" /> <p class='image-alt'>~ "))
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
