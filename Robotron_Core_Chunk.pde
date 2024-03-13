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
        
        // Spawn a power-up.
        int itemX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int itemY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        levelManager.spawnRandomPowerUp(itemX, itemY);
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
        
        // 50 / 50 to spawn an item.
        if (levelManager.fiftyFifty()) {
            int itemX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
            int itemY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
            levelManager.spawnRandomItem(itemX, itemY);
        }
        
        // 50 / 50 to spawn enemies.
        if (levelManager.fiftyFifty()) {
            int randomEnemy = (int) random(10);
            switch(randomEnemy) {
                case 0:
                    int numberOfLasers = (int) random(levelManager.wave / 6);
                    for (int i = 0; i < numberOfLasers; i++) {
                        int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
                        int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
                        new LaserRobot(enemyX, enemyY);
                    }
                    break;
                case 1:
                    int numberOfFlyings = (int) random(levelManager.wave / 6);
                    for (int i = 0; i < numberOfFlyings; i++) {
                        int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
                        int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
                        new FlyingRobot(enemyX, enemyY);
                    }
                    break;
                case 2:
                    int numberOfTurrets = (int) random(levelManager.wave / 10);
                    for (int i = 0; i < numberOfTurrets; i++) {
                        int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
                        int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
                        new TurretRobot(enemyX, enemyY);
                    }
                    break;
                case 3:
                    int numberOfBrains = (int) random(levelManager.wave / 10);
                    for (int i = 0; i < numberOfBrains; i++) {
                        int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
                        int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
                        new BrainRobot(enemyX, enemyY);
                    }
                    break;
                case 4:
                    int numberOfWorms = (int) random(levelManager.wave / 8);
                    for (int i = 0; i < numberOfWorms; i++) {
                        int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
                        int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
                        new WormRobot(enemyX, enemyY);
                    }
                    break;
                default:
                int numberOfGrunts = (int)(2.5f + random(levelManager.wave / 2));
                for (int i = 0; i < numberOfGrunts; i++) {
                    int enemyX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
                    int enemyY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
                    new GruntRobot(enemyX, enemyY);
                }
            }
        }
    }
}

class EnemyChunk extends Chunk {
    public EnemyChunk(int gridStartX, int gridStartY) {
        super(gridStartX, gridStartY);
    }
    
    public void spawn() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        
        int itemX = levelManager.gridToScreenX(gridStartX + (int)random(levelManager.chunkXSize));
        int itemY = levelManager.gridToScreenY(gridStartY + (int)random(levelManager.chunkYSize));
        levelManager.spawnRandomWeaponItem(itemX, itemY);
        
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
        
        int numberOfTurrets = (int) random(levelManager.wave / 10);
        for (int i = 0; i < numberOfTurrets; i++) {
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
