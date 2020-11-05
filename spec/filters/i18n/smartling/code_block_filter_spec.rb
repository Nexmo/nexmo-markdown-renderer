require 'spec_helper'

RSpec.describe Nexmo::Markdown::I18n::Smartling::CodeBlockFilter do
  let(:code_block) do
    <<-CODE_BLOCK


    ! " # $ % ' ( ) * + , - . / : ; < = > ? @ _ ¡ £ ¥ § ¿ & ¤
    0 1 2 3 4 5 6 7 8 9
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    a b c d e f g h i j k l m n o p q r s t u v w x y z
    Ä Å Æ Ç É Ñ Ø ø Ü ß Ö à ä å æ è é ì ñ ò ö ù ü Δ Φ Γ Λ Ω Π Ψ Σ Θ Ξ


    CODE_BLOCK
  end

  it 'treats it as a code block' do
    block = described_class.call(code_block)

    expect(block).to eq(
      <<~CODE_BLOCK

      ````
      ! " # $ % ' ( ) * + , - . / : ; < = > ? @ _ ¡ £ ¥ § ¿ & ¤
      0 1 2 3 4 5 6 7 8 9
      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
      a b c d e f g h i j k l m n o p q r s t u v w x y z
      Ä Å Æ Ç É Ñ Ø ø Ü ß Ö à ä å æ è é ì ñ ò ö ù ü Δ Φ Γ Λ Ω Π Ψ Σ Θ Ξ
      ````

      CODE_BLOCK
    )
  end
end
