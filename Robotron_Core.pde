public class Robotron extends Scene {
    Player player;
    public final LinkedTransferQueue<Enemy> ENEMIES = new LinkedTransferQueue<Enemy>();
    LevelManager levelManager;
    
    AStarTester aStarTester;
    
    public Robotron() {
        super(color(255), color(128));
        player = new Player(width / 6, height / 4);
        new Enemy(5 * width / 6, 3 * height / 4);
        
        // 16 by 9 times 2
        levelManager = new LevelManager(32, 18);
        levelManager.spawnLevel();
    }
    
    void update() {
        super.update();
        if (BUTTON_MANAGER.mouseDown && player.currentWeapon.automatic) {
            player.currentWeapon.tryToFire(mouseX, mouseY);
        }
    }
    
    void render() {
        // Background
        background(Graphics.background);
        
        // Render cells.
        levelManager.render();
        
        // Foreground
        super.render();
        
        aStarTester.render();
        
        // Show a message on the game's state to the player.
        fill(255);
        textSize(height / 25);
        textAlign(CENTER);
        text("Welcome to Robotron: 4303!\nPress enter to start the game.", width / 2, height / 2);
    }
    
    void mousePressed() {
        super.mousePressed();
        player.currentWeapon.tryToFire(mouseX, mouseY);
    }
    
    void mouseReleased() {
        super.mouseReleased();
        aStarTester.mouseReleased();
    }
    
    void keyPressed() {
        player.checkMovementKeys(true);
    }
    
    void keyReleased() {
        player.checkMovementKeys(false);
        if (key == ' ') {
            levelManager.spawnLevel();
        }
        aStarTester.keyReleased();
    }
}

enum CellType{
    WALL,
    EMPTY,
    PIT,
    ELECTRODE
}

class LevelManager {
    private Cell[][] grid;
    private CellType[][] workingGrid;
    private int xSize;
    private int ySize;
    private int cellSize;
    private boolean spawnedLevel;
    AStarSearch pathFinder;
    
    public LevelManager(int xSize, int ySize) {
        this.xSize = xSize;
        this.ySize = ySize;
        this.cellSize = height / ySize;
        grid = new Cell[ySize][xSize];
        workingGrid = new CellType[ySize][xSize];
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
        
        // Horizontal split 1
        if (fiftyFifty()) {
            // Add corridors / bridges.
            int x1 = xSize / 3 - 1;
            int x2 = x1 + 2;
            fillAreaRandomY(CellType.EMPTY, 1, ySize / 2 - 1,(int) random(1, 4), x1, x2);
            fillAreaRandomY(CellType.EMPTY, ySize / 2 + 2, ySize - 1,(int) random(1, 4), x1, x2);
            
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
            int y1 = ySize / 2 - 1;
            int y2 = y1 + 2;
            fillAreaRandomX(CellType.EMPTY, 1, xSize / 3 - 1,(int) random(1,4), y1, y2);
            fillAreaRandomX(CellType.EMPTY, xSize / 3 + 2, 2 * xSize / 3 - 1,(int) random(1,4), y1, y2);
            fillAreaRandomX(CellType.EMPTY, 2 * xSize / 3 + 2, xSize - 1,(int) random(1,4), y1, y2);
            
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
            int x1 = 2 * xSize / 3 - 1;
            int x2 = x1 + 2;
            fillAreaRandomY(CellType.EMPTY, 1, ySize / 2 - 1,(int) random(1, 4), x1, x2);
            fillAreaRandomY(CellType.EMPTY, ySize / 2 + 2, ySize - 1,(int) random(1, 4), x1, x2);
            
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
        
        // Spawn actual cells.
        for (int y = 0; y < ySize; y++) {
            for (int x = 0; x < xSize; x++) {
                if (workingGrid[y][x] != null) {
                    switch(workingGrid[y][x]) {
                        case EMPTY:
                            grid[y][x] = new Empty(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
                            break;
                        case PIT:
                            grid[y][x] = new Pit(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
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
        
        pathFinder = new AStarSearch(grid);
       ((Robotron)currentScene).aStarTester = new AStarTester();
        spawnedLevel = true;
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
        return gridX * (width / xSize) + cellSize / 2;
    }
    
    public int gridToScreenY(int gridY) {
        return gridY * (height / ySize) + cellSize / 2;
    }
    
    public int screenToGridX(int screenX) {
        return constrain(screenX / cellSize, 0, xSize - 1);
    }
    
    public int screenToGridY(int screenY) {
        return constrain(screenY / cellSize, 0, ySize - 1);
    }
    
    boolean insideOfWall(int screenX, int screenY) {
        return collisionCheck(screenX, screenY, true);
    }
    
    boolean inaccessible(int screenX, int screenY) {
        return collisionCheck(screenX, screenY, false);
    }
    
    boolean collisionCheck(int screenX, int screenY, boolean onlyCheckWalls) {
        int gridX = screenToGridX(screenX);
        int gridY = screenToGridY(screenY);
        CellType cellType = workingGrid[gridY][gridX];
        return cellType != null && (cellType == CellType.WALL || !onlyCheckWalls && cellType == CellType.PIT);
    }
}

class Wall extends Cell {
    public Wall(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, true, true);
    }
    
    void render() {
        imageMode(CENTER);
        image(Graphics.wall, screenX, screenY, width, width);
    }
}

class Pit extends Cell {
    public Pit(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, true, false);
    }
    
    void render() {
        // Pits are just black squares.
        rectMode(CENTER);
        strokeWeight(0);
        stroke(0);
        fill(0);
        rect(screenX, screenY, width, width);
    }
}

class Empty extends Cell {
    public Empty(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, false, false);
    }
    
    void render() {
        imageMode(CENTER);
        image(Graphics.floor, screenX, screenY, width, width);
    }
}

class Electrode extends Cell {
    public Electrode(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, true, true);
    }
    
    void render() {
        // Red square for now.
        rectMode(CENTER);
        strokeWeight(0);
        stroke(255,0,0);
        fill(255,0,0);
        rect(screenX, screenY, width, width);
    }
}

abstract class Cell {
    int gridX;
    int gridY;
    int screenX;
    int screenY;
    float width;
    boolean impassable;
    boolean blocksVision;
    
    public Cell(int gridX, int gridY, int screenX, int screenY, int width, boolean impassable, boolean blocksVision) {
        this.gridX = gridX;
        this.gridY = gridY;
        this.screenX = screenX;
        this.screenY = screenY;
        this.width = width;
        this.impassable = impassable;
        this.blocksVision = blocksVision;
    }
    
    abstract void render();
}