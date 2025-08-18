local make_suit_change_joker = function(key, name, suit, atlas_x, atlas_y)
  SMODS.Joker {
    key = key,
    loc_txt = {
      name = name,
      text = {
        "Played cards have a",
        "{C:green}#1# in #2#{} chance to change",
        "suit to {V:1}" .. suit .. "{} when scored."
      },
    },

    blueprint_compat = true,
    config = { extra = {numerator = 1, denominator = 4} },
    rarity = 1,
    atlas = "Jokers",
    pos = { x = atlas_x, y = atlas_y },
    cost = 4,
    loc_vars = function(self, info_queue, card)
      local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator, card.ability.extra.denominator, 'uvdm_'..key)
      return {
        vars = {
          numerator,
          denominator,
          colours = { G.C.SUITS[suit] }
        }
      }
    end,
    calculate = function(self, card, context)
      local other_card = context.other_card
      if context.individual and context.cardarea == G.play and
          other_card.base.suit ~= suit and
          SMODS.pseudorandom_probability(
            card,
            'uvdm_' .. key,
            card.ability.extra.numerator,
            card.ability.extra.denominator) then

        -- Change the suit
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        local percent = 1.15 - (1 - 0.999) / (1 - 0.998) * 0.3
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                other_card:flip()
                play_sound('card1', percent)
                other_card:juice_up(0.3, 0.3)
                return true
            end
        }))
        delay(0.2)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                SMODS.change_base(other_card, suit)
                return true
            end
        }))
        local percent = 0.85 + (1 - 0.999) / (1 - 0.998) * 0.3
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                other_card:flip()
                play_sound('tarot2', percent, 0.6)
                other_card:juice_up(0.3, 0.3)
                return true
            end
        }))

        return {
          card = card
        }
      end
    end,
  }
end

make_suit_change_joker('inkwell', "Inkwell", "Spades", 0, 2)
make_suit_change_joker('bloodshed', "Bloodshed", "Hearts", 1, 2)
make_suit_change_joker('fore', "Fore", "Clubs", 2, 2)
make_suit_change_joker('kite', "Kite", "Diamonds", 3, 2)
