{
  level = {
    entities = {
      humanoid = {
        [19] = {
          animation = {
            state = "walk",
            walk = { {
                duration = 30,
                sprite_name = "player_7_walk_1"
              }, {

duration = 30,
                sprite_name = "player_7_walk_2"
              } }
          },
          collisionX = 3,
          collisionY = 0,
          draw_layer = 0,
          energy = 90.180000000002,
          energy_max =
100,
          entity_name = "humanoid",
          footX = 7,
          footY = 15,
          h = 16,
          hp = 10,
          hp_max = 10,
          id = 19,
          is_movable = true,
          level_name = "start",
          name = "Joe",

riderX = 7,
          riderY = 11,
          sprite = "player_7",
          w = 16,
          x = 80.892660438773,
          y = 72.594752633364
        },
        [21] = {
          animation = {
            walk = { {
                duration
= 30,
                sprite_name = "player_7_walk_1"
              }, {
                duration = 30,
                sprite_name = "player_7_walk_2"
              } }
          },
          collisionX = 3,
          collisionY = 0,
          draw_layer
= 0,
          energy = 99.7,
          energy_max = 100,
          entity_name = "humanoid",
          footX = 7,
          footY = 15,
          h = 16,
          hp = 10,
          hp_max = 10,
          id = 21,
          level_name = "start",

name = "Joe",
          riderX = 7,
          riderY = 11,
          sprite = "player_7",
          w = 16,
          x = 100,
          y = 20
        }
      },
      player = {
        [9] = {
          controlled_entity_ref = {

entity_name = "humanoid",
            id = 19,
            level_name = "start"
          },
          draw_layer = 0,
          entity_name = "player",
          id = 9,
          level_name = "start",
          login = "defaultLogin",

name = "mw",
          shapeless = true
        },
        [10] = {
          controlled_entity_ref = {
            entity_name = "humanoid",
            id = 21,
            level_name = "start"
          },
          draw_layer =
0,
          entity_name = "player",
          id = 10,
          level_name = "start",
          login = "client1",
          name = "mw",
          shapeless = true
        }
      }
    },
    levelDescriptor = {
      bg = "main",

name = "start"
    },
    level_name = "start"
  }
}