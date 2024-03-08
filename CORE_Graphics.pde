public class Graphics {    
    PImage wall;
    PImage floor;
    
    PFont robotronFont;
    
    Animator playerAnimator;
    Animator gruntAnimator;
    Animator familyMember1Animator;
    
    public Graphics() {
        load();
    }
    
    void load() {
        try{
            wall = loadImage("wall.png");
            floor = loadImage("floor.png");
            
            robotronFont = createFont("robotron-2084.otf", 128);
            textFont(robotronFont);
            
            playerAnimator = new Animator("Player");
            gruntAnimator = new Animator("Grunt");
            familyMember1Animator = new Animator("FamilyMember1");
        }
        catch(Exception e) {
            print(e.toString());
        }
    }
}