class FamilyMember extends NPC {
    color familyColour = color(0,255,0);
    
    public FamilyMember(int x, int y) {
        super(x,y,Graphics.familyMember1Animator,100,0.005f,5,false);
    }
    
    void update() {
        super.update();
        
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        if (levelManager.player.position.copy().sub(position).mag() < size) {
            levelManager.addPoints(points);
            destroy();
        }
    }
}