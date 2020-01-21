module CodeSnippetRenderer
  class Java < Base
    def self.dependencies(deps)
      {
        'text' => t('services.code_snippet_renderer.add_instructions_to_file', file: 'build.gradle'),
        'code' => deps.map { |d| "compile '#{d.gsub('@latest', '5.1.0')}'" }.join('<br />'),
        'type' => 'groovy',
      }
    end

    def self.run_command(_command, filename, file_path)
      package = file_path.gsub('.repos/nexmo/nexmo-java-code-snippets/src/main/java/', '').tr('/', '.').gsub(filename, '')
      file = filename.gsub('.java', '')
      main = "#{package}#{filename.gsub('.java', '')}"
      chomped_package = package.chomp('.')

      ::I18n.t('.run_command', chomped_package: chomped_package, package: package, main: main, file: file)
    end

    def self.create_instructions(filename)
      ::I18n.t('.create_instructions', file: filename.gsub('.java', ''))
    end

    def self.add_instructions(filename)
      ::I18n.t('.add_instructions', file: filename.gsub('.java', ''))
    end
  end
end
