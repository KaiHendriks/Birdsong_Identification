//import jdk.nashorn.internal.scripts.JO;

import java.awt.*;
import java.io.*;

import javax.swing.*;
import javax.swing.JFrame;


@SuppressWarnings("serial")
public class PictureInFrame_withYulscomment extends JFrame {

    public PictureInFrame_withYulscomment(String argx) {
        if (argx == null) {     //If no files exist in the folder, exit
            System.exit(0);

        }

//        else if (argx.contains("spectrogram")){
//
//            Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
//
//
//            GridBagConstraints constraints = new GridBagConstraints();
//            this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
//
//            JPanel panel = new JPanel();
//            panel.setSize(500, 640);
//            panel.setBackground(Color.BLACK);
//            ImageIcon icon = new ImageIcon(argx);
//            JLabel label = new JLabel();
//            label.setIcon(icon);
//            panel.add(label);
//            this.getContentPane().add(panel);
//            panel.add(label);
//            constraints.anchor = GridBagConstraints.CENTER;
//            this.getContentPane().add(panel);
//            this.setLocation(dim.width / -12 - this.getSize().width / -7, dim.height / 8 - this.getSize().height / 7);
//            this.setSize(1000, 1000);
//
//            panel.setVisible(true);
//        }

        else {   //Sets the size and instructions for the phoneme picture frame that appears

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
//recursion for having 4 digits so it doesnt mess up the code.
    public static String zeros (String n) {

        if (n.length()== 4) return n;
        else{
            n = "0"+n;
        }
        return zeros(n);
    }


    public static void main(String[] args) {
        String TXTFILE = null;
        String TXTFILE2 = null;
        String CNTFILE = null;
        String Filename = null;
        Boolean again = true;
        String NameOfFile;
        while (again) {  //Loop allows for multiple folders to be looked one after another


            //Initial prompt that requires input of the folder path
            String directoryPath = JOptionPane.showInputDialog(null, "Here, you will choose whether the picture is a phoneme. Please input the file directory", "");
            if (directoryPath == null) {
                System.exit(0);
            }

            File spectro = new File(directoryPath);
            File[] files1 = spectro.listFiles(); //This loop will find the text file and assign the name to TXTFILE for later use
            for (int i = 0; i < files1.length; i++) {
                NameOfFile = files1[i].getName();
                if (NameOfFile.contains("phonemes.txt")) {
                    Filename = NameOfFile;
                    TXTFILE2 = directoryPath +"\\"+NameOfFile.substring(0,NameOfFile.length()-12)+"specie.txt";
                    TXTFILE = directoryPath + "\\" + NameOfFile;
                    CNTFILE = directoryPath + "\\ Accuracy.txt";
                }
            }
            // Create a Phoneme counter
            File count = new File(CNTFILE);
            try {
                PrintWriter cw = new PrintWriter(count);
                cw.println("Total Phonemes     : 0000");
                cw.println("Correct Phonemes   : 0000");
                cw.println("Incorrect Phonemes : 0000");
                cw.println("Multiple Phonemes  : 0000");
                cw.close();
                }catch (Exception e) {
                e.printStackTrace();
            }

            File log = new File(TXTFILE);


            //Phoneme recognition part

            File path = new File(directoryPath);
            File[] files = path.listFiles();

            for (int i = 0; i < files.length; i++) {


                if (files[i].isFile()) { //this line weeds out other directories/folders
                    NameOfFile = files1[i].getName();

                    //prevents taking spectrogram and other types of files
                    if (((!NameOfFile.contains("spectrogram")) && !NameOfFile.contains("Accuracy`") && !NameOfFile.contains(".txt")) && NameOfFile.contains(".png")) {

                        //this will take the phoneme number
                        String number = NameOfFile.substring(NameOfFile.length() - 8, NameOfFile.length() - 4);


                        //Search parameters for later search and replacement in text file
                        String search = "phoneme " + number;

                        String replacement = "background";


                        //Makes phoneme visible
                        PictureInFrame_withYulscomment picture = new PictureInFrame_withYulscomment(files[i].toString());
                        picture.setVisible(true);


                        //This asks to user to choose whether the picture shown is a phoneme
                        int isPhoneme = JOptionPane.showConfirmDialog(null, "Is this a phoneme?",
                                files[i].getName(), JOptionPane.YES_NO_CANCEL_OPTION);
                        UIManager.put("OptionPane.cancelButtonText", "Multiple");
                        String s = null, putdata = null;

                        if (isPhoneme == JOptionPane.CLOSED_OPTION) {
                            System.exit(0);
                        }

                        if (isPhoneme == 0) {
                            try {
                                FileReader cr = new FileReader(count);

                                String totalStr = "";
                                try (BufferedReader br = new BufferedReader(cr)) {

                                    while ((s = br.readLine()) != null) {
                                        totalStr += (s + "\n");
                                    }
                                    //the number section of first and second line is translated to interger to increase its value by 1
                                    String[] lines = totalStr.split("\n");
                                    String tot = lines[0].substring(21, 25);
                                    String cor = lines[1].substring(21, 25);
                                    int foo = Integer.parseInt(tot) + 1;
                                    int foo2 = Integer.parseInt(cor) + 1;
                                    //the inter is then translated to string and is adjusted to have 4 digits
                                    String tot1 = Integer.toString(foo);
                                    tot1 = zeros(tot1);
                                    String cor1 = Integer.toString(foo2);
                                    cor1 = zeros(cor1);
                                    //the string is replaced to changed string and is saved
                                    lines[0] = lines[0].replaceAll(tot, tot1);
                                    lines[1] = lines[1].replaceAll(cor, cor1);
                                    PrintWriter fw = new PrintWriter(count);
                                    for (int j = 0; j < lines.length; j++) {
                                        fw.println(lines[j]);
//                                        System.out.println(lines[j]);
                                    }
                                    fw.close();


                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                        }

                        if (isPhoneme == 1) {
                            try {
                                FileReader cr = new FileReader(count);

                                String totalStr = "";
                                try (BufferedReader br = new BufferedReader(cr)) {
                                    while ((s = br.readLine()) != null) {
                                        totalStr += (s + "\n");
                                    }
                                    String[] lines = totalStr.split("\n");
                                    //the numbers in first and third line is translated to interger and increased by 1
                                    String tot = lines[0].substring(21, 25);
                                    String cor = lines[2].substring(21, 25);
                                    System.out.println(tot);
                                    int foo = Integer.parseInt(tot) + 1;
                                    int foo2 = Integer.parseInt(cor) + 1;
                                    //the interger is changed into string and adjusted to have 4 digits
                                    String tot1 = Integer.toString(foo);
                                    tot1 = zeros(tot1);
                                    String cor1 = Integer.toString(foo2);
                                    cor1 = zeros(cor1);
                                    //the adjusted string is saved into the original .txt file
                                    lines[0] = lines[0].replaceAll(tot, tot1);
                                    lines[2] = lines[2].replaceAll(cor, cor1);
                                    PrintWriter fw = new PrintWriter(count);
                                    for (int j = 0; j < lines.length; j++) {
                                        fw.println(lines[j]);
                                    }
                                    fw.close();


                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }


//THis will override the text file in case the phoneme is a background noise
                            try {
                                FileReader fr = new FileReader(log);

                                String totalStr = "";
                                try (BufferedReader br = new BufferedReader(fr)) {
                                    //the code reads through the given .txt file and copies line by line to totalStr
                                    while ((s = br.readLine()) != null) {
                                        totalStr += (s + "\n");
                                    }
                                    //putdata copies and replaces the designated phoneme to background
                                    putdata = totalStr.replaceAll(search, replacement);
                                    //putdata is cut to each line
                                    String[] lines = putdata.split("\n");
                                    // the lines are saved into the .txt file
                                    PrintWriter fw = new PrintWriter(log);
                                    for (int j = 0; j < lines.length; j++) {
                                        fw.println(lines[j]);
//                                        System.out.println(lines[j]);
                                    }
                                    fw.close();


                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }


//THis will delet the file that is not a phoneme
                            try {


                                files[i].delete();


                                System.out.println(files[i].getName() + " is deleted!");


                            } catch (Exception e) {

                                e.printStackTrace();

                            }
                        }
                        if (isPhoneme == 2) {
                            try {
                                FileReader cr = new FileReader(count);

                                String totalStr = "";
                                try (BufferedReader br = new BufferedReader(cr)) {

                                    while ((s = br.readLine()) != null) {
                                        totalStr += (s + "\n");
                                    }
                                    //the numbers of first and last line of strings are translated to interger and increased by 1
                                    String[] lines = totalStr.split("\n");
                                    String tot = lines[0].substring(21, 25);
                                    String cor = lines[3].substring(21, 25);
                                    int foo = Integer.parseInt(tot) + 1;
                                    int foo2 = Integer.parseInt(cor) + 1;
                                    //the number is then translated to string and adjusted to have 4 digits
                                    String tot1 = Integer.toString(foo);
                                    tot1 = zeros(tot1);
                                    String cor1 = Integer.toString(foo2);
                                    cor1 = zeros(cor1);
                                    //the changed string replaces original string and is saved to the original .txt file
                                    lines[0] = lines[0].replaceAll(tot, tot1);
                                    lines[3] = lines[3].replaceAll(cor, cor1);
                                    PrintWriter fw = new PrintWriter(count);
                                    for (int j = 0; j < lines.length; j++) {
                                        fw.println(lines[j]);
//                                        System.out.println(lines[j]);
                                    }
                                    fw.close();


                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }


                        picture.dispose();
                    }
                }
            }
            //The code replaces the 'phonemes' to species name and saves in '-specie.txt.'
            try{
                File log2 = new File (TXTFILE2);

                FileReader cr = new FileReader(log);
                String s;
                String totalStr = "";
                try (BufferedReader br = new BufferedReader( cr)) {

// The program reads through the original .txt file and copies line by line to totalStr
                    while ((s = br.readLine()) != null) {
                        totalStr += (s + "\n");
                    }
                    //it then cuts each lines of totalStr and saves it in String array
                    String[] lines = totalStr.split("\n");
                    //each string array searches and replaces phoneme to the species name
                    for (int i= 0;i<lines.length;i++){
                        if (lines[i].contains("phoneme")){
                            lines[i]=lines[i].substring(0,lines[i].length()-13)+ Filename.substring(0,Filename.length()-15);
                        }
                    }
// the lines are written into the .txt file
                    PrintWriter fw = new PrintWriter(log2);
                    for (int j = 0; j < lines.length; j++) {
                        fw.println(lines[j]);
                    }
                    fw.close();

                }}catch (Exception e) {
                e.printStackTrace();
            }

            //This asks the user if he/she wants to continue with another folder
            int continueLoop = JOptionPane.showConfirmDialog(null, "Do you want to do another folder?", "Quit?", JOptionPane.YES_NO_OPTION);
            if (continueLoop == JOptionPane.NO_OPTION) {
                again = false;
            }



        }
    }

}
