public class Graphics {
    String graphicsFolder = "Graphics/";
    PImage background;
    
    public Graphics() {
        load();
    }
    
    void load() {
        background = loadImageWithFolder("Background.png");
        background.resize(width, height);
    }
    
    PImage loadImageWithFolder(String fileName) {
        return loadImage(graphicsFolder + fileName);
    }
}