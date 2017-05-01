import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.awt.event.*;

public class displayWindow extends JFrame{
    private int windowWidth = 1005; private int windowHeight = 543; 
    private pixelCanvas PC_input = new pixelCanvas(100,100), PC_output = new pixelCanvas(100,100);

	public displayWindow(){
		setSize(windowWidth, windowHeight);
		setLayout(new FlowLayout(FlowLayout.CENTER, 0, 0));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocationRelativeTo(null);
		setResizable(false);

        add(PC_input); add(PC_output);
		
		setVisible(true);
    }

    public void update(dataPackage incomingData){
        if(incomingData.getCommand().equals("latestPixel")){
            PC_output.updatePixel(incomingData.getPixelNumber(),incomingData.getPixel());
        }
        else if(incomingData.getCommand().equals("switch")){
            PC_input.importPixels( PC_output.exportPixels() );
            PC_output.clearPixels();
            PC_input.redraw();
        }
    }
}