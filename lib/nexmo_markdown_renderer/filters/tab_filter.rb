module Nexmo
  module Markdown
    class TabFilter < Banzai::Filter
      include Nexmo::Markdown::Concerns::PrismCodeSnippet

      def call(input)
        input.gsub(/^(\s*)```tabbed_(examples|content|folder)(.+?)```/m) do |_s|
          @indentation = $1
          @mode = $2
          @config = YAML.safe_load($3)

          if tabbed_folder?
            raise "#{@config['source']} is not a directory" unless File.directory? "#{@config['source']}"

            @tabbed_config = YAML.safe_load(File.read("#{@config['source']}/.config.yml"))
            @path = @config['source']
            validate_folder_config
          else
            validate_config
          end
          html
        end
      end

      private

      def create_tabs(content)
        tab = Nokogiri::XML::Element.new 'div', @document
        tab['class'] = 'Vlt-tabs__link'
        tab['class'] += ' Vlt-tabs__link_active' if content[:active]
        tab['role'] = 'tab'

        if content[:language]
          tab['data-language'] = content[:language].key
          tab['data-language-type'] = content[:language].type
          tab['data-language-linkable'] = content[:language].linkable?
        end

        if content[:platform]
          tab['data-language'] = content[:platform].languages.map(&:key).join(',')
          tab['data-platform'] = content[:platform].key
          tab['data-platform-type'] = content[:platform].type
          tab['data-platform-linkable'] = content[:platform].linkable?
        end

        tab_link = Nokogiri::XML::Element.new 'span', @document
        if content[:language]
          # We don't currently have icons for JSON/XML
          if ['json', 'xml'].include? content[:language].key.downcase
            tab_link.content = content[:tab_title]
          elsif content[:language].key == 'objective_c' || content[:language].key == 'swift'
            tab_link.inner_html = "<svg><use xlink:href=\"/assets/images/brands/ios.svg#ios\" /></svg><span>" + content[:tab_title] + '</span>'
          elsif content[:language].key == 'kotlin'
            tab_link.inner_html = "<img class=\"Vlt-icon Vlt-icon--small\" src=\"/assets/images/brands/kotlin.svg#kotlin\" /><span>" + content[:tab_title] + '</span>'
          else
            tab_link.inner_html = "<svg><use xlink:href=\"/assets/images/brands/#{content[:language].key}.svg##{content[:language].key}\" /></svg><span>" + content[:tab_title] + '</span>'
          end
        elsif content[:platform]
          tab_link.inner_html = "<svg><use xlink:href=\"/assets/images/brands/#{content[:platform].key}.svg##{content[:platform].key}\" /></svg><span>" + content[:tab_title] + '</span>'
        else
          tab_link.content = content[:tab_title]
        end

        tab.add_child(tab_link)
        @tabs.add_child(tab)
      end

      def create_content(content)
        tabs_panel = Nokogiri::XML::Element.new 'div', @document
        tabs_panel['class'] = 'Vlt-tabs__panel'
        tabs_panel['class'] += ' Vlt-tabs__panel_active' if content[:active]

        element = Nokogiri::XML::Element.new 'p', @document
        element['aria-labelledby'] = "\"#{content[:id]}\""
        element['aria-hidden'] = true
        element.inner_html = content[:body]

        tabs_panel.add_child(element)
        @tabs_content.add_child(tabs_panel)
      end

      def tabbed_code_examples?
        @mode == 'examples'
      end

      def tabbed_content?
        @mode == 'content'
      end

      def tabbed_folder?
        @mode == 'folder'
      end

      def html
        html = <<~HEREDOC
          <div class="Vlt-tabs">
            <div class="Vlt-tabs__header Vlt-tabs__header--bordered"></div>
              <div class="Vlt-tabs__content">
              </div>
          </div>
        HEREDOC

        @document = Nokogiri::HTML::DocumentFragment.parse(html)
        @tabs = @document.at_css('.Vlt-tabs__header')
        @tabs_content = @document.at_css('.Vlt-tabs__content')

        contents.each do |content|
          create_tabs(content)
          create_content(content)
        end

        source = @document.to_html

        "#{@indentation}FREEZESTART#{Base64.urlsafe_encode64(source)}FREEZEEND"
      end

      def contents
        list = content_from_folder if tabbed_folder?
        list ||= content_from_source if @config['source']
        list ||= content_from_tabs if @config['tabs']

        list ||= []

        return list unless list.any?

        list = resolve_language(list)

        if tabbed_code_examples?
          list = format_code(list)
          list = resolve_code(list)
          list = resolve_tab_title(list)
        end

        list = sort_contents(list)
        resolve_active_tab(list)

        list
      end

      def validate_config
        return if @config && (@config['source'] || @config['tabs'])

        raise 'Source or tabs must be present in this tabbed_example config'
      end

      def validate_folder_config
        return if @tabbed_config && @tabbed_config['tabbed'] == true

        raise 'Tabbed must be set to true in the folder config YAML file'
      end

      def content_from_source
        source_path = "#{Nexmo::Markdown::Config.docs_base_path}/#{@config['source']}"
        source_path += '/*' if tabbed_code_examples?
        source_path += '/*.md' if tabbed_content?

        files = Dir.glob(source_path)
        raise "Empty content_from_source file list in #{source_path}" if files.empty?

        files.map do |content_path|
          raise "Could not find content_from_source file: #{content_path}" unless File.exist? content_path

          source = File.read(content_path)

          next generate_tabbed_code_examples(source, content_path) if tabbed_code_examples?

          generate_tabbed_content(source) if tabbed_content?
        end
      end

      def content_from_folder
        source_path = "#{@config['source']}"
        source_path += '/*.md'

        files = Dir.glob(source_path)
        raise "Empty content_from_source file list in #{source_path}" if files.empty?

        files.map do |content_path|
          raise "Could not find content_from_source file: #{content_path}" unless File.exist? content_path

          source = File.read(content_path)

          generate_tabbed_content(source)
        end
      end

      def content_from_tabs
        @config['tabs'].map do |title, config|
          raise "Could not find content_from_tabs file: #{Nexmo::Markdown::Config.docs_base_path}/#{@config['source']}" unless File.exist? "#{Nexmo::Markdown::Config.docs_base_path}/#{@config['source']}"

          source = File.read("#{Nexmo::Markdown::Config.docs_base_path}/#{@config['source']}")

          config.symbolize_keys.merge({
            id: SecureRandom.hex,
            source: source,
            language_key: title.dup.downcase,
          })
        end
      end

      def generate_tabbed_content(source)
        content = {
          id: SecureRandom.hex,
          source: source,
        }

        content[:frontmatter] = YAML.safe_load(source)
        content[:language_key] = content[:frontmatter]['language']
        content[:platform_key] = content[:frontmatter]['platform']
        content[:tab_title] = content[:frontmatter]['title']
        content[:body] = Nexmo::Markdown::Renderer.new(options).call(source)

        content
      end

      def generate_tabbed_code_examples(source, content_path)
        content = {
          id: SecureRandom.hex,
          source: source,
        }
        language_key = File.basename(content_path, '.*').downcase
        content[:language_key] = language_key

        content
      end

      def resolve_language(contents)
        contents.map do |content|
          if content[:language_key]
            content[:language] = CodeLanguage.find(content[:language_key])
          end

          if content[:platform_key]
            content[:platform] = CodeLanguage.find(content[:platform_key])
          end

          content
        end
      end

      def format_code(contents)
        contents.each do |content|
          if content[:from_line] || content[:to_line]
            lines = content[:source].lines
            total_lines = lines.count
            from_line = (content[:from_line] || 1) - 1
            to_line = (content[:to_line] || total_lines) - 1
            content[:source] = lines[from_line..to_line].join
          end

          content[:source].unindent! if content[:unindent]
        end
      end

      def resolve_code(contents)
        contents.map do |content|
          @formatter ||= Rouge::Formatters::HTML.new
          lexer = content[:language].lexer
          highlighted_source = @formatter.format(lexer.lex(content[:source]))

          body = code_snippet_body(lexer, highlighted_source)

          content.merge!({ body: body })
        end
      end

      def resolve_tab_title(contents)
        contents.map do |content|
          content.merge!({ tab_title: content[:language].label })
        end
      end

      def sort_contents(contents)
        contents.sort_by do |content|
          next content[:language].weight if content[:language]

          next content[:frontmatter]['menu_weight'] || 999 if content[:frontmatter]

          999
        end
      end

      def resolve_active_tab(contents)
        active_index = nil

        if options[:code_language]
          contents.each_with_index do |content, index|
            %i[language_key platform_key].each do |key|
              active_index = index if content[key] == options[:code_language].key
            end
          end
        end

        @tabs['data-has-initial-tab'] = active_index.present?
        active_index ||= 0

        contents[active_index][:active] = true
      end
    end
  end
end
