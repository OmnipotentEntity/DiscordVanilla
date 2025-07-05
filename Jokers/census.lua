SMODS.Joker {
  key = "census",
  loc_txt = {
    name = "Census",
    text = {
      "This Joker gains {C:mult}X#1#{} Mult for",
      "every card with a unique {C:attention}rank{}",
      "scored. Resets at the end of the round.",
      "{C:inactive}(Currently {C:mult}X#2#{C:inactive} Mult)"
    },
  },

  blueprint_compat = true,
  config = { extra = {base_mult = 1, mult_gain = 0.25, times_gained = 0, seen = {}} },
  rarity = 3,
  atlas = "Jokers",
  pos = { x = 3, y = 0 },
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
    if context.individual and context.cardarea == G.play and not context.repetition and not context.blueprint then
      if not SMODS.has_no_rank(context.other_card) and not card.ability.extra.seen[context.other_card:get_id()] then
        card.ability.extra.seen[context.other_card:get_id()] = true
        card.ability.extra.times_gained = card.ability.extra.times_gained + 1
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

    if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
      card.ability.extra.times_gained = 0
      card.ability.extra.seen = {}
      return {
        message = localize('k_reset'),
        colour = G.C.MULT
      }
    end
  end,
}

