SMODS.Joker {
  key = "trailblazer",
  loc_txt = {
    name = "Trailblazer",
    text = {
      "This Joker gains {C:mult}X#1#{} Mult for",
      "every {C:attention}Mult Card{} drawn",
      "before the first hand is played.",
      "{C:inactive}(Currently {C:mult}X#2#{C:inactive} Mult)"
    },
  },

  blueprint_compat = true,
  config = { extra = {base_mult = 1, mult_gain = 0.05, times_gained = 0 } },
  rarity = 3,
  atlas = "Jokers",
  pos = { x = 5, y = 1 },
  cost = 8,
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_gain,
        card.ability.extra.base_mult + card.ability.extra.mult_gain * card.ability.extra.times_gained,
      }
    }
  end,
  calculate = function(self, card, context)
    if context.first_hand_drawn then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end

    if context.hand_drawn and
        not context.repetition and
        not context.blueprint and
        G.GAME.current_round.hands_played == 0 then
      local mult_cards = 0
      for i=1, #context.hand_drawn do
        if SMODS.has_enhancement(context.hand_drawn[i], 'm_mult') then
          mult_cards = mult_cards + 1
        end
      end

      if mult_cards > 0 then
        card.ability.extra.times_gained = card.ability.extra.times_gained + mult_cards

        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT,
          message_card = card,
          card = card
        }
      end
    end

    if context.joker_main then
      xmult = card.ability.extra.base_mult + card.ability.extra.mult_gain * card.ability.extra.times_gained
      if xmult > 1 then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { xmult } },
          Xmult_mod = xmult,
        }
      end
    end
  end,
}

