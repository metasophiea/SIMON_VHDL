import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.awt.event.*;

public class displayWindow extends JFrame{
    private int windowWidth = 1005; private int windowHeight = 548; 
    private pixelCanvas pixelCanvas_input = new pixelCanvas(100,100);
    private pixelCanvas pixelCanvas_output = new pixelCanvas(100,100);
    private JLabel keyText = new JLabel("0000000000000000"), spacerText = new JLabel(" - "), modeText = new JLabel("encrypt");

	public displayWindow(){
		setSize(windowWidth, windowHeight);
		setLayout(new FlowLayout(FlowLayout.CENTER, 0, 0));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocationRelativeTo(null);
		setResizable(false);

        add(pixelCanvas_input); add(pixelCanvas_output);
        keyText.setFont( new Font("Arial", Font.PLAIN, 20) );
        spacerText.setFont( new Font("Arial", Font.PLAIN, 20) );
        modeText.setFont( new Font("Arial", Font.PLAIN, 20) );
        add(keyText);add(spacerText);add(modeText);
		
		setVisible(true);
    }

    public void update(filePackage incomingData){
        modeText.setText( incomingData.getMode() );
        keyText.setText( incomingData.getKey() );

        pixelCanvas_input.importPixels( incomingData.getInputPixels() ); 
        pixelCanvas_input.redraw();
        pixelCanvas_output.importPixels( incomingData.getOutputPixels() );
        pixelCanvas_output.redraw();
    }
}