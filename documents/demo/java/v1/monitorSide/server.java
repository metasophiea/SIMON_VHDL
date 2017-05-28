import java.net.*;
import java.io.*;

public class server {
	private static int portNumber = 5050;
	
	public static void main(String args[]){
		boolean listening = true; ServerSocket serverSocket = null;
		
		try{serverSocket = new ServerSocket(portNumber);System.out.println("server_main - Port connection success");}
		catch(IOException e){System.out.println("server_main - Port connection failure"); return;}
		
		while(listening){
			 Socket clientSocket = null;
			 try{
				 System.out.println("server_main - Wating on client...");
				 clientSocket = serverSocket.accept();
				 System.out.println("server_main - Caught client connection");
				 threadedConnectionHandler connection = new threadedConnectionHandler(clientSocket);
				 connection.start();
				 System.out.println("server_main - Finished with client");		 
			 }
			 catch(Exception e){System.out.println("server_main - Couldn't catch client connection - bailing"); listening = false;}			 
		}
		
        try{System.out.println("server_main - Closing server socket");serverSocket.close();} 
        catch (IOException e) {System.err.println("server_main - Can't close server socket");}
	}
}