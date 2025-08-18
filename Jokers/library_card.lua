local unique_jokers_owned = function()
  local ret = 0
  for _,_ in pairs(G.GAME.uvdm_jokers_owned or {}) do
    ret = ret + 1
  end

  return ret
end

SMODS.Joker {
  key = "library_card",
  loc_txt = {
    name = "Library Card",
    text = {
      "{C:mult}+#1#{} Mult for every",
      "unique Joker owned",
      "this run.",
      "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
    },
  },

  blueprint_compat = true,
  config = { extra = { mult_gain = 2 } },
  rarity = 1,
  atlas = "Jokers",
  pos = { x = 4, y = 2 },
  cost = 5,
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_gain,
        card.ability.extra.mult_gain * unique_jokers_owned()
      }
    }
  end,

  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult_gain * unique_jokers_owned()
      }
    end
  end,
}

