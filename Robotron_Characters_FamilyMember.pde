class FamilyMember extends NPC {
    color familyColour = color(0,255,0);
    
    public FamilyMember(int x, int y) {
        super(x,y,0.005f);
    }
    
    void update() {
        
    }
    
    void render() {
        super.render();
        strokeWeight(0);
        stroke(familyColour);
        fill(familyColour);
        circle(position.x, position.y, size);
    }
}