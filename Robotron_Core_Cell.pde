enum CellType{
    WALL,
    EMPTY,
    PIT,
    ELECTRODE
}

class Wall extends Cell {
    public Wall(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, true, true, true);
    }
    
    void render() {
        imageMode(CENTER);
        tint(255);
        image(Graphics.wall, screenX, screenY, width, width);
    }
}

class Pit extends Cell {
    public Pit(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, false, true, false);
    }
    
    void render() {
        // Pits are just black squares.
        // If background(0) is used, then rendering anything here is not required.
        // rectMode(CENTER);
        // strokeWeight(0);
        // stroke(0);
        // fill(0);
        // rect(screenX, screenY, width, width);
    }
}

class Empty extends Cell {
    public Empty(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, false, false, false);
        
        // Update path finder if required.
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        if (levelManager.pathFinder != null) {
            levelManager.pathFinder.graph[gridY][gridX] = new AStarNode(gridY, gridX);
        }
    }
    
    void render() {
        imageMode(CENTER);
        tint(255);
        image(Graphics.floor, screenX, screenY, width, width);
    }
}

class Electrode extends Cell {
    public Electrode(int gridX, int gridY, int screenX, int screenY, int width) {
        super(gridX, gridY, screenX, screenY, width, true, true, true);
    }
    
    void collide(Character character) {
        character.damage(50);
        convert();
    }
    
    void convert() {
       ((Robotron)currentScene).levelManager.grid[gridY][gridX] = new Empty(gridX, gridY, screenX, screenY,(int)width);
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
    boolean solid;
    boolean impassable;
    boolean blocksVision;
    
    public Cell(int gridX, int gridY, int screenX, int screenY, int width, boolean solid, boolean impassable, boolean blocksVision) {
        this.gridX = gridX;
        this.gridY = gridY;
        this.screenX = screenX;
        this.screenY = screenY;
        this.width = width;
        this.solid = solid;
        this.impassable = impassable;
        this.blocksVision = blocksVision;
    }
    
    abstract void render();
}