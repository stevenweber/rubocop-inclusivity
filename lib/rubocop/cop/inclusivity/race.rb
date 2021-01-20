# frozen_string_literal: true

module RuboCop
  module Cop
    module Inclusivity
      # Detects potentially insensitive langugae used in variable names and
      # suggests alternatives that promote inclusivity.
      #
      # The `Offenses` config parameter can be used to configure the cop with
      # your list of insensitive words.
      #
      # @example Using insensitive language
      #   # bad
      #   blacklist = 1
      #
      #   # good
      #   banlist = 1
      #
      class Race < Base
        extend AutoCorrector

        MSG = "`%s` may be insensitive. Consider alternatives: %s"

        def on_lvasgn(node)
          name, = *node
          return unless name

          if (alternatives = preferred_language(name))
            add_offense(node.loc.name, message: message(name, alternatives)) do |corrector|
              corrector.replace(node.loc.name, alternatives.first)
            end
          end
        end
        alias on_ivasgn on_lvasgn
        alias on_cvasgn on_lvasgn
        alias on_arg on_lvasgn
        alias on_optarg on_lvasgn
        alias on_restarg on_lvasgn
        alias on_kwoptarg on_lvasgn
        alias on_kwarg on_lvasgn
        alias on_kwrestarg on_lvasgn
        alias on_blockarg on_lvasgn
        alias on_lvar on_lvasgn

        def on_casgn(node)
          _parent, constant_name, _value = *node

          if (alternatives = preferred_language(constant_name))
            add_offense(node.loc.name, message: message(constant_name, alternatives)) do |corrector|
              corrector.replace(node.loc.name, alternatives.first.upcase)
            end
          end
        end

        # def on_array(node)
          # puts node
        # end

        private

        def preferred_language(word)
          cop_config["Offenses"][word.to_s.downcase]
        end

        def message(insensitive, alternatives)
          format(MSG, insensitive, alternatives.join(", "))
        end
      end
    end
  end
end
