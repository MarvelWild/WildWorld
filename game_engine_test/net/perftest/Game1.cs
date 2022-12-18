using System;
using System.Collections.Generic;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace perftest;

public class Game1 : Game
{
    private GraphicsDeviceManager _graphics;
    private SpriteBatch _spriteBatch;

	private SpriteFont _font;
	private FrameCounter _frameCounter = new FrameCounter();
	private Texture2D _sprite;

	private List<Entity> _entities = new List<Entity>();

	private int _entity_count=200000;

    public Game1()
    {
        _graphics = new GraphicsDeviceManager(this);

		_graphics.PreferredBackBufferWidth = 800;
		_graphics.PreferredBackBufferHeight = 600;

		_graphics.SynchronizeWithVerticalRetrace = false;
 		IsFixedTimeStep = false;

		_graphics.ApplyChanges();

        Content.RootDirectory = "Content";
        IsMouseVisible = true;
    }

    protected override void Initialize()
    {
        // TODO: Add your initialization logic here

        base.Initialize();
    }

    protected override void LoadContent()
    {
        _spriteBatch = new SpriteBatch(GraphicsDevice);

        // TODO: use this.Content to load your game content here

		_font = Content.Load<SpriteFont>("font"); 
		_sprite = Content.Load<Texture2D>("test64");


		Random r = new Random();

		for (int i = 0; i < _entity_count; i++)
		{
			Entity e = new Entity();
			e.Pos=new System.Numerics.Vector2();
			e.Pos.X = r.Next(1,800);
			e.Pos.Y = r.Next(10,600);
			e.Sprite = _sprite;
			_entities.Add(e);
		}
    }

    protected override void Update(GameTime gameTime)
    {
        if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
            Exit();

        // TODO: Add your update logic here

        base.Update(gameTime);
    }

    protected override void Draw(GameTime gameTime)
    {
        GraphicsDevice.Clear(Color.CornflowerBlue);

        
    	var deltaTime = (float)gameTime.ElapsedGameTime.TotalSeconds;

         _frameCounter.Update(deltaTime);

         var fps = string.Format("FPS: {0}", _frameCounter.AverageFramesPerSecond);


		_spriteBatch.Begin();
        _spriteBatch.DrawString(_font, fps, new Vector2(1, 1), Color.Black);

		foreach (var entity in _entities)
		{
			_spriteBatch.Draw(entity.Sprite, entity.Pos, Color.White);
		}

		_spriteBatch.End();

        // other draw code here


        base.Draw(gameTime);
    }
}
