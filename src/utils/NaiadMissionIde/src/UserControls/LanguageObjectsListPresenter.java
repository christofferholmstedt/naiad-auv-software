package UserControls;

import Commands.HandleObjectiveEditorCommand;
import Interfaces.ICommand;

import javax.swing.*;
import java.awt.*;

/**
 * Created with IntelliJ IDEA.
 * User: emil
 * Date: 12/3/13
 * Time: 11:07 AM
 * To change this template use File | Settings | File Templates.
 */
public class LanguageObjectsListPresenter extends JComponent {

    private LanguageObjectsList objectsList;
    private JScrollPane scrollPane;

    public LanguageObjectsListPresenter(ICommand handleObjectiveEditorCommand)
    {
        this.objectsList = new LanguageObjectsList(handleObjectiveEditorCommand);

        this.scrollPane = new JScrollPane(this.objectsList);
        this.scrollPane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        this.scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
        this.scrollPane.setPreferredSize(new Dimension(200,300));
        this.scrollPane.setVisible(true);

        this.add(this.scrollPane);

        this.setLayout(new FlowLayout());

        this.setVisible(true);

    }

    @Override
    public void setSize(Dimension d)
    {
        super.setSize(d);

        this.scrollPane.setSize(d);
        this.objectsList.setSize(d);
    }
}
