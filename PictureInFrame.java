import jdk.nashorn.internal.scripts.JO;

import java.awt.*;
import java.io.*;

import javax.swing.*;
import javax.swing.JFrame;


    @SuppressWarnings("serial")
    public class PictureInFrame extends JFrame {

        public PictureInFrame(String argx) {
            if (argx == null) {
                System.exit(0);

            }

            else if (argx.equals("Spectrogram")){

                Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();


                GridBagConstraints constraints = new GridBagConstraints();
                this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                this.setSize(500, 640);
                JPanel panel = new JPanel();
                panel.setSize(500, 640);
                panel.setBackground(Color.BLACK);
                ImageIcon icon = new ImageIcon(argx);
                JLabel label = new JLabel();
                label.setIcon(icon);
                panel.add(label);
                this.getContentPane().add(panel);
                panel.add(label);
                constraints.anchor = GridBagConstraints.CENTER;
                this.getContentPane().add(panel);
                this.setLocation(dim.width / -12 - this.getSize().width / -7, dim.height / 8 - this.getSize().height / 7);
                this.setSize(500, 500);

                panel.setVisible(true);
            }

            else {

                Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();


                GridBagConstraints constraints = new GridBagConstraints();
                this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                this.setSize(500, 640);
                JPanel panel = new JPanel();
                panel.setSize(2000, 2000);
                panel.setBackground(Color.BLACK);
                ImageIcon icon = new ImageIcon(argx);
                JLabel label = new JLabel();
                label.setIcon(icon);
                panel.add(label);
                this.getContentPane().add(panel);
                panel.add(label);
                constraints.anchor = GridBagConstraints.CENTER;
                this.getContentPane().add(panel);
                this.setLocation(dim.width / 12 - this.getSize().width / 7, dim.height / 8 - this.getSize().height / 7);
                this.setSize(500, 500);

                panel.setVisible(true);

            }
        }










    public static void main(String[] args) {
            String TXTFILE = null;
            Boolean again = true;
            String NameOfFile;
        while(again){  //Loop allows for multiple folders to be looked one after another
            String directoryPath = JOptionPane.showInputDialog(null,"Here, you will choose whether the picture is a phoneme. Please input the file directory", "");
            if (directoryPath == null){System.exit(0);}

               File spectro = new File(directoryPath);
                File [] files1 = spectro.listFiles();
                for (int i = 0; i < files1.length; i++){
                    NameOfFile = files1[i].getName();
                    if (NameOfFile.contains(".txt")){TXTFILE = directoryPath + "\\" + NameOfFile;}
                }


//                for (int i = 0; i < files1.length; i++){
//                    String NameOfFile = files1[i].getName();
////                    System.out.println(NameOfFile);
//
//                    if (NameOfFile.equals("Spectrogram")) {
//
//                        PictureInFrame spectrogram = new PictureInFrame(files1[i].toString());
//                        spectrogram.setVisible(true);
//
//                    }}

                        File path = new File(directoryPath);

        File [] files = path.listFiles();
        for (int i = 0; i < files.length; i++){

//file reading

//            PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter("c:\\book.temp")));
            if (files[i].isFile()){ //this line weeds out other directories/folders
                NameOfFile = files1[i].getName();

                if (!NameOfFile.equals("spectrogram.png")|| !NameOfFile.contains(".txt")){
                    String number = NameOfFile.substring(NameOfFile.length()-8,NameOfFile.length()-4);
                    File log= new File(TXTFILE);
                    String search = "phoneme "+ number;  // <- changed to work with String.replaceAll()
                    System.out.println(search);
                    String replacement = "background";

                    PictureInFrame picture = new PictureInFrame(files[i].toString());
                picture.setVisible(true);






                int isPhoneme= JOptionPane.showConfirmDialog(null,"Is this a phoneme?",files[i].getName(), JOptionPane.YES_NO_OPTION);

                if(isPhoneme==JOptionPane.CLOSED_OPTION){System.exit(0);}
                if (isPhoneme==1){

                    try {
                        FileReader fr = new FileReader(log);
                        String s;
                        BufferedReader br = new BufferedReader(fr);

                        while ((s = br.readLine()) != null) {
                            s.replaceAll(search, replacement);
                            // do something with the resulting line
                        }
                    }catch(Exception e){

                        e.printStackTrace();

                    }

                    try{




                    files[i].delete();


                    System.out.println(files[i].getName() + " is deleted!");


                }catch(Exception e){

                    e.printStackTrace();

                }
                }


                picture.dispose();
            }
            }
        }


        int continueLoop = JOptionPane.showConfirmDialog(null,"Do you want to do another folder?","Quit?",JOptionPane.YES_NO_OPTION);
        if (continueLoop==JOptionPane.NO_OPTION){
            again=false;}

    }}
}


