# frozen_string_literal: true

# A codename is three words separated by hyphens
module CodenameGeneratorHelper
  def generate_codename
    components = []
    components << Spicy::Proton.adjective
    components << Spicy::Proton.adjective

    noun = ''
    loop do
      noun = Spicy::Proton.noun
      break if (noun.include? '_') == false
    end
    components << noun

    components.join('-')
  end
end
