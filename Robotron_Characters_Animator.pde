class Animator {
    private final static float ANIMATION_SPEED = 0.1f;
    private final float SCALE;
    
    private PImage[] upFrames;
    private PImage upStill;
    
    private PImage[] rightFrames;
    private PImage rightStill;
    
    private PImage[] downFrames;
    private PImage downStill;
    
    private PImage[] leftFrames;
    private PImage leftStill;
    
    
    public Animator(String characterName) throws Exception {
        this(characterName, 1f);
    }
    
    public Animator(String characterName, float scale) throws Exception {
        this.SCALE = scale;
        
        downFrames = loadFrames(characterName, "down");
        downStill = loadImage(characterName + "/downStill.png");
        
        if (downFrames == null || downStill == null) {
            throw new Exception(characterName + " is an invalid animator! Must define at least down animated and still frames!");
        }
        
        upFrames = loadFrames(characterName, "up");
        upStill = loadImage(characterName + "/upStill.png");
        if (upStill == null) {
            upStill = downStill;
        }
        
        rightFrames = loadFrames(characterName, "right");
        rightStill = loadImage(characterName + "/rightStill.png");
        if (rightStill == null) {
            rightStill = downStill;
        }
        
        leftFrames = loadFrames(characterName, "left");
        leftStill = loadImage(characterName + "/leftStill.png");
        if (leftStill == null) {
            leftStill = downStill;
        }        
    }
    
    
    
    PImage[] loadFrames(String characterName, String frameName) {
        List<PImage> frames = new ArrayList<PImage>();
        int frameNumber = 1;
        String filePath = characterName + "/" + frameName + frameNumber + ".png";
        while(doesFileExist(filePath)) {
            frames.add(loadImage(filePath));
            frameNumber++;
            print("Loaded: " + filePath + "\n");
            filePath = characterName + "/" + frameName + frameNumber + ".png";
        }
        if (frames.isEmpty()) {
            return downFrames;
        }
        return frames.toArray(new PImage[0]);
    }
    
    // How do I check if a file exists before I used loadStrings() ? - Simplyfire - https://www.reddit.com/r/processing/comments/zf17g6/how_do_i_check_if_a_file_exists_before_i_used/ - Accessed 08.03.2024
    boolean doesFileExist(String filePath) {
        return new File(dataPath(filePath)).exists();
    }
}
