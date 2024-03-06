class FamilyMember extends NPC {
    color familyColour = color(0,255,0);
    
    public FamilyMember(int x, int y) {
        super(x,y,0.005f,5);
    }
    
    void update() {
        super.update();
        
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        if (levelManager.player.position.copy().sub(position).mag() < size) {
            levelManager.addPoints(points);
            destroy();
        }
    }
    
    void render() {
        super.render();
        strokeWeight(0);
        stroke(familyColour);
        fill(familyColour);
        circle(position.x, position.y, size);
    }
}