enum CellType{
    WALL,
    EMPTY,
    PIT,
    ELECTRODE
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