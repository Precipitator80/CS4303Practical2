public abstract class NPC extends Character {
    int points;
    
    // Pathfinding
    double lastPathSearch;
    double pathSearchPeriod = 3000.0;
    ArrayList<AStarNode>thePath = new ArrayList<AStarNode>();
    boolean stationary;
    boolean attacksFamily;
    
    Character currentTarget;
    boolean canSeeTarget;
    boolean justSawTarget;
    
    public NPC(int x, int y, Animator animator, int hp, float movementSpeed, int points, boolean stationary, boolean attacksFamily) {
        super(x,y,animator,hp,movementSpeed);
        this.points = points;
        this.stationary = stationary;
        this.attacksFamily = attacksFamily;
    }
    
    boolean canSeeTarget(Character target) {
        if (target == null || !target.alive()) {
            return false;
        }
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        return levelManager.visionCheck((int)position.x,(int)position.y,(int)target.position.x,(int)target.position.y, false);
    }
    
    boolean canGoDirectlyToTarget(Character target) {
        if (target == null || !target.alive()) {
            return false;
        }
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        return levelManager.visionCheck((int)position.x,(int)position.y,(int)target.position.x,(int)target.position.y, true);
    }
    
    void despawn() {
        super.despawn();
        destroy();
    }
    
    // If the target can be seen and reached directly, go to them directly. No timing required.
    // If the target can be seen but not reached directly, go to them via A*. Timing required, but refresh immediately if path is empty.
    // If the target cannot be seen but has just been seen, go to them via A*. Timing required, but should be set immediately after losing target.
    // If the target cannot be seen and has not just been seen, pick a random spot to go to via A*. Timing required.       
    void update() {
        super.update();
        pathfinding();
    }
    
    void pathfinding() {
        visionCheck();
        
        if (!stationary) {
            // Go directly to the target if possible.
            if (currentTarget != null && canGoDirectlyToTarget(currentTarget)) {
                PVector distance = currentTarget.position.copy().sub(position);
                if (distance.mag() >= ((Robotron)currentScene).levelManager.cellSize / 5) {
                    velocity = distance.normalize().mult(movementSpeed * height);
                    thePath.clear();
                }
                else{
                    velocity.set(0,0);
                }
            }
            else{
                // Else, check for path update if the target was just seen and the path is empty or the timer has elapsed.
                // This means the AI should always have ap ath to the target when seen but not update every frame.
                double current = millis();
                if ((justSawTarget && thePath.isEmpty()) || current - lastPathSearch > pathSearchPeriod) {
                    /*
                    if (this instanceof FamilyMember) {
                    if (!((FamilyMember)this).threats.isEmpty()) {
                    print("Time since last path search: " + (current - lastPathSearch) + ". Path search period: " + pathSearchPeriod + ".\n");
                }
                }
                    */
                    updatePath();
                    lastPathSearch = current;
                }
                
                followPath();
            }
        }
    }
    
    void visionCheck() {
        if (currentTarget != null && currentTarget.destroyed()) {
            currentTarget = null;
        }
        
        if (currentTarget == null) {
            if (attacksFamily) {
                LevelManager levelManager = ((Robotron)currentScene).levelManager;
                for (FamilyMember familyMember : levelManager.FAMILY_MEMBERS) {
                    canSeeTarget = canSeeTarget(familyMember);
                    if (canSeeTarget) {
                        currentTarget = familyMember;
                        familyMember.alert(this);
                        break;
                    }
                }
            }
            if (currentTarget == null) {
                Player player = ((Robotron)currentScene).levelManager.player;
                canSeeTarget = canSeeTarget(player);
                if (canSeeTarget) {
                    currentTarget = player;
                }
            }            
        }
        else{   
            canSeeTarget = canSeeTarget(currentTarget);
            if (!canSeeTarget && currentTarget instanceof FamilyMember) {
               ((FamilyMember)currentTarget).unalert(this);
                currentTarget = null;
            }
        }
        
        if (canSeeTarget) {
            justSawTarget = true;
        }
    }
    
    void updatePath() {
        // Change the update period depending on whether the target was seen.
        pathSearchPeriod = justSawTarget ? 1500 : random(2000,5000);
        
        // If the target was just seen, overwrite the current path.
        // Else, only make a new path if the current one has been traversed.
        ArrayList<AStarNode>result;
        if (justSawTarget || thePath.isEmpty()) {
            LevelManager levelManager = ((Robotron)currentScene).levelManager;
            int x = levelManager.screenToGridX((int)position.x);
            int y = levelManager.screenToGridY((int)position.y);
            int targetX;
            int targetY;
            if (currentTarget != null && justSawTarget) {
                targetX = levelManager.screenToGridX((int)currentTarget.position.x);
                targetY = levelManager.screenToGridY((int)currentTarget.position.y);
                // Reset the target if the NPC lost sight of the target.
                if (!canSeeTarget) {
                    currentTarget = null;
                }
            }
            else{
                PVector targetCoords = findNonCharacterTarget();
                targetX = (int) targetCoords.x;
                targetY = (int) targetCoords.y;
            }
            justSawTarget = false;
            result = levelManager.pathFinder.search(y, x, targetY, targetX);
            if (result != null) {
                thePath = result;
            }
        }
    }
    
    PVector findNonCharacterTarget() {      
        // Find a target around the NPC.  
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        int targetX = levelManager.screenToGridX((int)position.x);
        targetX += random( -5,6);
        targetX = constrain(targetX,1, levelManager.xSize - 2);
        int targetY = levelManager.screenToGridY((int)position.y);
        targetY += random( -5,6);
        targetY = constrain(targetY,1, levelManager.ySize - 2);
        currentTarget = null;
        return new PVector(targetX, targetY);
    }
    
    void followPath() {
        if (!thePath.isEmpty()) {
            // Get velocity to next node.
            LevelManager levelManager = ((Robotron)currentScene).levelManager;
            AStarNode nextNode = thePath.get(thePath.size() - 1);
            velocity.set(levelManager.gridToScreenX(nextNode.getCol()),levelManager.gridToScreenY(nextNode.getRow()));
            velocity.sub(position);
            velocity.normalize();
            velocity.mult(movementSpeed * height);
            
            // If within a sufficient distance to the node, remove it from the list.
            float distanceToNext = new PVector(levelManager.gridToScreenX(nextNode.getCol()),levelManager.gridToScreenY(nextNode.getRow())).sub(position).mag();
            if (distanceToNext < levelManager.cellSize / 5) {
                thePath.remove(thePath.size() - 1);
                if (thePath.isEmpty()) {
                    velocity.set(0,0);
                }
            }
        }
    }
    
    void render() {
        super.render();
        if (DEBUG_MODE) {
            // Paint path
            if (!thePath.isEmpty()) {
                LevelManager levelManager = ((Robotron)currentScene).levelManager;
                float opacity = 150;
                strokeWeight(0);
                rectMode(CENTER);
                stroke(0,0,255,opacity);
                fill(0,0,255,opacity);
                for (AStarNode node : thePath)
                    rect(levelManager.gridToScreenX(node.getCol()), levelManager.gridToScreenY(node.getRow()), levelManager.cellSize, levelManager.cellSize);
                if (levelManager.pathFinder.visited != null) {
                    for (AStarNode node : levelManager.pathFinder.visited) {
                        if (!thePath.contains(node)) {
                            stroke(255,0,0,opacity);
                            fill(255,0,0,opacity);
                            rect(levelManager.gridToScreenX(node.getCol()), levelManager.gridToScreenY(node.getRow()), levelManager.cellSize, levelManager.cellSize);
                        }
                    }
                }
            }
        }
    }
}