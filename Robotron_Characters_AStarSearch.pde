import java.util.Collections;

public class AStarSearch {
    //Graph represented as an array. This will make querying adjacent nodes easy.
    private AStarNode[][] graph;
    //The open list, from which we will pluck the next node at each iteration
    private ArrayList<AStarNode>open;
    
    public ArrayList<AStarNode>visited;
    
    //The constructor takes in the game map and builds the graph
    public AStarSearch(int[][] map) {
        graph = new AStarNode[map.length][];
        for (int row = 0; row < map.length; row++) {
            graph[row] = new AStarNode[map[row].length];
            for (int col = 0; col < map[row].length; col++) {
                if (map[row][col] ==  1)
                    graph[row][col] = new AStarNode(row, col);
                else 
                    graph[row][col] = null;
            }
        }   
    }
    
    public AStarSearch(Cell[][] map) {
        graph = new AStarNode[map.length][];
        for (int row = 0; row < map.length; row++) {
            graph[row] = new AStarNode[map[row].length];
            for (int col = 0; col < map[row].length; col++) {
                if (!map[row][col].impassable && !map[row][col].blocksVision)
                    graph[row][col] = new AStarNode(row, col);
                else 
                    graph[row][col] = null;
            }
        } 
    }
    
    //resets ready for a new search. Avoids lots of object reconstruction
    private void reset() {
        for (int row = 0; row < graph.length; row++) {    
            for (int col = 0; col < graph[row].length; col++) {
                if (graph[row][col] != null)
                    graph[row][col].reset();
            } 
        }
    }  
    
    //Process a node adjacent to the current node
    private void process(AStarNode currentNode, AStarNode adjacentNode, int goalRow, int goalCol, int newCost) {
        // if node is null then there was a wall in the visited direction
        // if node is closed nothing to do
        if (adjacentNode == null || adjacentNode.closed) {
            return;
        }
        
        // If node is unvisited, add it to the open list and calculate its initial values.
        // Else,just check whether to update the cost and previous node.
        if (!adjacentNode.isVisited()) {
            // Addit to the open list (and visited list for painting later).
            open.add(adjacentNode);
            visited.add(adjacentNode);
            
            // Setitsinitial values.
            adjacentNode.makeEstimate(goalRow, goalCol);
            adjacentNode.setCost(newCost);
            adjacentNode.setPrevNode(currentNode);
            
            // Setit as visited.
            adjacentNode.setVisited();
        }
        else if (adjacentNode.getCost() > newCost) {
            // Updatethe cost and previous node.
            adjacentNode.setCost(newCost);
            adjacentNode.setPrevNode(currentNode);
        }
    }
    
    //returns true if goal node is the first thing on the open list
    //Otherwise processes adjacent nodes
    private boolean searchIteration(int goalRow, int goalCol) {
        Collections.sort(open);
        AStarNode currentNode = open.remove(0);
        // if this is the goal node we are done.    
        if (currentNode.hasCoords(goalRow, goalCol))
            return true;
        // Iterate over reachable nodes.
        int currRow = currentNode.getRow();
        int currCol = currentNode.getCol();
        int newCost = currentNode.getCost() + 1;
        // Process adjacent nodes.
        process(currentNode, graph[currRow + 1][currCol], goalRow, goalCol, newCost);
        process(currentNode, graph[currRow][currCol + 1], goalRow, goalCol, newCost);
        process(currentNode, graph[currRow - 1][currCol], goalRow, goalCol, newCost);
        process(currentNode, graph[currRow][currCol - 1], goalRow, goalCol, newCost);
        
        // Extra code to allow diagonal paths.
        // int diagonalCost = newCost; // Can set diagonal cost to be 1 higher to encourage diagonal jumps when there are no adjacent cells.
        // process(currentNode, graph[currRow + 1][currCol + 1], goalRow, goalCol, diagonalCost);
        // process(currentNode, graph[currRow - 1][currCol + 1], goalRow, goalCol, diagonalCost);
        // process(currentNode, graph[currRow + 1][currCol - 1], goalRow, goalCol, diagonalCost);
        // process(currentNode, graph[currRow - 1][currCol - 1], goalRow, goalCol, diagonalCost);
        
        // This nodenow done and can be closed  
        currentNode.close(); 
        return false;
    }
    
