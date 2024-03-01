class Enemy extends Character {
    // General Things
    double lastShotTime;
    double shotPeriod = 3000.0;
    color enemyColour = color(255,0,0);
    
    // Pathfinding
    double lastPathSearch;
    double pathSearchPeriod = 3000.0;
    ArrayList<AStarNode>thePath = new ArrayList<AStarNode>();
    
    public Enemy(int x, int y) {
        super(x,y,0.004f);
       ((Robotron)currentScene).ENEMIES.add(this);
    }
    
    void shoot() {
        Player player = ((Robotron)currentScene).player;
        float offsetRange = new PVector(player.position.x - position.x, player.position.y - position.y).mag() / 10;
        PVector target = new PVector(random(player.position.x - offsetRange, player.position.x + offsetRange), random(player.position.y - offsetRange, player.position.y + offsetRange));
        
        PVector shotVelocity = new PVector(target.x, target.y).sub(position.x, position.y);
        shotVelocity.normalize();
        shotVelocity.mult(0.015f * height);
        
        new Laser((int)position.x,(int)position.y, shotVelocity, 25, false, enemyColour);
        lastShotTime = millis();
    }
    
    boolean canSeePlayer() {
        return true; // Nothing special for now.
    }
    
    boolean canGoDirectlyToPlayer() {
        if (!canSeePlayer()) {
            return false;
        }
        return true;
    }
    
    void destroy() {
        super.destroy();
       ((Robotron)currentScene).ENEMIES.remove(this);
    }
    
    void update() {
        super.update();
        
        boolean canSeePlayer = canSeePlayer();
        double current = millis();
        
        
        if (canSeePlayer) {
            if (current - lastShotTime > shotPeriod) {
                shoot();
            }
        }
        
        if (canGoDirectlyToPlayer()) {
            Player player = ((Robotron)currentScene).player;
            velocity.set(player.position.x, player.position.y).sub(position).normalize().mult(movementSpeed * height);
        }
        else{
            if (current - lastPathSearch > pathSearchPeriod) {
                // If the player can be seen, overwrite the current path.
                // Else, only make a new path if the current one has been traversed.
                ArrayList<AStarNode>result;
                if (canSeePlayer || thePath.isEmpty()) {
                    Robotron robotron = ((Robotron)currentScene);
                    int x = robotron.levelManager.screenToGridX((int)position.x);
                    int y = robotron.levelManager.screenToGridY((int)position.y);
                    int targetX;
                    int targetY;
                    if (canSeePlayer) {
                        targetX = robotron.levelManager.screenToGridX((int)robotron.player.position.x);
                        targetY = robotron.levelManager.screenToGridY((int)robotron.player.position.y);
                    }
                    else{
                        targetX = robotron.levelManager.screenToGridX((int)position.x);
                        targetX += random( -5,6);
                        targetY = robotron.levelManager.screenToGridY((int)position.y);
                        targetY += random( -5,6);
                    }
                    result = robotron.levelManager.pathFinder.search(y, x, targetY, targetX);
                    if (result != null) {
                        thePath = result;
                    }
                }   
                lastPathSearch = current;
            }
            
            if (!thePath.isEmpty()) {
                // Get velocity to next node.
                LevelManager levelManager = ((Robotron)currentScene).levelManager;
                AStarNode nextNode = thePath.get(thePath.size() - 1);
                velocity.set(levelManager.gridToScreenX(nextNode.getCol()),levelManager.gridToScreenY(nextNode.getRow()));
                velocity.sub(position);
                velocity.normalize();
                velocity.mult(movementSpeed * height);
                print("Enemy velocity: " + velocity);
                
                
                // If within a sufficient distance to the node, remove it from the list.
                float distanceToNext = new PVector(levelManager.gridToScreenX(nextNode.getCol()),levelManager.gridToScreenY(nextNode.getRow())).sub(position).mag();
                if (distanceToNext < levelManager.cellSize / 2) {
                    thePath.remove(thePath.size() - 1);
                }
            }
        }
    }
    
    void render() {
        strokeWeight(0);
        stroke(enemyColour);
        fill(enemyColour);
        circle(position.x, position.y, size);
        
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