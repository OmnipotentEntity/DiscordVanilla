SMODS.Joker {
  key = "hivemind",
  loc_txt = {
    name = "Hivemind",
    text = {
      "Retrigger all played cards",
      "that share rank and suit",
      "with another played card.",
    },
  },

  config = { extra = { repetitions = 1 } },
  rarity = 2,
  atlas = "Jokers",
  pos = { x = 4, y = 0 },
  cost = 6,

  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      if not SMODS.has_no_suit(context.other_card) and 
        not SMODS.has_no_rank(context.other_card) then
        local _cards = {}
        for i=1, #G.play.cards do
          local _card = G.play.cards[i]
          if _card.base.suit == context.other_card.base.suit and
            _card.base.value == context.other_card.base.value then
            _cards[#_cards+1] = _card
          end
        end

        if #_cards > 1 then
          return {
            message = localize('k_again_ex'),
            repetitions = self.config.extra.repetitions,
            card = context.self
          }
        end
      end
    end
  end

}
