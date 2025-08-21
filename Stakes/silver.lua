-- Preorder sticker for silver stake.

G.localization.misc.labels["uvdm_preorder"] = "Pre-Order"
G.localization.descriptions.Stake["stake_uvdm_silver"] = {
  name="Silver Stake",
  text={
    "Shop can have {C:attention}Pre-Order{} Jokers",
    "{C:inactive,s:0.8}(Debuffed for 3 rounds)",
    "{s:0.8}Applies all previous Stakes",
  },
}

SMODS.Sticker {
  key = "preorder",
  loc_txt = {
    name = "Pre-Order",
    text = {
      "Debuffed for #1#",
      "rounds after purchase",
      "{C:inactive}(#2# rounds remaining)",
    },
  },

  badge_colour = HEX('D9B672'),
  atlas = "Stickers",
  pos = {x = 0, y = 0},
  sets = { Joker = true },
  rate = 0.3,
  needs_enable_flag = true,
  
  config = { extra = {rounds = 3, rounds_left = 3} },

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.preorder or self.config.extra.rounds,
        card.ability.preorder_tally or self.config.extra.rounds_left,
      }
    }
  end,

  apply = function(self, card, val)
    card.ability[self.key] = val
    if card.ability[self.key] then
      card.ability.preorder = self.config.extra.rounds
      card.ability.preorder_tally = self.config.extra.rounds_left

      -- We are evaluated before rental, eternal, and perishable.  While we are
      -- compatible with rental and eternal, we're not with perishable.
      card.config.center.perishable_compat = false

      -- Preorder discount
      card.cost = math.ceil((card.cost or 0) / 2)

      -- Fixes bug with collection where example card is debuffed
      if card.ability.set == 'Joker' then
        SMODS.debuff_card(card, true, "uvdm_preorder")
      end
    end
  end,

  should_apply = function(self, card, center, area, bypass_roll)
    return card.ability.set == 'Joker' and
      not card.perishable and
      (area == G.shop_jokers or area == G.pack_cards) and
      SMODS.Sticker.should_apply(self, card, center, area, bypass_roll)
  end,

  calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual then
      if card.ability.preorder_tally and card.ability.preorder_tally > 0 then
        if card.ability.preorder_tally == 1 then
          card.ability.preorder_tally = 0
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Arrived", colour = G.C.MONEY, delay = 0.45})
          SMODS.debuff_card(card, false, "uvdm_preorder")
        else
          card.ability.preorder_tally = card.ability.preorder_tally - 1
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_remaining',vars={card.ability.preorder_tally}},colour = G.C.FILTER, delay = 0.45})
          SMODS.debuff_card(card, true, "uvdm_preorder")
        end
      end
    end
  end
}

SMODS.Stake {
    name = "Silver Stake",
    key = "silver",
    applied_stakes = { "orange" },
    unlocked_stake = "gold",
    prefix_config = {
      applied_stakes = { mod = false },
      unlocked_stake = { mod = false },
      above_stake = { mod = false },
    },

    atlas = "Chips",
    pos = { x = 0, y = 0 },

    sticker_atlas = "Stickers",
    sticker_pos = { x = 1, y = 0 },

    modifiers = function()
        G.GAME.modifiers.enable_uvdm_preorder = true
    end,
    colour = G.C.GREY,
    shiny = true,
    loc_txt = {},
    above_stake = "orange"
}

SMODS.Stake:take_ownership('orange', {
    unlocked_stake = "uvdm_silver",
  }, true
)

SMODS.Stake:take_ownership('gold', {
    applied_stakes = { "uvdm_silver" },
    above_stake = "uvdm_silver"
  }, true
)
