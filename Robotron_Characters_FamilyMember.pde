class FamilyMember extends NPC {
    List<Character> threats;
    
    public FamilyMember(int x, int y) {
        super(x,y,Graphics.familyMember1Animator,100,0.005f,5,false,false);
       ((Robotron)currentScene).levelManager.FAMILY_MEMBERS.add(this);
        threats = new ArrayList<Character>();
        
        int randomFamilyMember = (int) random(3);
        switch(randomFamilyMember) {
            case 1:
                animator = Graphics.familyMember2Animator;
                points *= 2;
                break;
            case 2:
                animator = Graphics.familyMember3Animator;
                points *= 3;
                break;
        }
        if (animator != null) {
            currentStill = animator.downStill;
        }
    }
    
    void alert(Character threat) {
        if (!threats.contains(threat)) {
            //print("Alerting family member!\n");
            threats.add(threat);
            pathSearchPeriod = 0; // Path search immediately as a threat is added.
        }
    }
    
    boolean unalert(Character threat) {
        //print("Unalerting family member!\n");
        return threats.remove(threat);
    }
    
    void updatePath() {
        super.updatePath();
        if (!threats.isEmpty() && !canSeeTarget(((Robotron)currentScene).levelManager.player)) {
            pathSearchPeriod = 75; // Keep searching in small steps how to avoid the threats.
        }
    }
    
    PVector findNonCharacterTarget() {
        PVector normalSearch = super.findNonCharacterTarget();
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        if (!threats.isEmpty() && !canSeeTarget(levelManager.player)) {
            //print("Trying to find path away from threats!\n");
            
            // First check whether the normal search worked to evade threats.
            boolean evadesThreats = true;
            int screenX = levelManager.gridToScreenX((int) normalSearch.x);
            int screenY = levelManager.gridToScreenY((int) normalSearch.y);
            for (Character threat : threats) {
                float distanceFromTargetToThreat = new PVector(screenX, screenY).sub(threat.position).mag();
                float distanceFromCurrentToThreat = position.copy().sub(threat.position).mag();
                //print("Distance from target to threat: " + distanceFromTargetToThreat + ". Distance from current to threat: " + distanceFromCurrentToThreat + ".\n");
                if (distanceFromTargetToThreat < distanceFromCurrentToThreat) {
                    evadesThreats = false;
                    break;
                }
            }
            
            if (evadesThreats) {
                //print("Normal search evades threats! Following to target!\n");
                return normalSearch;
            }
            
            // If the normal search didn't work, check cells immediately next to the NPC.
            int gridX = levelManager.screenToGridX((int) position.x);
            int gridY = levelManager.screenToGridY((int) position.y);
            for (int cardinality = 0; cardinality < 4; cardinality++) {
                //print("Cardinality " + cardinality + "\n");
                int targetX = gridX;
                int targetY = gridY;
                switch(cardinality) {
                    case 1:
                        targetX += 1;
                        break;
                    case 2:
                        targetY += 1;
                        break;
                    case 3:
                        targetX -= 1;
                        break;
                    default:
                    targetY -= 1;
                }
                
                if (targetX < 0 || targetX >= levelManager.xSize || targetY < 0 || targetY >= levelManager.ySize) {
                    continue;
                }
                
                if (levelManager.grid[targetY][targetX].impassable) {
                    continue;
                }
                
                evadesThreats = true;
                for (Character threat : threats) {
                    float distanceFromTargetToThreat = new PVector(levelManager.gridToScreenX(targetX), levelManager.gridToScreenY(targetY)).sub(threat.position).mag();
                    float distanceFromCurrentToThreat = position.copy().sub(threat.position).mag();
                    //print("Distance from target to threat: " + distanceFromTargetToThreat + ". Distance from current to threat: " + distanceFromCurrentToThreat + ".\n");
                    if (distanceFromTargetToThreat < distanceFromCurrentToThreat) {
                        evadesThreats = false;
                        break;
                    }
                }
                if (!evadesThreats) {
                    continue;
                }
                //print("Evades threats! Following to target!\n");
                return new PVector(targetX, targetY);
            }
        }
        return normalSearch;
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).levelManager.FAMILY_MEMBERS.remove(this);
    }
    
    void update() {
        super.update();
        
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        if (levelManager.player.alive() && levelManager.player.position.copy().sub(position).mag() < size) {
            levelManager.addPoints(points);
            destroy();
        }
    }
}