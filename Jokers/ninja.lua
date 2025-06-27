-- Is this area a scoring area?
function ninja_is_scoring_area(area)
  if area == G.play then
    return true
  end
  if next(SMODS.find_card('j_uvdm_ninja')) then
    return area == G.hand
  end
end

-- add the cards that will be triggered by held in hand effects to the scoring
-- hand during the play phase
function ninja_add_cards_play_phase(scoring_hand)
  -- TODO: Make this more general and compatible by performing a dry run on the
  -- card instead of having a list
  if next(SMODS.find_card('j_uvdm_ninja')) then
    -- If we're in the play phase, add the cards in the hand that will be
    -- triggered by some effect during the scoring phase.  These are Steel,
    -- Baron, Shoot The Moon, Reserved Parking, and Raised Fist in Vanilla.
    local has_baron = next(SMODS.find_card('j_baron'))
    local has_stm = next(SMODS.find_card('j_shoot_the_moon'))
    local has_rp = next(SMODS.find_card('j_reserved_parking'))
    local has_rf = next(SMODS.find_card('j_raised_fist'))

    -- First, we need to find the raised fist target
    local rf_target = 0
    local rf_id = 15
    for i = 1, #G.hand.cards do
      local id = G.hand.cards[i]:get_id()
      if id <= rf_id and
          not SMODS.has_enhancement(G.hand.cards[i], 'm_stone') then
        rf_target = i
        rf_id = id
      end
    end

    -- Then, we add the cards that will be targeted by a held in hand effect to
    -- the scoring hand
    for i = 1, #G.hand.cards do
      card_id = G.hand.cards[i]:get_id()
      is_face = G.hand.cards[i]:is_face()
      is_steel = SMODS.has_enhancement(G.hand.cards[i], 'm_steel')
      if (i == rf_target and has_rf) or
          (card_id == 13 and has_baron) or
          (card_id == 12 and had_stm) or
          (is_face and has_rp) or
          is_steel then
        table.insert(scoring_hand, G.hand.cards[i])
      end
    end
  end
end

function ninja_unhighlight_hand_cards()
  for i = 1, #G.hand.cards do
    G.hand:remove_from_highlighted(G.hand.cards[i])
  end
end

-- add the cards that will be triggered by held in hand effects to the scoring
-- hand in the end of round phase
function ninja_end_of_round_would_trigger(card)
  -- TODO: Make this more general and compatible by performing a dry run on the
  -- card instead of having a list
  if next(SMODS.find_card('j_uvdm_ninja')) then
    -- Check that the card is one which will be triggered by some effect during
    -- the end of round phase.  These are Blue Seal and Gold.
    if SMODS.has_enhancement(card, 'm_gold') or
        card.seal == 'Blue' then
      return true
    end
  end
end

-- TODO: Fix issue where repetitions aren't shared during end of round phase.
SMODS.Joker {
  key = "ninja",
  loc_txt = {
    name = "Ninja",
    text = {
      "Cards triggered through",
      "{C:attention}held in hand{} abilities",
      "are also {C:attention}scored{}.",
      "{s:0.8}(Chips and Mult gained",
      "{s:0.8}during the {C:attention,s:0.8}end of round{}",
      "{s:0.8}phase are discarded.)"
    },
  },

  config = { extra = {} },
  rarity = 3,
  atlas = "DiscordVanilla",
  pos = { x = 0, y = 0 },
  cost = 10,
  calculate = function(self, card, context)
    if context.drawing_cards and G.STATE == G.STATES.DRAW_TO_HAND then
      ninja_unhighlight_hand_cards()
    elseif context.end_of_round and context.cardarea == G.jokers then
      for i = 1, #G.hand.cards do
        if ninja_end_of_round_would_trigger(G.hand.cards[i]) then
          G.hand:add_to_highlighted(G.hand.cards[i])
        else
          G.hand:remove_from_highlighted(G.hand.cards[i])
        end
      end
    end
  end
}

