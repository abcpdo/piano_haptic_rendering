import processing.net.*;

Server myServer;
Client thisClient;
int val = 0;
String PosKey;
String PosTip;
float Key;
float Tip;

void setup()  {
  size(600, 600);
  stroke(127,34,255);     //stroke color
  strokeWeight(1);        //stroke width
  // Starts a myServer on port 1234
  myServer = new Server(this, 1234); 
  finger = loadImage("finger.png");
}

void draw() {
  thisClient = myServer.available();  
  if (thisClient != null){
    background(0);
    PosKey = thisClient.readStringUntil(' ');
    PosTip = thisClient.readStringUntil('\n');
    if (PosKey != null){
      Key = float(PosKey);
      Tip = float(PosTip);
    }
    Key = map(Key,0.04,-0.04,0,600);
    Tip = map(Tip,0.04,-0.04,0,600);
    image(finger,200,Tip,5,5);
    line(200,Key,600,300);
  }
}