    //Extract path by tracing the prevNode fields of AStarNode
    private ArrayList<AStarNode> extractPath(int sourceRow, int sourceCol, int goalRow, int goalCol) {
        ArrayList<AStarNode>path = new ArrayList<AStarNode>();
        AStarNode currNode = graph[goalRow][goalCol];
        do {
            path.add(currNode); 
            currNode = currNode.getPrevNode();
        } while(currNode!= null);
        return path;
    }
    
    // Start the A * search for a path between the specified points
    public ArrayList <AStarNode> search(int sourceRow, int sourceCol, int goalRow, int goalCol) {
        reset();
        // initialise the open list
        open = new ArrayList<AStarNode>();
        visited = new ArrayList<AStarNode>();
        if (graph[sourceRow][sourceCol] != null) {
            open.add(graph[sourceRow][sourceCol]);
            graph[sourceRow][sourceCol].setCost(0);
            // Continue until the open list is empty (which may indicate failure), or the goal is the first thing on open
            while(!open.isEmpty()) {
                if (searchIteration(goalRow, goalCol)) {
                    return extractPath(sourceRow, sourceCol, goalRow, goalCol);
                }
            }
        }
        return null;
    }  
}

public class AStarTester {    
    // default source and destination point for the path
    int sourceRow = 1, sourceCol = 2, destRow = 29, destCol = 28;
    int opacity = 150;
    
    // Is mouse click selecting source or dest?
    boolean selectingSource = true;
    
    // Are we finding a path?
    boolean findingPath = false;
    // Have we successfully found a path?
    boolean pathFound = false;
    
    // The path itself
    ArrayList<AStarNode>thePath = null;
    
    // Draw the map every frame as well as source and target points. 
    // Draw the path between the two if one has been found.
    void render() {
        // Paint path
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        strokeWeight(0);
        rectMode(CENTER);
        if (pathFound) {
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
        // Paint source
        stroke(255,0,0,opacity);
        fill(255,0,0,opacity);
        rect(levelManager.gridToScreenX(sourceCol), levelManager.gridToScreenY(sourceRow), levelManager.cellSize / 2, levelManager.cellSize / 2);
        // Paint dest
        stroke(0,255,0,opacity);
        fill(0,255,0,opacity);
        rect(levelManager.gridToScreenX(destCol), levelManager.gridToScreenY(destRow), levelManager.cellSize / 2, levelManager.cellSize / 2);
    }
    
    // upon click, select new source or destination, if not finding path
    void mouseReleased() {
        // don't modify start/end if finding path
        if (findingPath) return;
        
        LevelManager levelManager = ((Robotron)currentScene).levelManager;
        int row = levelManager.screenToGridY(mouseY);
        int col = levelManager.screenToGridX(mouseX);
        if (levelManager.pathFinder.graph[row][col] !=  null) {
            if (selectingSource) {
                sourceRow = row;
                sourceCol = col;
            }
            else {
                destRow = row;
                destCol = col;
            }
            selectingSource = !selectingSource;
        }
    }
    
    // Upon space bar press start path finding.
    void keyReleased() {
        // press space to find path
        if (key == 'p') {
            // if already finding path do nothing
            if (findingPath) return;
            pathFound = false;
            findingPath = true;
            LevelManager levelManager = ((Robotron)currentScene).levelManager;
            ArrayList<AStarNode>result = levelManager.pathFinder.search(sourceRow, sourceCol, destRow, destCol);
            // failure is represented as a null return
            if (result != null) {
                thePath = result;
                pathFound = true;
            }
            findingPath = false;
        }
    }
}