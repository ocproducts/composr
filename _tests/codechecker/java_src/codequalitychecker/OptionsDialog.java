package codequalitychecker;

import java.awt.*;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import java.util.*;
import java.io.*;

public class OptionsDialog extends JDialog {

    JPanel panel1 = new JPanel();
    JTabbedPane jTabbedPane1 = new JTabbedPane();
    JButton closeBtn = new JButton();
    JButton cancelBtn = new JButton();
    JPanel environment = new JPanel();
    JPanel flags = new JPanel();
    JButton phpPathBtn = new JButton();
    JTextField phpPath = new JTextField();
    JLabel jLabel1 = new JLabel();
    JButton projectPathBtn = new JButton();
    JLabel jLabel2 = new JLabel();
    JTextField projectPath = new JTextField();
    JButton textEditorPathBtn = new JButton();
    JLabel jLabel3 = new JLabel();
    JTextField textEditorPath = new JTextField();
    JCheckBox spelling = new JCheckBox();
    VerticalFlowLayout verticalFlowLayout1 = new VerticalFlowLayout();
    JCheckBox api = new JCheckBox();
    JCheckBox mixed = new JCheckBox();
    JCheckBox checks = new JCheckBox();
    JCheckBox security = new JCheckBox();
    JCheckBox pedantic = new JCheckBox();

    public OptionsDialog(Frame owner, String title, boolean modal) {
        super(owner, title, modal);
        try {
            setDefaultCloseOperation(DISPOSE_ON_CLOSE);
            jbInit();
            pack();
        } catch (Exception exception) {
            exception.printStackTrace(System.out);
        }
    }

    public OptionsDialog() {
        this(new Frame(), "Options", false);
    }

    private void jbInit() throws Exception {
        panel1.setLayout(null);
        jTabbedPane1.setBounds(new Rectangle(10, 13, 451, 237));
        closeBtn.setBounds(new Rectangle(389, 263, 71, 23));
        closeBtn.setMargin(new Insets(0, 0, 0, 0));
        closeBtn.setActionCommand("closeBtn");
        closeBtn.setText("Close");
        closeBtn.addActionListener(new Dialog2_closeBtn_actionAdapter(this));
        cancelBtn.setBounds(new Rectangle(308, 263, 71, 23));
        cancelBtn.setMargin(new Insets(0, 0, 0, 0));
        cancelBtn.setActionCommand("cancelBtn");
        cancelBtn.setText("Cancel");
        cancelBtn.addActionListener(new Dialog2_cancelBtn_actionAdapter(this));
        phpPathBtn.setBounds(new Rectangle(355, 53, 76, 22));
        phpPathBtn.setMargin(new Insets(0, 0, 0, 0));
        phpPathBtn.setActionCommand("phpPathBtn");
        phpPathBtn.setText("Browse");
        phpPathBtn.addActionListener(new Dialog2_phpPathBtn_actionAdapter(this));
        textEditorPathBtn.addActionListener(new Dialog2_textEditorPathBtn_actionAdapter(this));
        projectPathBtn.addActionListener(new Dialog2_projectPathBtn_actionAdapter(this));
        phpPath.setText(Main.phpPath);
        phpPath.setBounds(new Rectangle(114, 54, 228, 19));
        jLabel1.setText("PHP executable:");
        jLabel1.setBounds(new Rectangle(8, 52, 104, 22));
        environment.setLayout(null);
        projectPathBtn.setBounds(new Rectangle(356, 86, 76, 22));
        projectPathBtn.setMargin(new Insets(0, 0, 0, 0));
        projectPathBtn.setActionCommand("projectPathBtn");
        projectPathBtn.setText("Browse");
        jLabel2.setToolTipText("");
        jLabel2.setText("Project path:");
        jLabel2.setBounds(new Rectangle(9, 85, 104, 22));
        projectPath.setBounds(new Rectangle(115, 87, 228, 19));
        projectPath.setText(Main.projectPath);
        textEditorPathBtn.setBounds(new Rectangle(355, 20, 76, 22));
        textEditorPathBtn.setActionCommand("textEditorPathBtn");
        textEditorPathBtn.setText("Browse");
        jLabel3.setText("Text editor path:");
        jLabel3.setBounds(new Rectangle(8, 19, 104, 22));
        textEditorPath.setBounds(new Rectangle(114, 21, 228, 19));
        textEditorPath.setText(Main.textEditorPath);
        spelling.setActionCommand("spelling");
        spelling.setText(
                "Spell checking (PHP must have pspell or enchant installed)");
        flags.setLayout(verticalFlowLayout1);
        api.setToolTipText("");
        api.setActionCommand("api");
        api.setText(
                "Do API checks (recommended, esp as it helps determine type)");
        mixed.setActionCommand("mixed");
        mixed.setText("Flag variables that have no determinable type");
        checks.setActionCommand("checks");
        checks.setText(
                "Flag areas that need special checking (e.g. file permissions)");
        security.setActionCommand("security");
        security.setText("Flag security hotspots (e.g. query and exec)");
        pedantic.setToolTipText("");
        pedantic.setActionCommand("pedantic");
        pedantic.setText("Show pedantic warnings (comment density, etc)");
        api = new JCheckBox(api.getText(), Main.relay__api);
        mixed = new JCheckBox(mixed.getText(), Main.relay__mixed);
        checks = new JCheckBox(checks.getText(), Main.relay__checks);
        security = new JCheckBox(security.getText(), Main.relay__security);
        pedantic = new JCheckBox(pedantic.getText(), Main.relay__pedantic);
        this.setModal(true);
        this.setResizable(false);
        this.setTitle("Options");
        getContentPane().add(panel1);
        panel1.add(jTabbedPane1);
        panel1.add(closeBtn);
        panel1.add(cancelBtn);
        environment.add(textEditorPath);
        environment.add(jLabel3);
        environment.add(jLabel1);
        environment.add(jLabel2);
        environment.add(projectPath);
        environment.add(phpPath);
        environment.add(projectPathBtn);
        environment.add(phpPathBtn);
        environment.add(textEditorPathBtn);
        jTabbedPane1.add(flags, "Flags");
        flags.add(pedantic);
        flags.add(security);
        flags.add(checks);
        flags.add(mixed);
        flags.add(api);
        flags.add(spelling);
        jTabbedPane1.add(environment, "Environment");
        panel1.setPreferredSize(new Dimension(475, 297));
    }

