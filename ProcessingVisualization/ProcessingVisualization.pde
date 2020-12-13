import processing.net.*;

Server myServer;
int val = 0;

void setup()  {
  size(400, 400);
  background(0);
  // Starts a myServer on port 1234
  myServer = new Server(this, 1234); 
}

void draw() {
  Client thisClient = myServer.avaliable();
  if (thisClient != null){
  
}
