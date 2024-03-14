enum LevelState {
    WELCOME,
    LEVEL,
    POST_LEVEL,
    GAME_OVER
}

class LevelManager {
    // World parameters.
    private Cell[][] grid; // The grid of cells.
    private CellType[][] workingGrid; // A working grid of CellType enum for faster customisation.
    private int xSize; // The number of cells in the x direction.
    private int ySize; // The number of cells in the y direction.
    int numberOfChunksX = 3; // The number of chunk divisions in the x direction.
    int numberOfChunksY = 2; // The number of chunk divisions in the y direction.
    int chunkXSize; // The grid width of each chunk.
    int chunkYSize; // The grid height of each chunk.
    int wallWidth = 3; // The number of grid spaces a wall takes up in width.
    private int cellSize; // The size of a cell in pixels.
    private boolean spawnedLevel;
    AStarSearch pathFinder;
    int screenXOffset; // The amount of x screen space not used due to higher aspect ratio.
    int screenYOffset; // The amount of y screen space not used due to higher aspect ratio.
    int pointsMultiplier = 100;
    
    // Wave parameters.
    LevelState state = LevelState.WELCOME;
    int wave = 0;
    private int score = 0;
    
    
    Player player;
    public final LinkedTransferQueue<Enemy> ENEMIES = new LinkedTransferQueue<Enemy>();
    public final LinkedTransferQueue<FamilyMember> FAMILY_MEMBERS = new LinkedTransferQueue<FamilyMember>();
    
    public LevelManager(int xSize, int ySize) {
       ((Robotron)currentScene).levelManager = this;
        this.xSize = xSize;
        this.ySize = ySize;
        this.cellSize = height / ySize;
        if (width / cellSize < xSize) {
            cellSize = width / xSize;
        }
        grid = new Cell[ySize][xSize];
        workingGrid = new CellType[ySize][xSize];
        chunkXSize = (xSize - 2 - (numberOfChunksX - 1) * wallWidth) / numberOfChunksX;
        chunkYSize = (ySize - 2 - (numberOfChunksY - 1) * wallWidth) / numberOfChunksY;
        this.screenXOffset = (width - cellSize * xSize) / 2;
        this.screenYOffset = (height - cellSize * ySize) / 2;
    }
    
    Item spawnRandomItem(int x, int y) {
        if (fiftyFifty()) {// Spawn a weapon.
            return spawnRandomWeaponItem(x,y);
        }
        else{ // Spawn a power-up.
            return spawnRandomPowerUp(x,y);
        }
    }
    
    WeaponItem spawnRandomWeaponItem(int x, int y) {
        int random  = (int) random(4);
        WeaponItem item;
        switch(random) {
            case 0:
                item = new WeaponItem(x,y,PulseCannon.class);
                break;
            case 1:
                item = new WeaponItem(x,y,Railgun.class);
                break;
            case 2:
                item = new WeaponItem(x,y,EMPCannon.class);
                break;
            default:
            item = new WeaponItem(x,y,Rifle.class);
        }
        return item;
    }
    
    Item spawnRandomPowerUp(int x, int y) {
        int random = (int) random(3);
        Item item;
        switch(random) {
            case 0:
                item = new SpeedBoostItem(x,y);
                break;
            case 1:
                item = new DamageBoostItem(x,y);
                break;
            default:
            item = new FreezeItem(x,y);
        }
        return item;
    }
    
    boolean fiftyFifty() {
        return(int)random(2) == 1;
    }
    
    void fillAreaRandomX(CellType cellType, int xMin, int xMax, int size, int y1, int y2) {
        int randomX = (int) random(xMin, xMax - size);
        fillArea(cellType, randomX, randomX + size, y1, y2);
    }
    
    void fillAreaRandomY(CellType cellType, int yMin, int yMax, int size, int x1, int x2) {
        int randomY = (int) random(yMin, yMax - size);
        fillArea(cellType, x1, x2, randomY, randomY + size);
    }
    
    void fillArea(CellType cellType, int x1, int x2, int y1, int y2) {
        for (int y = y1; y <= y2; y++) {
            for (int x = x1; x <= x2; x++) {
                workingGrid[y][x] = cellType;
            }
        }
    }
    