    public void closeBtn_actionPerformed(ActionEvent e) {
        Main.relay__api = api.isSelected();
        Main.relay__mixed = mixed.isSelected();
        Main.relay__checks = checks.isSelected();
        Main.relay__security = security.isSelected();
        Main.relay__pedantic = pedantic.isSelected();
        Main.relay__spelling = spelling.isSelected();
        Main.projectPath = projectPath.getText();
        Main.textEditorPath = textEditorPath.getText();
        Main.phpPath = phpPath.getText();
        try {
            FileOutputStream out = new FileOutputStream(System.getProperty("user.dir") + File.separator + "checker.ini");
            Properties p = new Properties();
            p.put("relay__api", Main.relay__api ? "1" : "0");
            p.put("relay__mixed", Main.relay__mixed ? "1" : "0");
            p.put("relay__checks", Main.relay__checks ? "1" : "0");
            p.put("relay__security", Main.relay__security ? "1" : "0");
            p.put("relay__pedantic", Main.relay__pedantic ? "1" : "0");
            p.put("relay__spelling", Main.relay__spelling ? "1" : "0");
            p.put("projectPath", Main.projectPath);
            p.put("textEditorPath", Main.textEditorPath);
            p.put("phpPath", Main.phpPath);
            p.store(out, null);
        } catch (IOException e2) {
            System.out.println(e2.toString());
        } // No saving then
        this.setVisible(false);
    }

    public void cancelBtn_actionPerformed(ActionEvent e) {
        this.setVisible(false);
    }

    public void phpPathBtn_actionPerformed(ActionEvent e) {
        String file = this.findFile(false);
        if (file != null) {
            phpPath.setText(file);
        }
    }

    public void projectPathBtn_actionPerformed(ActionEvent e) {
        String file = this.findFile(true);
        if (file != null) {
            projectPath.setText(file);
        }
    }

    public void textEditorPathBtn_actionPerformed(ActionEvent e) {
        String file = this.findFile(false);
        if (file != null) {
            textEditorPath.setText(file);
        }
    }

    public String findFile(boolean dirs) {
        JFileChooser fc = new JFileChooser();
        fc.setDialogTitle("Find File");

        // Choose only files, not directories
        fc.setFileSelectionMode(dirs ? JFileChooser.DIRECTORIES_ONLY : JFileChooser.FILES_ONLY);

        // Start in current directory
        fc.setCurrentDirectory(new File("."));

        // Now open chooser
        int result = fc.showOpenDialog(this);

        if (result == JFileChooser.CANCEL_OPTION) {
            return null;
        } else if (result == JFileChooser.APPROVE_OPTION) {

            File fFile = fc.getSelectedFile();
            String file_string = fFile.getAbsolutePath();

            if (file_string != null) {
                return file_string;
            }
        }

        return null;
    }
}

class Dialog2_phpPathBtn_actionAdapter implements ActionListener {

    private final OptionsDialog adaptee;

    Dialog2_phpPathBtn_actionAdapter(OptionsDialog adaptee) {
        this.adaptee = adaptee;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        adaptee.phpPathBtn_actionPerformed(e);
    }
}

class Dialog2_projectPathBtn_actionAdapter implements ActionListener {

    private final OptionsDialog adaptee;

    Dialog2_projectPathBtn_actionAdapter(OptionsDialog adaptee) {
        this.adaptee = adaptee;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        adaptee.projectPathBtn_actionPerformed(e);
    }
}

class Dialog2_textEditorPathBtn_actionAdapter implements ActionListener {

    private final OptionsDialog adaptee;

    Dialog2_textEditorPathBtn_actionAdapter(OptionsDialog adaptee) {
        this.adaptee = adaptee;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        adaptee.textEditorPathBtn_actionPerformed(e);
    }
}

class Dialog2_cancelBtn_actionAdapter implements ActionListener {

    private final OptionsDialog adaptee;

    Dialog2_cancelBtn_actionAdapter(OptionsDialog adaptee) {
        this.adaptee = adaptee;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        adaptee.cancelBtn_actionPerformed(e);
    }
}

class Dialog2_closeBtn_actionAdapter implements ActionListener {

    private final OptionsDialog adaptee;

    Dialog2_closeBtn_actionAdapter(OptionsDialog adaptee) {
        this.adaptee = adaptee;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        adaptee.closeBtn_actionPerformed(e);
    }
}
