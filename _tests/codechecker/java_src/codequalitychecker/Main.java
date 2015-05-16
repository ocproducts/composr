/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package codequalitychecker;

import javax.swing.*;

import java.util.*;
import java.io.*;

/**
 *
 * @author chris
 */
public class Main {

    // Settings
    public static boolean relay__api = true;
    public static boolean relay__mixed = false;
    public static boolean relay__checks = false;
    public static boolean relay__security = false;
    public static boolean relay__pedantic = false;
    public static boolean relay__spelling = false;
    public static String projectPath = ".." + File.separator + ".." + File.separator;
    public static String textEditorPath = "/usr/local/bin/mate";
    public static String phpPath = "php";

    // Memory
    static ArrayList<String> skipped_errors = new ArrayList<String>();

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // Load up UI
        try {
            String lf = UIManager.getCrossPlatformLookAndFeelClassName();
            UIManager.setLookAndFeel(lf);
        } catch (ClassNotFoundException exception) {
            exception.printStackTrace(System.out);
        } catch (IllegalAccessException exception) {
            exception.printStackTrace(System.out);
        } catch (InstantiationException exception) {
            exception.printStackTrace(System.out);
        } catch (UnsupportedLookAndFeelException exception) {
            exception.printStackTrace(System.out);
        }

        // Load settings
        Properties p = new Properties();
        try {
            p.load(new FileInputStream(System.getProperty("user.dir") + File.separator + "checker.ini"));
            relay__api = (p.getProperty("relay__api").equals("1"));
            relay__mixed = (p.getProperty("relay__mixed").equals("1"));
            relay__checks = (p.getProperty("relay__checks").equals("1"));
            relay__security = (p.getProperty("relay__security").equals("1"));
            relay__pedantic = (p.getProperty("relay__pedantic").equals("1"));
            relay__spelling = (p.getProperty("relay__spelling").equals("1"));
            projectPath = p.getProperty("projectPath");
            textEditorPath = p.getProperty("textEditorPath");
            phpPath = p.getProperty("phpPath");
            if (!new File(projectPath).exists()) {
                projectPath = ".." + File.separator + ".." + File.separator;
            }
            if (!new File(textEditorPath).exists()) {
                if (new File(
                        "C:\\Program Files\\Macromedia\\Dreamweaver 7\\Dreamweaver.exe").
                        exists()) {
                    textEditorPath
                            = "C:\\Program Files\\Macromedia\\Dreamweaver 7\\Dreamweaver.exe";
                } else {
                    if (new File(
                            "C:\\Program Files\\Macromedia\\Dreamweaver 8\\Dreamweaver.exe").
                            exists()) {
                        textEditorPath
                                = "C:\\Program Files\\Macromedia\\Dreamweaver 8\\Dreamweaver.exe";
                    } else {
                        if (new File(
                                "C:\\Program Files\\Macromedia\\Dreamweaver 9\\Dreamweaver.exe").
                                exists()) {
                            textEditorPath
                                    = "C:\\Program Files\\Macromedia\\Dreamweaver 9\\Dreamweaver.exe";
                        } else {
                            if (new File("C:\\Program Files\\jedit\\jedit.exe").
                                    exists()) {
                                textEditorPath
                                        = "C:\\Program Files\\jedit\\jedit.exe";
                            } else {
                                if (new File(
                                        "C:\\Program Files\\ConTEXT\\ConTEXT.exe").
                                        exists()) {
                                    textEditorPath
                                            = "C:\\Program Files\\ConTEXT\\ConTEXT.exe";
                                } else {
                                    if (new File("/usr/bin/kate").exists()) {
                                        textEditorPath = "/usr/bin/kate";
                                    } else {
                                        if (new File(
                                                "C:\\Program Files (x86)\\Codelobster Software\\CodelobsterPHPEdition\\ClPhpEd.exe").
                                                exists()) {
                                            textEditorPath
                                                    = "C:\\Program Files (x86)\\Codelobster Software\\CodelobsterPHPEdition\\ClPhpEd.exe";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (IOException e) {
        } // No saving then

        // Load skipped
        try {
            BufferedReader skipFile = new BufferedReader(new FileReader(
                    System.getProperty("user.dir") + File.separator + "non_errors.txt"));
            String line = skipFile.readLine();
            while (line != null) {
                skipped_errors.add(line);
                line = skipFile.readLine();
            }
        } catch (IOException e) {
        } // No skip-saving then

        MainDialog d = new MainDialog();
    }

}
