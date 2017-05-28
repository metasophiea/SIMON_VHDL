import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.awt.event.*;

public class displayWindow extends JFrame{
    private int windowWidth = 1005; private int windowHeight = 548; 
    private pixelCanvas PC_input = new pixelCanvas(100,100), PC_output = new pixelCanvas(100,100);
    private JLabel keyText = new JLabel("0000000000000000"), spacerText = new JLabel(" - "), modeText = new JLabel("encrypt");

	public displayWindow(){
		setSize(windowWidth, windowHeight);
		setLayout(new FlowLayout(FlowLayout.CENTER, 0, 0));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocationRelativeTo(null);
		setResizable(false);

        add(PC_input); add(PC_output);
        keyText.setFont( new Font("Arial", Font.PLAIN, 20) );
        spacerText.setFont( new Font("Arial", Font.PLAIN, 20) );
        modeText.setFont( new Font("Arial", Font.PLAIN, 20) );
        add(keyText);add(spacerText);add(modeText);
		
		setVisible(true);
    }

    public void update(dataPackage incomingData){
        if(incomingData.getCommand().equals("latestPixel")){
            PC_output.updatePixel(incomingData.getPixelNumber(),incomingData.getPixel());
        }
        else if(incomingData.getCommand().equals("newInput")){
            keyText.setText( incomingData.getKey() );
            modeText.setText("encrypt");
            PC_input.importPixels(incomingData.getInputPixels());
            PC_output.clearPixels();
            PC_input.redraw();
        }
        else if(incomingData.getCommand().equals("switch")){
            if(modeText.getText().equals("encrypt")){modeText.setText("decrypt");}else{modeText.setText("encrypt");}
            PC_input.importPixels( PC_output.exportPixels() );
            PC_output.clearPixels();
            PC_input.redraw();
        }
    }
}