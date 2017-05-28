import java.net.*;
import java.io.*;
import java.util.*;

public class client{
	private static int portNumber = 5050;
    private static String serverIP = "";
    private Socket socket = null;
    private ObjectOutputStream outputStream = null; private ObjectInputStream inputStream = null;
    private displayWindow dispWin = new displayWindow();

    private static String[] imageFiles = new String[]{"mona.hex","staryNight.hex","nighthawks.hex","threeMusicians.hex","impressionSunrise.hex"};
 
    private static int currentImageNumber = 0;
    private static String currentImage = null;
    private static String currentMode = "decrypt";
    private static String currentKey = null;

	public static void main(String args[]){
		System.out.println("Java Client Started");
		if(args.length == 1){
			client subProcess = new client(args[0]); 
			while(true){ subProcess.process(); }
		}
		else{System.out.println("server address missing - java client 1.2.3.4");}
		return;
	}

	public client(String serverIP){ 
        this.serverIP = serverIP;
	}

    public void openConnections(String serverIP){
		try{
			this.socket = new Socket(serverIP,portNumber);
    		this.outputStream = new ObjectOutputStream(this.socket.getOutputStream());
    		this.inputStream = new ObjectInputStream(this.socket.getInputStream());
		}
		catch(Exception e){ System.out.println("client_main - setup failure " + e); return;}
    }
    public void closeConnection(){
		try{ this.inputStream.close(); this.outputStream.close(); this.socket.close(); }
		catch(IOException e){}
	}

    private void process(){
        openConnections(serverIP);

        //update 'currents'
            System.out.println("updating currents");
            if( currentMode.equals("decrypt") ){
                currentMode = "encrypt";
                currentKey = newKey();
                currentImage = imageFiles[currentImageNumber];
                currentImageNumber++; if( currentImageNumber >= imageFiles.length ){ currentImageNumber = 0; }
            }else{
                currentMode = "decrypt";
                currentImage = "output";
            }

        //send request for new data
            System.out.println("sending request");
            processRequestPackage request = new processRequestPackage(currentMode,currentKey,currentImage);
            sendData(request);

        //recieve data
            System.out.println("recieving data");
            filePackage incomingFilePackage = null;
            try{ incomingFilePackage = (filePackage)inputStream.readObject(); }
            catch(Exception e){System.out.println("client_thread - could not decode incomming package - bailing on connection"); this.closeConnection(); return;}

        //pass data to screen
            System.out.println("passing to screen");
            dispWin.update(incomingFilePackage);

        closeConnection();
    }




    //for the random generation of new keys
        private String newKey(){
            String key = "";
            for(int a = 0; a < 16; a++){ key += generateRamdonHexDigit(); }
            return key;
        }
        private String generateRamdonHexDigit(){ return new String[]{"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}[new Random().nextInt(15)]; }
 
    //standard object sending function
        private void sendData(Object o){
            try{outputStream.writeObject(o); outputStream.flush();}
            catch(Exception e){System.out.println("-- Error while sending data --");}
        }
}