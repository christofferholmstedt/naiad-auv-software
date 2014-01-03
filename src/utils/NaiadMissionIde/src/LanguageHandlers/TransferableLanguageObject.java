package LanguageHandlers;

import Enums.ILanguageObjectType;
import Exceptions.NullReferenceException;
import Interfaces.IDrawConfig;
import Interfaces.ILanguageObject;

import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Observable;
import java.util.UUID;

/**
 * Created with IntelliJ IDEA.
 * User: emil
 * Date: 11/28/13
 * Time: 12:59 PM
 * To change this template use File | Settings | File Templates.
 */
public class TransferableLanguageObject extends Observable implements ILanguageObject, Transferable{

    private UUID uid;

    private ILanguageObject object;

    public TransferableLanguageObject(ILanguageObject objectToTransfer)
    {
        this.uid = java.util.UUID.randomUUID();
        this.object = objectToTransfer;
    }

    public TransferableLanguageObject(TransferableLanguageObject other)
    {
        this.uid = java.util.UUID.randomUUID();
        this.object = other.object;
    }

    public static DataFlavor languageObjectFlavor  = new DataFlavor(ILanguageObject.class, "ILanguage object");

    protected static DataFlavor[] supportedFlavors = {
            languageObjectFlavor
    };

    @Override
    public Path getFilePath() throws NullReferenceException
    {
        return object.getFilePath();
    }

    @Override
    public List<IDrawConfig> getInputVariables() {
        return object.getInputVariables();
    }

    @Override
    public List<IDrawConfig> getOutputVariables() {
        return object.getOutputVariables();
    }

    @Override
    public ILanguageObjectType getType() {
        return this.object.getType();
    }

    @Override
    public void addVariableAssignment(IDrawConfig predecessor, int pos) {
        this.object.addVariableAssignment(predecessor,pos);
    }

    @Override
    public UUID getUid() {
        return this.uid;
    }

    @Override
    public DataFlavor[] getTransferDataFlavors() {
        return TransferableLanguageObject.supportedFlavors;
    }

    @Override
    public boolean isDataFlavorSupported(DataFlavor dataFlavor) {
        return dataFlavor.equals(languageObjectFlavor);
    }

    @Override
    public Object getTransferData(DataFlavor dataFlavor) throws UnsupportedFlavorException, IOException {
        if(dataFlavor.equals(languageObjectFlavor))
        {
            return this.object;
        }
        throw new UnsupportedFlavorException(languageObjectFlavor);
    }
}
