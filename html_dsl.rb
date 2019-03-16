class HtmlDsl
  class BadDslError < ArgumentError; end
  BASIC_TAGS = %i[html head title body div h1 h2 h3 h4 h5 h6 p form input img]

  BASIC_TAGS.each do |tag|
    define_method tag do |*args, &block|
      tag(tag, *args, &block)
    end
  end

  attr_reader   :default_indentation
  attr_reader   :current_indentation
  attr_reader   :pretty_print

  def initialize(pretty_print: true, initial_indentation: 0, default_indentation: 2)
    @pretty_print        = pretty_print
    @default_indentation = default_indentation
    @current_indentation = initial_indentation
  end

  def document(&block)
    @output = ''

    if block.arity == 0
      instance_eval &block
    else
      yield(self)
    end

  rescue NoMethodError => e
    raise BadDslError, e.to_s
  end

  def google_map(*args, &block)
    text, attributes = *tag_args(args)
    tag(:img, {src: GoogleMap.new(attributes[:address]).url})
  end

  def tag(html_tag, *args, &block)
    text, attributes = *tag_args(args)

    append(:indent, "<#{html_tag}#{format_attributes(attributes)}>#{text}")

    if block_given?
      increase_indentation
      append(:newline)
      instance_eval &block
      decrease_indentation
      append(:indent)
    end

    append("</#{html_tag}>", :newline)

    return @output
  end

  private

  def increase_indentation; @current_indentation += default_indentation; end
  def decrease_indentation; @current_indentation -= default_indentation; end

  def append(*args)
    args.each do |arg|
      case arg
      when :indent
        @output << "#{([' '] * current_indentation).join}" if pretty_print
      when :newline
        @output << "\n" if pretty_print
      else
        @output << arg
      end
    end
  end

  def tag_args(args)
    text       = args.shift if ! args[0].respond_to? :each
    attributes = Hash(args[0])
    [text, attributes]
  end

  def format_attributes(args)
    args.map {|k,v| " #{k}='#{v}'"}.join
  end
end