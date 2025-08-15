SMODS.Joker {
  key = "ascension",
  loc_txt = {
    name = "Ascension",
    text = {
      "Raise the cap on interest",
      "earned by {C:money}$#1#{} whenever",
      "a {C:attention}boss blind{} is defeated."
    },
  },

  blueprint_compat = true,
  config = { extra = { amount = 1 } },
  rarity = 1,
  atlas = "Jokers",
  pos = { x = 2, y = 1 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.amount,
      }
    }
  end,
  calculate = function(self, card, context)
    if context.end_of_round and 
        not context.repetition and
        not context.individual and
        G.GAME.blind.boss then
      G.GAME.interest_cap = G.GAME.interest_cap + 5 * card.ability.extra.amount

      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.MONEY,
      }
    end
  end
}

-- Need to take ownership of the seed money and money tree vouchers
-- to change how they function to be compatible with this joker.
SMODS.Voucher:take_ownership('seed_money', {
  loc_txt = {
    name = "Seed Money",
    text = {
      "Raise the cap on",
      "interest earned in",
      "each round by {C:money}$#1#{}"
    },
  },
  config = { extra = { amount = 5 } },
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.amount
      }
    }
  end,
  redeem = function(self, card)
    G.GAME.interest_cap = G.GAME.interest_cap + 5 * card.ability.extra.amount
  end,
}, true)

SMODS.Voucher:take_ownership('money_tree', {
  loc_txt = {
    name = "Money Tree",
    text = {
      "Raise the cap on",
      "interest earned in",
      "each round by {C:money}$#1#{}"
    },
  },
  config = { extra = { amount = 10 } },
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.amount
      }
    }
  end,
  redeem = function(self, card)
    G.GAME.interest_cap = G.GAME.interest_cap + 5 * card.ability.extra.amount
  end,
}, true)
