SMODS.Challenge {
  key = "student_loan_debt",
  loc_txt = {
    name = "Student Loan Debt",
  },

  rules = {
    custom = {
      {id = "big_starting_debt"},
      {id = "need_pos_money_to_win"},
    },
    modifiers = {
      {
        id = "dollars",
        value = -200,
      },
    },
  },

  jokers = {
    {id = "j_scholar"},
    {id = "j_ramen"},
  },

  restrictions = {
    banned_cards = {
      {id = "c_wraith"}
    },

    banned_other = {
      {
        id = "bl_ox",
        type = "blind",
      },
    },
  },

  deck = {
    type = "Challenge Deck",
  },
}
