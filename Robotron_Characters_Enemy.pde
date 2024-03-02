class Enemy extends Character {
    // General Things
    double lastShotTime;
    double shotPeriod = 3000.0;
    color enemyColour = color(255,0,0);
    
    // Pathfinding
    double lastPathSearch;
    double pathSearchPeriod = 3000.0;
    ArrayList<AStarNode>thePath = new ArrayList<AStarNode>();
    boolean justSawPlayer;
    
    public Enemy(int x, int y) {
        super(x,y,0.004f);
       ((Robotron)currentScene).levelManager.ENEMIES.add(this);
    }
    
    void shoot() {
        Player player = ((Robotron)currentScene).levelManager.player;
        float offsetRange = new PVector(player.position.x - position.x, player.position.y - position.y).mag() / 10;
        PVector target = new PVector(random(player.position.x - offsetRange, player.position.x + offsetRange), random(player.position.y - offsetRange, player.position.y + offsetRange));
        
        PVector shotVelocity = new PVector(target.x, target.y).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, 25, false, enemyColour);
        lastShotTime = millis();
    }
    
    boolean canSeePlayer() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        Player player = levelManager.player;
        if (!player.alive()) {
            return false;
        }
        return levelManager.visionCheck((int)position.x,(int)position.y,(int)player.position.x,(int)player.position.y, false);
    }
    
    boolean canGoDirectlyToPlayer() {
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        Player player = levelManager.player;
        if (!player.alive()) {
            return false;
        }
        return levelManager.visionCheck((int)position.x,(int)position.y,(int)player.position.x,(int)player.position.y, true);
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).levelManager.ENEMIES.remove(this);
    }
    
    void despawn() {
        destroy();
    }
    
    void update() {
        super.update();
        
        boolean canSeePlayer = canSeePlayer();
        double current = millis();
        
        // If the player can be seen and reached directly, go to them directly. No timing required.
        // If the player can be seen but not reached directly, go to them via A*. Timing required, but refresh immediately if path is empty.
        // If the player cannot be seen but has just been seen, go to them via A*. Timing required, but should be set immediately after losing player.
        // If the player cannot be seen and has not just been seen, pick a random spot to go to via A*. Timing required.       
        
        if (canSeePlayer) {
            justSawPlayer = true;
            if (current - lastShotTime > shotPeriod) {
                shoot();
            }
        }
        
        // Go directly to the player if possible.
        if (canGoDirectlyToPlayer()) {
            Player player = ((Robotron)currentScene).levelManager.player;
            velocity.set(player.position.x, player.position.y).sub(position).normalize().mult(movementSpeed * height);
            thePath.clear();
        }
        else{
            // Else, check for path update if the player was just seen and the path is empty or the timer has elapsed.
            // This means the AI should always have a path to the player when seen but not update every frame.
            if ((justSawPlayer && thePath.isEmpty()) || current - lastPathSearch > pathSearchPeriod) {
                // If the player was just seen, overwrite the current path.
                // Else, only make a new path if the current one has been traversed.
                ArrayList<AStarNode>result;
                if (justSawPlayer || thePath.isEmpty()) {
                    LevelManager levelManager = ((Robotron)currentScene).levelManager;
                    int x = levelManager.screenToGridX((int)position.x);
                    int y = levelManager.screenToGridY((int)position.y);
                    int targetX;
                    int targetY;
                    if (justSawPlayer) {
                        targetX = levelManager.screenToGridX((int)levelManager.player.position.x);
                        targetY = levelManager.screenToGridY((int)levelManager.player.position.y);
                        justSawPlayer = false;
                    }
                    else{
                        targetX = levelManager.screenToGridX((int)position.x);
                        targetX += random( -5,6);
                        targetY = levelManager.screenToGridY((int)position.y);
                        targetY += random( -5,6);
                    }
                    result = levelManager.pathFinder.search(y, x, targetY, targetX);
                    if (result != null) {
                        thePath = result;
                    }
                }
                lastPathSearch = current;
                // Change the update period depending on whether the player can be seen.
                pathSearchPeriod = canSeePlayer ? 1500 : random(2000,5000);
            }
            
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
    }
    
    void render() {
        strokeWeight(0);
        stroke(enemyColour);
        fill(enemyColour);
        circle(position.x, position.y, size);
        
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