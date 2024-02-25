public class Robotron extends Scene {
    Player player;
    public final LinkedTransferQueue<Enemy> ENEMIES = new LinkedTransferQueue<Enemy>();
    LevelManager levelManager;
    
    public Robotron() {
        super(color(255), color(128));
        player = new Player(width / 2, height / 2);
        new Enemy(width / 4, height / 2);
        
        // 16 by 9 times 2
        levelManager = new LevelManager(32, 18);
        levelManager.spawnLevel();
    }
    
    void render() {
        // Background
        background(Graphics.background);
        
        // Render cells.
        levelManager.render();
        
        // Foreground
        super.render();
        
        // Show a message on the game's state to the player.
        fill(255);
        textSize(height / 25);
        textAlign(CENTER);
        text("Welcome to Robotron: 4303!\nPress enter to start the game.", width / 2, height / 2);
    }
    
    void mouseReleased() {
        super.mouseReleased();
        player.shoot();
    }
    
    void keyPressed() {
        player.checkMovementKeys(true);
    }
    
    void keyReleased() {
        player.checkMovementKeys(false);
    }
}

enum CellTypes{
    WALL,
    EMPTY,
    PIT,
    ELECTRODE
}

class LevelManager {
    private Cell[][] grid;
    private CellTypes[][] workingGrid;
    private int xSize;
    private int ySize;
    private int cellSize;
    private boolean spawnedLevel;
    
    public LevelManager(int xSize, int ySize) {
        this.xSize = xSize;
        this.ySize = ySize;
        this.cellSize = height / ySize;
        grid = new Cell[ySize][xSize];
        workingGrid = new CellTypes[ySize][xSize];
    }
    
    void spawnLevel() {
        spawnedLevel = false;
        
        // Split the level horizontally and vertically.
        
        
        
        
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
                    grid[y][x] = new Wall(x, y, gridToScreenX(x), gridToScreenY(y), cellSize);
                }
            }
        }
        
        
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