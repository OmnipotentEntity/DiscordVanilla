SMODS.Consumable {
  key = "chimera",
  set = "Spectral",
  loc_txt = {
    name = "Chimera",
    text = {
      "Select {C:attention}2{} playing cards,",
      "transfer {C:attention}edition, enhancement, and seal{} from",
      "the {C:attention}left{} card to the {C:attention}right{}",
      "destroying the {C:attention}left{} card."
    },
  },

  atlas = "Consumables",
  pos = { x = 0, y = 0 },

  can_use = function(self, card)
    return #G.hand.highlighted == 2
  end,

  use = function(self, card, area, copier)
    local left = G.hand.highlighted[1]
    local right = G.hand.highlighted[2]

    local left_enh = SMODS.get_enhancements(left)
    if next(left_enh) then
      right:set_ability(next(left_enh))
    end

    if left.edition then
      right:set_edition(left.edition, true, true)
    end

    if left.seal then
      right:set_seal(left.seal, true)
    end

    SMODS.destroy_cards(left)
  end
}

