class PlayerChunk extends Chunk {
    public PlayerChunk(int gridStartX, int gridStartY) {
        super(gridStartX, gridStartY);
    }
    
    public void spawn() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        
        // Spawn in the player.
        int playerX = levelManager.gridToScreenX(gridStartX + levelManager.chunkXSize / 2);
        int playerY = levelManager.gridToScreenY(gridStartY + levelManager.chunkYSize / 2);
        if (levelManager.player == null) {
            levelManager.player = new Player(playerX, playerY);
        }
        else{
            levelManager.player.respawn(playerX, playerY);
        }
    }
}

class MixedChunk extends Chunk {
    public MixedChunk(int gridStartX, int gridStartY) {
        super(gridStartX, gridStartY);
    }
    
    public void spawn() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        
    }
}

class EnemyChunk extends Chunk {
    public EnemyChunk(int gridStartX, int gridStartY) {
        super(gridStartX, gridStartY);
    }
    
    public void spawn() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        
        // Spawn in enemies.
        int enemyX = levelManager.gridToScreenX(gridStartX + levelManager.chunkXSize / 2);
        int enemyY = levelManager.gridToScreenY(gridStartY + levelManager.chunkYSize / 2);
        new Enemy(enemyX, enemyY);
    }
}

abstract class Chunk {
    int gridStartX;
    int gridStartY;
    
    public Chunk(int gridStartX, int gridStartY) {
        this.gridStartX = gridStartX;
        this.gridStartY = gridStartY;
    }
    
    public abstract void spawn();
}
