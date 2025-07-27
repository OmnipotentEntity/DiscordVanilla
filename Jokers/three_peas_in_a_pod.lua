SMODS.Joker {
  key = "three_peas",
  loc_txt = {
    name = "Three Peas in a Pod",
    text = {
      "Allows up to {C:attention}#1#{}",
      "extra discards when no",
      "discards remain.",
      "{C:inactive}({C:attention}#2#{C:inactive} discards remain)"
    },
  },

  config = { extra = { extra_discards = 3, used_discards = 0 } },
  rarity = 1,
  atlas = "Jokers",
  pos = { x = 1, y = 1 },
  cost = 3,
  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.extra_discards,
        card.ability.extra.extra_discards - card.ability.extra.used_discards
      }
    }
  end,
  calculate = function(self, card, context)
    if context.pre_discard and G.GAME.current_round.discards_left <= 0 then
      if G.uvdm_pea_used then
        return
      end

      G.uvdm_pea_used = true
      card.ability.extra.used_discards = card.ability.extra.used_discards + 1
      if card.ability.extra.used_discards >= card.ability.extra.extra_discards then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))

        return {
          message = localize('k_eaten_ex'),
          colour = G.C.RED
        }
      else
        return {
          message = tostring(card.ability.extra.extra_discards - card.ability.extra.used_discards),
          colour = G.C.GREEN
        }
      end
    end
  end
}