    void spawnLevel() {
        spawnedLevel = false;
        workingGrid = new CellType[ySize][xSize];
        
        // Delete all lasers, NPCs and items.
        Iterator<GameObject> iterator = gameObjects().iterator();
        while(iterator.hasNext()) {
            GameObject gameObject = iterator.next();
            if (gameObject instanceof Laser || gameObject instanceof NPC || gameObject instanceof Item || gameObject instanceof StatusEffect) {
                if (gameObject instanceof FamilyMember && wave > 0) {
                    addPoints(((FamilyMember)gameObject).points);
                }
                gameObject.destroy();
            }
        }
        
        // Horizontal split 1
        if (fiftyFifty()) {
            // Add corridors / bridges.
            int x1 = xSize / numberOfChunksX - 1;
            int x2 = x1 + 2;
            fillAreaRandomY(CellType.EMPTY, 1, ySize / numberOfChunksY - 1,(int) random(1, 4), x1, x2);
            fillAreaRandomY(CellType.EMPTY, ySize / numberOfChunksY + 2, ySize - 1,(int) random(1, 4), x1, x2);
            
            // Add walls / pits next to the corridors / bridges.
            CellType cellType = fiftyFifty() ? CellType.WALL : CellType.PIT;
            for (int y = 0; y < ySize - 1; y++) {
                for (int x = x1; x <= x2; x++) {
                    // If the cell is a corridor / bridge, move until the next gap and repick the cell type to fill in.
                    if (workingGrid[y][x] != null && workingGrid[y][x] == CellType.EMPTY) {
                        do{
                            y++;
                        } while(workingGrid[y][x] != null && workingGrid[y][x] == CellType.EMPTY);
                        cellType = fiftyFifty() ? CellType.WALL : CellType.PIT;
                    }
                    workingGrid[y][x] = cellType;
                }
            }
        }
        
        // Split the level horizontally and vertically.
        // Vertical split
        if (fiftyFifty()) {
            // Add corridors / bridges.
            int y1 = ySize / numberOfChunksY - 1;
            int y2 = y1 + 2;
            fillAreaRandomX(CellType.EMPTY, 1, xSize / numberOfChunksX - 1,(int) random(1,4), y1, y2);
            fillAreaRandomX(CellType.EMPTY, xSize / numberOfChunksX + 2, 2 * xSize / numberOfChunksX - 1,(int) random(1,4), y1, y2);
            fillAreaRandomX(CellType.EMPTY, 2 * xSize /  numberOfChunksX + 2, xSize - 1,(int) random(1,4), y1, y2);
            
            // Add walls / pits next to the corridors / bridges.
            CellType cellType = fiftyFifty() ? CellType.WALL : CellType.PIT;
            for (int x = 0; x < xSize - 1; x++) {
                for (int y = y1; y <= y2; y++) {
                    // If the cell is a corridor / bridge, move until the next gap and repick the cell type to fill in.
                    if (workingGrid[y][x] != null && workingGrid[y][x] == CellType.EMPTY) {
                        do{
                            x++;
                        } while(workingGrid[y][x] != null && workingGrid[y][x] == CellType.EMPTY);
                        cellType = fiftyFifty() ? CellType.WALL : CellType.PIT;
                    }
                    workingGrid[y][x] = cellType;
                }
            }
        }
        
        // Horizontal split 2
        if (fiftyFifty()) {            
            // Add corridors / bridges.
            int x1 = 2 * xSize / numberOfChunksX - 1;
            int x2 = x1 + 2;
            fillAreaRandomY(CellType.EMPTY, 1, ySize / numberOfChunksY - 1,(int) random(1, 4), x1, x2);
            fillAreaRandomY(CellType.EMPTY, ySize / numberOfChunksY + 2, ySize - 1,(int) random(1, 4), x1, x2);
            
            // Add walls / pits next to the corridors / bridges.
            CellType cellType = fiftyFifty() ? CellType.WALL : CellType.PIT;
            for (int y = 0; y < ySize - 1; y++) {
                for (int x = x1; x <= x2; x++) {
                    // If the cell is a corridor / bridge, move until the next gap and repick the cell type to fill in.
                    if (workingGrid[y][x] != null && workingGrid[y][x] == CellType.EMPTY) {
                        do{
                            y++;
                        } while(workingGrid[y][x] != null && workingGrid[y][x] == CellType.EMPTY);
                        cellType = fiftyFifty() ? CellType.WALL : CellType.PIT;
                    }
                    workingGrid[y][x] = cellType;
                }
            }
        }
        
        // Draw a border around the level.
        fillArea(CellType.WALL, 0, xSize - 1, 0, 0);
        fillArea(CellType.WALL, 0, xSize - 1, ySize - 1, ySize - 1);
        fillArea(CellType.WALL, 0, 0, 0, ySize - 1);
        fillArea(CellType.WALL, xSize - 1, xSize - 1, 0, ySize - 1);
        
        // Spawn actual cells. Keep track of pits to spawn turrets later.
        List<Cell> pits = new ArrayList<>();
        for (int y = 0; y < ySize; y++) {
            for (int x = 0; x < xSize; x++) {
                if (workingGrid[y][x] != null) {
                    switch(workingGrid[y][x]) {
                        case EMPTY:
                            grid[y][x] = new Empty(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
                            break;
                        case PIT:
                            grid[y][x] = new Pit(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
                            pits.add(grid[y][x]);
                            break;
                        case ELECTRODE:
                            grid[y][x] = new Electrode(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
                            break;
                        default:
                        grid[y][x] = new Wall(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
                    }
                }
                else{
                    grid[y][x] = new Empty(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
                }
            }
        }
        
        // Initialise the path finder.
        pathFinder = new AStarSearch(grid);
        
       ((Robotron)currentScene).aStarTester = new AStarTester();
        
        // Designate chunks.
        // Initial idea:
        // 1 player chunk.
        // 1 enemy chunk (at least diagonal from player chunk).
        // 4 mixed chunks.
        Chunk[][] chunks = new Chunk[numberOfChunksY][numberOfChunksX];
        int randomX = (int)random(numberOfChunksX);
        int randomY = (int)random(numberOfChunksY);
        chunks[randomY][randomX] = new PlayerChunk(chunkToGridX(randomX), chunkToGridY(randomY));
        
        // Place mixed chunks adjacent to the player chunk.
        if (randomY - 1 >= 0) {
            chunks[randomY - 1][randomX] = new MixedChunk(chunkToGridX(randomX), chunkToGridY(randomY - 1));
        }
        if (randomY + 1 < numberOfChunksY) {
            chunks[randomY + 1][randomX] = new MixedChunk(chunkToGridX(randomX), chunkToGridY(randomY + 1));
        }
        if (randomX - 1 >= 0) {
            chunks[randomY][randomX - 1] = new MixedChunk(chunkToGridX(randomX - 1), chunkToGridY(randomY));
        }
        if (randomX + 1 < numberOfChunksX) {
            chunks[randomY][randomX + 1] = new MixedChunk(chunkToGridX(randomX + 1), chunkToGridY(randomY));
        }
        
        // Randomly choose one of the remaining chunks as the enemy chunk.
        List<PVector> remainingChunks = new ArrayList<>();
        for (int y = 0; y < numberOfChunksY; y++) {
            for (int x = 0; x < numberOfChunksX; x++) {
                if (chunks[y][x] == null) {
                    remainingChunks.add(new PVector(x, y));
                }
            }
        }
        int randomRemainingChunk = (int)random(remainingChunks.size());
        PVector enemyChunk = remainingChunks.get(randomRemainingChunk);
        chunks[(int)enemyChunk.y][(int)enemyChunk.x] = new EnemyChunk(chunkToGridX((int)enemyChunk.x), chunkToGridY((int)enemyChunk.y));
        remainingChunks.remove(randomRemainingChunk);
        
        // Assign any remaining chunks as mixed chunks.
        for (int i = 0; i < remainingChunks.size();i++) {
            PVector remainingChunk = remainingChunks.get(i);
            chunks[(int)remainingChunk.y][(int)remainingChunk.x] = new MixedChunk(chunkToGridX((int)remainingChunk.x),chunkToGridY((int)remainingChunk.y));
        }
        
        // Spawn turrets in pits.        
        if (pits.size() > 0) {
            int numberOfTurrets = (int) random(wave / 3);
            for (int i = 0; i < numberOfTurrets && i < pits.size() / 5; i++) {
                int randomPit = (int) random(pits.size());
                Cell pit = pits.get(randomPit);
                int enemyX = gridToScreenX(pit.gridX);
                int enemyY = gridToScreenY(pit.gridY);
                new TurretRobot(enemyX, enemyY);
            }
        }
        
        // Spawn other chunks.
        for (int y = 0; y < numberOfChunksY; y++) {
            for (int x = 0; x < numberOfChunksX; x++) {
                chunks[y][x].spawn();
            }
        }
        
        // Freeze all NPCs at the start of the round.
        iterator = gameObjects().iterator();
        while(iterator.hasNext()) {
            GameObject gameObject = iterator.next();
            if (gameObject instanceof NPC) {
                new Freeze((Character)gameObject,1000.0,false);
            }
        }
        
        wave++;
        state = LevelState.LEVEL;
        spawnedLevel = true;
    }
    
    public void addPoints(int points) {
        score += points * pointsMultiplier;
        player.livesGained = score / 25000 + player.startingLives;
    }
    
    void resetGame() {
        wave = 0;
        score = 0;
        player.reset();
       ((Robotron)currentScene).ShopMenu.resetListings();
    }
    
    void update() {
        switch(state) {
            case LEVEL:
                // Check for game over.
                if (!player.alive()) {
                    state = LevelState.GAME_OVER;
                }
                if (ENEMIES.isEmpty()) {
                   ((Robotron)currentScene).ShopMenu.entryButton.show();
                    state = LevelState.POST_LEVEL;
                }
                break;
        }
    }
    
    void render() {
        if (spawnedLevel) {
            for (int y = 0; y < ySize; y++) {
                for (int x = 0; x < xSize; x++) {
                    grid[y][x].render();
                }
            }
        }
    }
    
    public int gridToScreenX(int gridX) {
        return gridX * ((width - 2 * screenXOffset) / xSize) + screenXOffset + cellSize / 2;
    }
    
    public int gridToScreenY(int gridY) {
        return gridY * ((height - 2 * screenYOffset) / ySize) + screenYOffset + cellSize / 2;
    }
    
    public int screenToGridX(int screenX) {
        return constrain((screenX - screenXOffset) / cellSize, 0, xSize - 1);
    }
    
    public int screenToGridY(int screenY) {
        return constrain((screenY - screenYOffset) / cellSize, 0, ySize - 1);
    }
    
    int chunkToGridX(int chunkX) {
        return 1 + chunkX * (chunkXSize + wallWidth);
    }
    
    int chunkToGridY(int chunkY) {
        return 1 + chunkY * (chunkYSize + wallWidth);
    }
    
    boolean impassable(int screenX, int screenY) {
        int gridX = screenToGridX(screenX);
        int gridY = screenToGridY(screenY);
        return grid[gridY][gridX].impassable; 
    }
    
    boolean collisionCheck(int screenX, int screenY) {
        int gridX = screenToGridX(screenX);
        int gridY = screenToGridY(screenY);
        return grid[gridY][gridX].solid;
    }
    
    boolean visionCheck(int screenX, int screenY, int targetScreenX, int targetScreenY, boolean mustBeReachableDirectly) {
        PVector origin = new PVector(screenX, screenY);
        PVector differenceVector = new PVector(targetScreenX, targetScreenY).sub(origin);
        PVector normalisedDifferenceVector = differenceVector.copy().normalize().mult(cellSize);
        int numberOfIterations = (int)(differenceVector.mag() / cellSize);
        for (int i = 0; i < numberOfIterations; i++) {
            PVector positionToCheck = origin.copy().add(differenceVector);
            Cell cellToCheck = grid[screenToGridY((int)positionToCheck.y)][screenToGridX((int)positionToCheck.x)];
            if (cellToCheck.blocksVision || (mustBeReachableDirectly && cellToCheck.impassable)) {
                return false;
            }
            differenceVector.sub(normalisedDifferenceVector);
        }
        return true;
    }
}