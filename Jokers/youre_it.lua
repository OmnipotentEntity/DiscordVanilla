SMODS.Joker {
  key = "youre_it",
  loc_txt = {
    name = "You're It",
    text = {
      "If first hand of the round",
      "contains a scoring {C:attention}#1#{}",
      "of {V:1}#2#{}, gain a random tag."
    },
  },

  blueprint_compat = true,
  rarity = 2,
  atlas = "Jokers",
  pos = { x = 3, y = 1 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    local target = G.GAME.current_round.uvdm_youre_it_card or { rank = 'Ace', suit = 'Spades' }
    return {
      vars = {
        localize(target.rank, 'ranks'),
        localize(target.suit, 'suits_plural'),
        colours = { G.C.SUITS[target.suit] }
      }
    }
  end,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_played == 0 then
      local target = false
      for _, playing_card in ipairs(context.scoring_hand) do
        if playing_card:get_id() == G.GAME.current_round.uvdm_youre_it_card.id and
            playing_card:is_suit(G.GAME.current_round.uvdm_youre_it_card.suit) then
          target = true
          break
        end
      end

      if target then
        -- Can't use get_current_pool function because it obeys the minimum ante
        -- for tags
        local _pool = {}
        local _pool_size = 0
        for k,v in ipairs(G.P_CENTER_POOLS["Tag"]) do
          local add = false
          if (not v.requires or (G.P_CENTERS[v.requires] and G.P_CENTERS[v.requires].discovered)) then
              add = true
          end

          if add and not G.GAME.banned_keys[v.key] then 
              _pool[#_pool + 1] = v.key
              _pool_size = _pool_size + 1
          else
              _pool[#_pool + 1] = 'UNAVAILABLE'
          end
        end

        if _pool_size == 0 then
            _pool = {"tag_handy"}
        end
        
        local tag = pseudorandom_element(_pool, pseudoseed('uvdm_youre_it'))
        local it = 1
        while _tag == 'UNAVAILABLE' do
            it = it + 1
            _tag = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end

        G.E_MANAGER:add_event(Event({
          func = (function()
            add_tag(Tag(tag))
            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
            return true
          end)
        }))
        return {
          message = "Tag!",
          colour = G.C.MONEY,
        }
      end
    end
  end
}

function uvdm_reset_youre_it_card()
    G.GAME.current_round.uvdm_youre_it_card = { rank = 'Ace', suit = 'Spades' }
    local valid_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
            valid_cards [#valid_cards + 1] = playing_card
        end
    end
    local target_card = pseudorandom_element(valid_cards, 'uvdm_youre_it' .. G.GAME.round_resets.ante)
    if target_card then
        G.GAME.current_round.uvdm_youre_it_card.rank = target_card.base.value
        G.GAME.current_round.uvdm_youre_it_card.suit = target_card.base.suit
        G.GAME.current_round.uvdm_youre_it_card.id = target_card.base.id
    end
end
