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
        int item3X = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int item3Y = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        new FreezeItem(item3X,item3Y);
        int item4X = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int item4Y = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        new DamageBoostItem(item4X,item4Y);
        int item5X = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int item5Y = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        new SpeedBoostItem(item5X,item5Y);
        
        // Spawn in enemies.
        int numberOfGrunts = 5 + (int) random(levelManager.wave);        
        for (int i = 0; i < numberOfGrunts; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new GruntRobot(enemyX, enemyY);
        }
        
        int numberOfLasers = (int) random(levelManager.wave / 3);
        for (int i = 0; i < numberOfLasers; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new LaserRobot(enemyX, enemyY);
        }
        
        int numberOfFlyings = (int) random(levelManager.wave / 3);
        for (int i = 0; i < numberOfFlyings; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new FlyingRobot(enemyX, enemyY);
        }
        
        int numberOfTurrets = (int) random(levelManager.wave / 3);
        for (int i = 0; i < numberOfTurrets / 10; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new TurretRobot(enemyX, enemyY);
        }
        
        int numberOfBrains = (int) random(levelManager.wave / 5);
        for (int i = 0; i < numberOfBrains; i++) {
            int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            new BrainRobot(enemyX, enemyY);
        }
        
        int numberOfWorms = (int) random(levelManager.wave / 4);
        for (int i = 0; i < numberOfWorms; i++) {
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
