function uvdm_get_boss_reroll_button()
  local label = {
    localize('b_reroll_boss'),
    {
      ref_table = G.GAME,
      ref_value = 'boss_reroll_button_text',
    }
  }

  uvdm_update_boss_reroll_text()

  if G.GAME.used_vouchers["v_retcon"]
      or G.GAME.used_vouchers["v_directors_cut"]
      or uvdm_get_first_boss_tag() then
    return UIBox_button({
      label = label,
      button = "reroll_boss",
      func = 'reroll_boss_button',
      id = 'boss_reroll_ui'
    })
  end
end

function uvdm_update_boss_reroll_text()
  if G.GAME.used_vouchers["v_retcon"]
      or G.GAME.used_vouchers["v_directors_cut"] then
    G.GAME.boss_reroll_button_text = localize('$')..'10'
  end

  if uvdm_get_first_boss_tag() then
    G.GAME.boss_reroll_button_text = "One Boss Tag"
  end
end

function uvdm_recreate_blind_prompt()
  G.blind_prompt_box:remove()
  G.blind_prompt_box = UIBox{
    definition =
      {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.O, config={object = DynaText({string = localize('ph_choose_blind_1'), colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.6, pop_in = 0.5, maxw = 5}), id = 'prompt_dynatext1'}}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.O, config={object = DynaText({string = localize('ph_choose_blind_2'), colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.7, pop_in = 0.5, maxw = 5, silent = true}), id = 'prompt_dynatext2'}}
        }},
        uvdm_get_boss_reroll_button()
      }},
    config = {align="cm", offset = {x=0,y=-15},major = G.HUD:get_UIE_by_ID('row_blind'), bond = 'Weak'}
  }
  G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    func = (function()
        G.blind_prompt_box.alignment.offset.y = 0
        return true
    end)
  }))
end

function uvdm_get_first_boss_tag()
  for _,v in ipairs(G.GAME.tags) do
    if v.name == 'Boss Tag' then
      return v
    end
  end
end
