local old_calc_reroll = calculate_reroll_cost

calculate_reroll_cost = function(skip_increment)
  if next(SMODS.find_card('j_uvdm_rollingstone')) then
    if G.shop_jokers and G.shop_jokers.cards then
      local free = true
      for i=1,#G.shop_jokers.cards do
        if G.shop_jokers.cards[i].ability.set == "Joker" then
          free = false
          break
        end
      end

      if free then
        G.GAME.current_round.reroll_cost = 0
        return
      end
    end
  end

  old_calc_reroll(skip_increment)
end

SMODS.Joker {
  key = "rollingstone",
  loc_txt = {
    name = "Rolling Stone",
    text = {
      "Free Reroll if there",
      "are currently no Jokers",
      "available in the shop"
    },
  },

  blueprint_compat = false,
  config = { extra = {} },
  rarity = 2,
  atlas = "Jokers",
  pos = { x = 5, y = 0 },
  cost = 6,
  calculate = function(self, card, context)
    if context.shop_update then
      calculate_reroll_cost(true)
    end
  end
}

