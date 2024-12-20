require ("util")

local function reactor_pictures()
  return
  {
    layers =
    {
      util.sprite_load("__fusion-thruster__/graphics/fusion-thruster-reactor/fusion-thruster-reactor-main",
      {
        priority = "high",
        scale = 0.5
      }),
      util.sprite_load("__space-age__/graphics/entity/fusion-reactor/fusion-reactor-shadow",
      {
        priority = "high",
        draw_as_shadow = true,
        scale = 0.5
      }),
    }
  }
end

local function reactor_glow_pictures()
  return
  {
    layers =
    {
      util.sprite_load("__space-age__/graphics/entity/fusion-reactor/fusion-reactor-glow",
      {
        priority = "high",
        blend_mode = "additive",
        draw_as_glow = true,
        scale = 0.5
      })
    }
  }
end

local function reactor_connection_pictures(num, plasma_uv_shift)

  local shadow = nil
  if num < 7 then
    shadow = util.sprite_load("__space-age__/graphics/entity/fusion-reactor/fusion-reactor-connection-" .. num .. "-shadow",
    {
      priority = "high",
      draw_as_shadow = true,
      scale = 0.5,
      frame_count = 5
    })
  end
  return
  {
    pictures =
    {
      layers =
      {
        util.sprite_load("__space-age__/graphics/entity/fusion-reactor/fusion-reactor-connection-" .. num,
        {
          priority = "high",
          scale = 0.5,
          frame_count = 5
        }),
        shadow
      },
    },
    working_light_pictures =
    {
      layers =
      {
        util.sprite_load("__space-age__/graphics/entity/fusion-reactor/fusion-reactor-connection-" .. num .. "-glow",
        {
          priority = "high",
          blend_mode = "additive",
          draw_as_glow = true,
          scale = 0.5,
          frame_count = 5
        }),
      }
    },
    fusion_effect_uv_map =
    {
      filename = "__space-age__/graphics/entity/fusion-reactor/fusion-reactor-connection-" .. num .. "-plasma-UV.png",
      width = 64,
      height = 64,
      shift = plasma_uv_shift,
      priority = "extra-high",
      scale = 0.5
    },
  }
end

return
{
  reactor_graphics_set =
  {
    use_fuel_glow_color = false,
    default_fuel_glow_color = {1,0,0.4,1},
    fusion_effect_uv_map =
    {
      filename = "__space-age__/graphics/entity/fusion-reactor/plasma-UV.png",
      width = 384,
      height = 384,
      shift = {0,0},
      dice_x = 2,
      dice_y = 5,
      priority = "extra-high",
      scale = 0.5
    },
    structure = reactor_pictures(),
    working_light_pictures = reactor_glow_pictures(),
    connections_graphics =
    {
      reactor_connection_pictures(1, { -1.5, -3 }),
      reactor_connection_pictures(2, {  1.5, -3 }),
      reactor_connection_pictures(3, {  2.5, -2.5 }),
      reactor_connection_pictures(4, {  2.5,  0.5 }),
      reactor_connection_pictures(5, {  1.5,  2 }),
      reactor_connection_pictures(6, { -1.5,  2 }),
      reactor_connection_pictures(7, { -2.5,  0.5 }),
      reactor_connection_pictures(8, { -2.5, -2   })
    },
    direction_to_connections_graphics =
    {
      north = { 1, 2, 3, 4, 5, 6, 7, 8 },
      east = { 3, 4, 5, 6, 7, 8, 1, 2 }
    },
    plasma_category = "fusion-reactor-plasma"
  }
}
