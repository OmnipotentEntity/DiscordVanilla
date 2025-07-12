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

        -- If we saw ourselves and at least one other friend
        if #_cards > 1 then
          return {
            -- Joker says As One!
            message = "As One!",
            repetitions = self.config.extra.repetitions,
            card = context.self,
            func = function()
              -- A pared down version of card_eval_status_text designed to 
              -- juice up multiple cards at once
              -- This makes all of the cards that match say "Again!" at the same
              -- time
              percent = 0.9 + 0.2*math.random()
              y_off = -0.05*G.CARD_H
              G.E_MANAGER:add_event(Event({ --Add bonus chips from this card
                trigger = 'before',
                delay = 0.75,
                blocking = nil,
                blockable = nil,
                func = function()
                  for i=1, #_cards do
                    attention_text({
                      text = localize('k_again_ex'),
                      scale = 1, 
                      hold = 0.7375,
                      backdrop_colour = G.C.FILTER,
                      align = 'tm',
                      major = _cards[i],
                      offset = {x = 0, y = y_off}
                    })
                    _cards[i]:juice_up(0.6, 0.1)
                  end
                  G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                  play_sound(sound, 0.8+percent*0.2, 1)
                  return true
                end
              }))
            end
          }
        end
      end
    end
  end

}
