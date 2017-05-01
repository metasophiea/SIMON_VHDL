import java.net.*;
import java.io.*;

public class threadedConnectionHandler extends Thread{
	private Socket clientSocket = null;	
	private ObjectOutputStream outputStream = null; private ObjectInputStream inputStream = null;

	public threadedConnectionHandler(Socket incomingSocket){
		System.out.println("server_thread - connetion handler called");
		this.clientSocket = incomingSocket;
	}


	public void run(){
		System.out.println("server_thread - setting up in/out streams");		
		try{
    	  this.inputStream = new ObjectInputStream(clientSocket.getInputStream());
    	  this.outputStream = new ObjectOutputStream(clientSocket.getOutputStream());
    	  System.out.println("server_thread - Created in/out streams");
		}catch(IOException e){System.out.println("server_thread - unable to create in/out streams");}
		
		while(this.readData()){}
		System.out.println("server_thread - closing connection");
	}
		
	private boolean readData(){
		System.out.println("server_thread - recieving data");
		dataPackage incomingDataPackage = null;
		
		try{ incomingDataPackage = (dataPackage)inputStream.readObject(); System.out.println("server_thread - Decoded incomming package"); }
		catch(Exception e){System.out.println("server_thread - could not decode incomming package - bailing on connection"); this.closeConnection(); return false;}
		
        try{
            System.out.println("command: " + incomingDataPackage.getCommand());
            System.out.println("pixel: " + incomingDataPackage.getPixel());
            System.out.println("pixelNumber: " + incomingDataPackage.getPixelNumber());
        }
        catch(Exception e){System.out.println(e);}
	
		System.out.println("");
		return true;
	}	
	

	public void closeConnection(){
		try{ this.inputStream.close(); this.outputStream.close(); this.clientSocket.close(); }
		catch(IOException e){}
	}

}