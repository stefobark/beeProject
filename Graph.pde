class Graph{
  
  PVector oLoc;
  
  Graph(PVector start){
    oLoc = start;
  }
  
  void drawLine(ArrayList<PVector> points){
   
   pushMatrix();
   translate(oLoc.x,oLoc.y);
   text("Max Returners", 15,15);
   if(points.size() > 0){
       strokeWeight(15);
       stroke(200,199,111,200);
       strokeCap(PROJECT);
     for(PVector p : points){
       fill(p.y,90);
       translate(p.x,0);
       line(0,0,0,-p.y);
     }
   }
   popMatrix();
  }
}
