SMODS.Joker {
  key = "backup_plan",
  loc_txt = {
    name = "Backup Plan",
    text = {
      "This Joker gains {C:mult}X#1#{} Mult if",
      "played hand contains 4 or more",
      "scoring cards and cards held in hand",
      "also contain the same poker hand.",
      "{C:inactive}(Currently {C:mult}X#2#{C:inactive} Mult)"
    },
  },

  blueprint_compat = true,
  config = { extra = {base_mult = 1, mult_gain = 0.5, times_gained = 0, seen = {}} },
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
    if context.before and context.main_eval and not context.blueprint then
      local _,_,poker_hands,_,_ = G.FUNCS.get_poker_hand_info(G.hand.cards)
      if #context.scoring_hand >= 4 and next(poker_hands[context.scoring_name]) then
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
  end,
}

