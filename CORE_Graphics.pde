public class Graphics {
    String graphicsFolder = "Graphics/";
    PImage background;
    PFont robotronFont;
    
    public Graphics() {
        load();
    }
    
    void load() {
        background = loadImageWithFolder("Background.png");
        background.resize(width, height);
        
        robotronFont = createFont(graphicsFolder + "robotron-2084.otf", 128);
        textFont(robotronFont);
    }
    
    PImage loadImageWithFolder(String fileName) {
        return loadImage(graphicsFolder + fileName);
    }
}