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
    if context.reroll_shop or context.starting_shop then
      G.rolling_stone_activated_this_reroll = false
    end

    if context.shop_update or context.reroll_shop or context.starting_shop then
      local free = true
      for i=1,#G.shop_jokers.cards do
        if G.shop_jokers.cards[i].ability.set == "Joker" then
          free = false
          break
        end
      end

      if free and not G.rolling_stone_activated_this_reroll then
        G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls + 1, 0)
        calculate_reroll_cost(true)
        G.rolling_stone_activated_this_reroll = true
      end

      -- This can occur when purchasing the overstock voucher, a Joker appears
      -- in a vacant slot, deactivating the free reroll we added
      if not free and G.rolling_stone_activated_this_reroll then
        G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
        calculate_reroll_cost(true)
        G.rolling_stone_activated_this_reroll = false
      end
    end

    if context.ending_shop and G.rolling_stone_activated_this_reroll then
      G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
      G.rolling_stone_activated_this_reroll = false
    end
  end
}

