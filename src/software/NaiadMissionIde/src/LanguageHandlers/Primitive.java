package LanguageHandlers;

import Drawables.DrawableVariable;
import Enums.ILanguageObjectType;
import Enums.VariableType;
import Exceptions.NullReferenceException;
import Interfaces.IDrawable;
import Interfaces.ILanguageObject;
import Interfaces.ILanguageVariable;
import Interfaces.IPrimitive;

import java.awt.*;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Observable;

public class Primitive extends Observable implements IPrimitive, ILanguageObject{

    private String primitiveName;
    private ArrayList<IDrawable> primitiveInputs;
    private ArrayList<IDrawable> primitiveOutputs;

    private final Path filePath;

    public Primitive(String name, Path path)
    {
        this.primitiveName = name;
        this.filePath = path;

        this.primitiveInputs = new ArrayList<IDrawable>();
        this.primitiveOutputs  = new ArrayList<IDrawable>();

        this.loadFile();
    }

    public Primitive(Primitive base) {
        this.primitiveName = base.primitiveName;
        this.primitiveInputs = base.primitiveInputs;
        this.primitiveOutputs = base.primitiveOutputs;
        this.filePath = base.filePath;

        this.loadFile();
    }

    @Override
    public Path getFilePath() throws NullReferenceException
    {
        if(this.filePath != null)
            return this.filePath;
        throw new NullReferenceException("this.filePath");
    }

    @Override
    public String toString()
    {
        return "P : " + this.primitiveName;
    }

    @Override
    public List<IDrawable> getInputVariables() {
        return this.primitiveInputs;
    }

    @Override
    public List<IDrawable> getOutputVariables() {
        return this.primitiveOutputs;
    }

    @Override
    public String getFileContents() throws IOException {
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(this.getFilePath().toString()));

            StringBuilder sb = new StringBuilder();
            String line = br.readLine();

            while (line != null) {
                sb.append(line);
                sb.append('\n');
                line = br.readLine();
            }
            return sb.toString();

        }
        catch (IOException e)
        {
            System.out.println("unable to read file contents of primitive, IOException: " + this.toString());
            e.printStackTrace();

            if(br != null)
            {
                br.close();
            }
        }
        catch (NullReferenceException e)
        {
            System.out.println("unable to read file contents of primitive, NullReferenceException: " + this.toString());
            e.printStackTrace();

            br.close();
        }
        finally
        {
            if(br != null)
            {
                br.close();
            }
        }
        return "";
    }

    @Override
    public void reload() {
        //To change body of implemented methods use File | Settings | File Templates.
    }

    private void loadFile()
    {
        //TODO detta ska läsas från filen
        this.primitiveInputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));
        this.primitiveInputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));
        this.primitiveInputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));
        this.primitiveInputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));

        this.primitiveOutputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));
        this.primitiveOutputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));
        this.primitiveOutputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));
        this.primitiveOutputs.add(new DrawableVariable(VariableType.INTEGER, new Point(0,0)));

    }

    @Override
    public ILanguageObjectType getType() {
        return ILanguageObjectType.Primitive;
    }

    @Override
    public void addVariableAssignment(IDrawable predecessor, int pos) {
        this.primitiveInputs.get(pos).setScope(predecessor);
    }
}
