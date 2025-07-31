local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"}
local suits = {"Clubs", "Diamonds", "Hearts", "Spades"}

G.localization.misc.v_text.ch_c_reconstruction_win_cond_1={
  "Must finish {C:attention}Ante 8{} with",
}

G.localization.misc.v_text.ch_c_reconstruction_win_cond_2={
  "a standard deck of 52 cards.",
}

G.localization.misc.v_text.ch_c_reconstruction_win_cond_3={
  "{C:inactive}(Enhancements, editions, and seals are OK.){}"
}

G.win_conds.reconstruction = function()
  for _,rank in ipairs(ranks) do
    for _,suit in ipairs(suits) do
      local number_seen = 0
      for _,card in ipairs(G.playing_cards) do
        if card.base.rank == SMODS.ranks[rank]
          and card.base.suit == SMODS.suits[suit] then
          number_seen = number_seen + 1
        end
      end
      if number_seen ~= 1 then
        return false
      end
    end
  end

  return true
end

SMODS.Challenge {
  key = "reconstruction",
  loc_txt = {
    name = "Reconstruction",
  },

  rules = {
    custom = {
      { id = "reconstruction_win_cond_1" },
      { id = "reconstruction_win_cond_2" },
      { id = "reconstruction_win_cond_3" },
      {
        id = "win_condition",
        value = "reconstruction",
      },
    }
  },

  -- Card adding engine
  jokers = {
    {
      id = "j_certificate",
      edition = "negative",
    },
    {
      id = "j_dna",
      edition = "negative",
    },
  },

  -- Give Tarot Merchant and Overstock for less variance
  vouchers = {
    {id = 'v_tarot_merchant'},
    {id = 'v_overstock_norm'},
  },

  -- Remove useful vouchers that will break the challenge
  restrictions = {
    banned_cards = {
      {id = 'v_magic_trick'},
      {id = 'v_illusion'},
      {id = 'v_hieroglyph'},
      {id = 'v_petroglyph'},
    },
  },

  deck = setmetatable({
    type = "Challenge Deck",
  },
  {
    __index = function(table, key)
      if key == "cards" then
        local cards = {}

        -- Initialize a standard 52-card playing deck
        for _,rank in ipairs(ranks) do
          for _,suit in ipairs(suits) do
            cards[#cards+1] = {
              s = SMODS.Suits[suit].card_key,
              r = SMODS.Ranks[rank].card_key
            }
          end
        end

        -- Shuffle the deck (TODO: This is not seeded)
        pseudoshuffle(cards, pseudoseed("reconstruction_challenge"))

        -- Delete the last 27 cards, leaving behind 25 cards total
        for i = #cards, 26, -1 do
          cards[i] = nil
        end

        return cards
      end
    end
  }),
}
