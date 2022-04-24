using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace WW3
{
    public class Game1 : Game
    {
        private GraphicsDeviceManager _graphics;
        private SpriteBatch _spriteBatch;

        Texture2D _human;
        Vector2 _humanPos=new Vector2();

        public Game1()
        {
            _graphics = new GraphicsDeviceManager(this);

            // not working - Change the resolution to 720p
            

            Content.RootDirectory = "Content";
            IsMouseVisible = true;
        }

        protected override void Initialize()
        {
            // TODO: Add your initialization logic here
            _graphics.PreferredBackBufferWidth = 1580;
            _graphics.PreferredBackBufferHeight = 720;
            _graphics.IsFullScreen = false;
            _graphics.ApplyChanges();

            base.Initialize();
        }

        protected override void LoadContent()
        {
            _spriteBatch = new SpriteBatch(GraphicsDevice);

            // TODO: use this.Content to load your game content here

            _human=Content.Load<Texture2D>("human");
        }

        protected override void Update(GameTime gameTime)
        {
            //GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed ||
            var kbState = Keyboard.GetState();
            if (kbState.IsKeyDown(Keys.Escape))
                Exit();

            if (kbState.IsKeyDown(Keys.Left))
            {
                _humanPos.X -= 1;
            }

            if (kbState.IsKeyDown(Keys.Right))
            {
                _humanPos.X += 1;
            }

            if (kbState.IsKeyDown(Keys.Up))
            {
                _humanPos.Y -= 1;
            }

            if (kbState.IsKeyDown(Keys.Down))
            {
                _humanPos.Y += 1;
            }



            // TODO: Add your update logic here

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(Color.CornflowerBlue);

            // TODO: Add your drawing code here

            _spriteBatch.Begin();
            _spriteBatch.Draw(_human, _humanPos, Color.White);
            _spriteBatch.End();

            base.Draw(gameTime);
        }
    }
}
