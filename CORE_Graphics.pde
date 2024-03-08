public class Graphics {    
    PImage wall;
    PImage floor;
    PImage turretRobot;
    
    Animator playerAnimator;
    Animator gruntRobotAnimator;
    Animator laserRobotAnimator;
    Animator familyMember1Animator;
    
    PFont robotronFont;
    
    
    public Graphics() {
        load();
    }
    
    void load() {
        try{
            wall = loadImage("wall.png");
            floor = loadImage("floor.png");
            turretRobot = loadImage("turretRobot.png");
            
            playerAnimator = new Animator("Player");
            gruntRobotAnimator = new Animator("GruntRobot");
            laserRobotAnimator = new Animator("LaserRobot");
            familyMember1Animator = new Animator("FamilyMember1");
            
            robotronFont = createFont("robotron-2084.otf", 128);
            textFont(robotronFont);
        }
        catch(Exception e) {
            print(e.toString());
        }
    }
}