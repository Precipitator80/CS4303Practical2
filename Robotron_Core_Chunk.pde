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
        
        int familyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int familyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        new FamilyMember(familyX, familyY);
    }
}

class EnemyChunk extends Chunk {
    public EnemyChunk(int gridStartX, int gridStartY) {
        super(gridStartX, gridStartY);
    }
    
    public void spawn() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        
        int item1X = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int item1Y = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        new WeaponItem(item1X,item1Y,Rifle.class);
        int item2X = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int item2Y = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        new WeaponItem(item2X,item2Y,Pistol.class);
        
        // Spawn in enemies.        
        for (int i = 0; i < levelManager.numberOfEnemies / 2; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new GruntRobot(enemyX, enemyY);
        }
        
        for (int i = 0; i < levelManager.numberOfEnemies / 10; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new LaserRobot(enemyX, enemyY);
        }
        
        for (int i = 0; i < levelManager.numberOfEnemies / 10; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new FlyingRobot(enemyX, enemyY);
        }
        
        for (int i = 0; i < levelManager.numberOfEnemies / 10; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new TurretRobot(enemyX, enemyY);
        }
        
        for (int i = 0; i < levelManager.numberOfEnemies / 10; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new BrainRobot(enemyX, enemyY);
        }
        
        for (int i = 0; i < levelManager.numberOfEnemies / 10; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new WormRobot(enemyX, enemyY);
        }
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
