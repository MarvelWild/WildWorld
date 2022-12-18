using System;

namespace WW3
{
    public static class Program
    {
        [STAThread]
        static void Main()
        {
            using (var game = new GameWw())
                game.Run();
        }
    }
}
