return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.7.1",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 15,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 3,
  nextobjectid = 23,
  backgroundcolor = { 0, 0, 0 },
  properties = {},
  tilesets = {
    {
      name = "sprites",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "assets/graphics/sprites.png",
      imagewidth = 256,
      imageheight = 256,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {},
      tilecount = 256,
      tiles = {}
    },
    {
      name = "tiles",
      firstgid = 257,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "assets/graphics/tiles.png",
      imagewidth = 256,
      imageheight = 224,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {},
      tilecount = 224,
      tiles = {}
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "Sprites",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 64,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 9,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 80,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 10,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 96,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 11,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 112,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 12,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 128,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 13,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 144,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 14,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 2,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 64,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 3,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 80,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 15,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 80,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 16,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 96,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 17,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 112,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 18,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 128,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 19,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 144,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 4,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 96,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 5,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 112,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 6,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 128,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 7,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 144,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 8,
          name = "",
          type = "coin",
          shape = "rectangle",
          x = 160,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 272,
          visible = true,
          properties = {
            ["collision"] = "cross"
          }
        },
        {
          id = 21,
          name = "mario",
          type = "",
          shape = "rectangle",
          x = 24,
          y = 16,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 97,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "pipeexit",
          type = "",
          shape = "rectangle",
          x = 204,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 393,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 15,
      id = 1,
      name = "Collisions",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["collidable"] = true
      },
      encoding = "base64",
      compression = "zlib",
      data = "eJxTYmRAAUqMuDE6SMYhTiwY1T+qH10/pemPGP3mQLYFEFuSqd8dyPYAYk8gVhxgDADdgQ+u"
    }
  }
}
