module Nexmo
  module Markdown
    class AudioFilter < Banzai::Filter
      def call(input)
        input.gsub(/[u{🔈}]\[(.+?)\]/) do
          audio = <<~HEREDOC
            <audio preload="none" controls>
              <source src="#{$1}" type="audio/mpeg">
            </audio>
          HEREDOC

          "FREEZESTART#{Base64.urlsafe_encode64(audio)}FREEZEEND"
        end
      end
    end

  end
end
