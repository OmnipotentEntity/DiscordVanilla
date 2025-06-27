SMODS.Joker {
  key = "template",
  loc_txt = {
    name = "Template",
    text = {
        "Retrigger enhanced cards",
        "one time for each",
        "corresponding tarot held",
        "in the consumable area."
    },
  },

  blueprint_compat = true,
  config = { extra = {} },
  rarity = 3,
  atlas = "DiscordVanilla",
  pos = { x = 1, y = 0 },
  cost = 10,
  calculate = function(self, card, context)
      if context.cardarea == G.play and context.repetition and not context.repetition_only then
          local reps = 0
          local targets = {}
          for _,_card in ipairs(G.consumeables.cards) do
              if _card.ability and _card.ability.mod_conv then
                  if SMODS.has_enhancement(context.other_card, _card.ability.mod_conv) then
                      reps = reps + 1
                      targets[#targets+1] = _card
                  end
              end
          end

          if reps > 0 then
              return {
                message = localize('k_tarot'),
                repetitions = reps,
                card = card,
                func = function()
                    card_eval_status_text(targets[1], 'extra', nil, percent, nil, {message = localize('k_again_ex')})
                    table.remove(targets, 1)
                end
              }
          end
      end
  end
}

