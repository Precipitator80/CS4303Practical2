public class Graphics {
    String graphicsFolder = "Graphics/";
    
    PImage wall;
    PImage floor;
    
    PFont robotronFont;
    
    Animator familyMember1Animator;
    
    public Graphics() {
        load();
    }
    
    void load() {        
        wall = loadImageWithFolder("wall.png");
        floor = loadImageWithFolder("floor.png");
        
        robotronFont = createFont(graphicsFolder + "robotron-2084.otf", 128);
        textFont(robotronFont);
        
        familyMember1Animator = loadAnimator("FamilyMember1");
    }
    
    PImage loadImageWithFolder(String fileName) {
        return loadImage(graphicsFolder + fileName);
    }
    
    Animator loadAnimator(String characterName) {
        PImage[] upFrames = loadFrames(characterName, "up");
        PImage upStill = loadImage(graphicsFolder + characterName + "/upStill.png");
        
        PImage[] rightFrames = loadFrames(characterName, "right");
        PImage rightStill = loadImage(graphicsFolder + characterName + "/rightStill.png");
        
        PImage[] downFrames = loadFrames(characterName, "down");
        PImage downStill = loadImage(graphicsFolder + characterName + "/downStill.png");
        
        PImage[] leftFrames = loadFrames(characterName, "left");
        PImage leftStill = loadImage(graphicsFolder + characterName + "/leftStill.png");
        
        return new Animator(upFrames, upStill, rightFrames, rightStill, downFrames, downStill, leftFrames, leftStill);
    }
    
    PImage[] loadFrames(String characterName, String frameName) {
        List<PImage> frames = new ArrayList<PImage>();
        int frameNumber = 1;
        String filePath = graphicsFolder + characterName + "/" + frameName + frameNumber + ".png";
        while(doesFileExist(filePath)) {
            frames.add(loadImage(filePath));
            frameNumber++;
            filePath = graphicsFolder + characterName + "/" + frameName + frameNumber + ".png";
        }
        return(PImage[])frames.toArray();
    }
    
    // How do I check if a file exists before I used loadStrings() ? - Simplyfire - https://www.reddit.com/r/processing/comments/zf17g6/how_do_i_check_if_a_file_exists_before_i_used/ - Accessed 08.03.2024
    boolean doesFileExist(String filePath) {
        return new File(dataPath(filePath)).exists();
    }
}