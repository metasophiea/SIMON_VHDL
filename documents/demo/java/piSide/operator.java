import java.net.*;
import java.io.*;

public class operator{
	private static int portNumber = 5050;

	public static void main(String args[]){
		boolean listening = true; ServerSocket serverSocket = null;
		
		try{serverSocket = new ServerSocket(portNumber);System.out.println("operator_main - Port connection success");}
		catch(IOException e){System.out.println("operator_main - Port connection failure"); return;}
		
		while(listening){
			 Socket clientSocket = null;
			 try{
				 System.out.println("operator_main - Wating on client...");
				 clientSocket = serverSocket.accept();
				 System.out.println("operator_main - Caught client connection");
				 connectionHandler connection = new connectionHandler(clientSocket);
				 connection.start();
				 System.out.println("operator_main - Finished with client");		 
			 }
			 catch(Exception e){System.out.println("operator_main - Couldn't catch client connection - bailing"); listening = false;}			 
		}
		
        try{System.out.println("operator_main - Closing operator socket");serverSocket.close();} 
        catch (IOException e) {System.err.println("operator_main - Can't close server socket");}
	}

}