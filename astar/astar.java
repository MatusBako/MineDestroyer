// Internal action code for project jasonTeam.mas2j



package astar;



import jason.*;

import jason.asSemantics.*;

import jason.asSyntax.*;
import java.util.*;


class Node
{
    public int x;
    public int y;
    public int gscore;
    public int fscore;
    public int getFscore()
    {
        return fscore;
    }
    public Node camefrom;
    public Node(int xin, int yin, int gscorein)
    {
        x = xin;
        y = yin;
        gscore = gscorein;
    }
    public Node(int xin, int yin, int gscoreprec, Node precedessor)
    {
        x = xin;
        y = yin;
        gscore = gscoreprec+1;
        fscore = distance(precedessor) + gscoreprec;

    }
    public int distance(Node target)
    {
        return Math.abs(x-target.x) + Math.abs(y-target.y);
    }
    @Override
    public boolean equals(Object cmp)
    {
        if (cmp instanceof Node)
        {
            return x==((Node) cmp).x && y==((Node) cmp).y;
        }
        return false;
    }
    public boolean isValid(TransitionSystem ts)
    {
        LogicalFormula n;
        try {
            //isObstacle
            n = ASSyntax.parseFormula("dbObstacle("+x+", "+y+")");
            Unifier u = new Unifier();
            boolean isObstacle = ts.getAg().believes(n, u);
            //ts.getAg().getLogger().info("*** obstacle "+ x + " "+ y + " " + isObstacle + " " + u.toString());
            //get grid size
            n = ASSyntax.parseFormula("grid_size(X, Y)");
            ts.getAg().believes(n, u);
            // ts.getAg().getLogger().info("*** possible "+ x + " "+ y + " " + gridSize + " " + u.toString());
            int gridX, gridY;
            gridX = (int)((NumberTerm)u.get("X")).solve();
            gridY = (int)((NumberTerm)u.get("Y")).solve();
            //ts.getAg().getLogger().info("*** gridsize "+ gridX + " "+ gridY + " " + (x>=0 && y>=0 && x<gridX && x<gridY && !isObstacle) + " " + u.toString());

            return x>=0 && y>=0 && x<gridX && y<gridY && !isObstacle;
        }
        catch (Exception e)
        {

        }
        return true;
    }

};

public class astar extends DefaultInternalAction {


    
    @Override

    synchronized public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {

        // execute the internal action
        //ts.getAg().getLogger().info("unifier" + un.toString());
        //ts.getAg().getLogger().info("executing internal action 'astar.astar'");
        Node from = new Node(0,0,0), target = new Node(0,0,100000);
        if(args[0].isNumeric())
        {
            from.x = (int)((NumberTerm)args[0]).solve();
        }
        if(args[1].isNumeric())
        {
            from.y = (int)((NumberTerm)args[1]).solve();
        }
        if(args[2].isNumeric())
        {
            target.x = (int)((NumberTerm)args[2]).solve();
        }
        if(args[3].isNumeric())
        {
            target.y = (int)((NumberTerm)args[3]).solve();
        }
        //set initial heuristic for source node
        from.fscore = from.distance(target);

        // ts.getAg().getLogger().info("*** from "+ from.x + " "+ from.y );
        // ts.getAg().getLogger().info("*** to "+ target.x + " "+ target.y );
        List<Node> open = new ArrayList<Node>();
        List<Node> closed = new ArrayList<Node>();
        List<Node> expanded = new ArrayList<Node>();
        List<Node> path = new ArrayList<Node>();
        open.add(from);
        // ts.getAg().getLogger().info("*** to "+ open.get(0).x + " "+ open.get(0).y + " " + open.get(0).fscore);
        //ts.getAg().getLogger().info("*** open.contains(from)  "+ open.contains(new Node(from.x, from.y, 10, from)));
        while(!open.isEmpty())
        {
            //ts.getAg().getLogger().info("*** closed  "+ closed.size() + " open "+ open.size());
            Node current = open.stream()
                                .min(Comparator.comparing(Node::getFscore))
                                .orElseThrow(NoSuchElementException::new);
            if(current.equals(target))
            {
                
                while (current != null)
                {
                    //ts.getAg().getLogger().info("*** path "+ current.x + " "+ current.y + " " + current.fscore);
                    path.add(current);
                    current = current.camefrom;
                }
                break;
            }
            open.remove(current);
            closed.add(current);
            //ts.getAg().getLogger().info("*** to "+ current.x + " "+ current.y + " " + current.fscore + " "+ current.isValid(ts) );
            //expand new nodes
            expanded.add(new Node(current.x+1, current.y  , 10000, current));
            expanded.add(new Node(current.x-1, current.y  , 10000, current));
            expanded.add(new Node(current.x  , current.y+1, 10000, current));
            expanded.add(new Node(current.x  , current.y-1, 10000, current));
            for (Node i : expanded)
            {
                Node neighbor = i; // to make it effectively final. Wtf, Java?
                //invalid neighbor
                if (!neighbor.isValid(ts))
                {
                    continue;
                }
                //node in closed
                if (closed.contains(neighbor))
                {
                    //ts.getAg().getLogger().info("*** skipped  ");
                    continue;
                }
                //node in open
                if (!open.contains(neighbor))
                {
                    //ts.getAg().getLogger().info("*** found new  " + open.contains(neighbor) + " " + neighbor.x + " " + neighbor.y);
                    open.add(neighbor);
                }
                else
                {
                    neighbor = open.get(open.indexOf(neighbor));
                }
                //is this path better?
                if (current.gscore+1 > neighbor.gscore)
                {
                    continue;
                }
                neighbor.camefrom = current;
                neighbor.gscore = current.gscore + 1;
                neighbor.fscore = current.gscore + 1 +neighbor.distance(target);
            }
            expanded.clear();
        }
        
        if(path.size()==1)
        {
            return un.unifies(ASSyntax.createLiteral("skip"), args[args.length-1]);
        }
        else if(!path.isEmpty())
        {
            String move = "skip";
            Node next = path.get(path.size()-2);
            if(from.x+1 == next.x && from.y == next.y)
            {
                move = "right";
            }
            else if(from.x-1 == next.x && from.y == next.y)
            {
                move = "left";
            }
            else if(from.x == next.x && from.y+1 == next.y)
            {
                move = "down";
            }
            else if(from.x == next.x && from.y-1 == next.y)
            {
                move = "up";
            }
            return un.unifies(ASSyntax.createLiteral(move), args[args.length-1]);
        }
        
        //ts.getAg().getLogger().info("*** A* failed  ");
        return un.unifies(ASSyntax.createLiteral("fail"), args[args.length-1]);

    }

}


