package LanguageHandlers;

import Interfaces.ILanguageVariable;

import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.io.IOException;
import java.util.UUID;

/**
 * Created with IntelliJ IDEA.
 * User: emil
 * Date: 12/5/13
 * Time: 3:31 PM
 * To change this template use File | Settings | File Templates.
 */
public class TransferableVariableTypeObject implements Transferable {

    private UUID uid;

    private ILanguageVariable variableToTransfer;
    public static DataFlavor languageVariableFlavour = new DataFlavor(ILanguageVariable.class, "ILanguageVariable object");

    protected static DataFlavor[] supportedFlavors = {
            languageVariableFlavour
    };

    public TransferableVariableTypeObject(ILanguageVariable variableToTransfer) {
        this.uid = java.util.UUID.randomUUID();

        this.variableToTransfer = variableToTransfer;
    }

    public TransferableVariableTypeObject(TransferableVariableTypeObject other) {
        this.uid = java.util.UUID.randomUUID();
        this.variableToTransfer = other.variableToTransfer;
    }

    @Override
    public DataFlavor[] getTransferDataFlavors() {
        return TransferableVariableTypeObject.supportedFlavors;  //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public boolean isDataFlavorSupported(DataFlavor dataFlavor) {
        return dataFlavor.equals(languageVariableFlavour);
    }

    @Override
    public Object getTransferData(DataFlavor dataFlavor) throws UnsupportedFlavorException, IOException {
        if(dataFlavor.equals(languageVariableFlavour))
        {
            return this.variableToTransfer;
        }
        throw new UnsupportedFlavorException(languageVariableFlavour);
    }

    public UUID getUid()
    {
        return this.uid;
    }
}
