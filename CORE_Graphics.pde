public class Graphics {
    String graphicsFolder = "Graphics/";
    
    PImage wall;
    PImage floor;
    
    PFont robotronFont;
    
    public Graphics() {
        load();
    }
    
    void load() {        
        wall = loadImageWithFolder("wall.png");
        floor = loadImageWithFolder("floor.png");
        
        robotronFont = createFont(graphicsFolder + "robotron-2084.otf", 128);
        textFont(robotronFont);
    }
    
    PImage loadImageWithFolder(String fileName) {
        return loadImage(graphicsFolder + fileName);
    }
}