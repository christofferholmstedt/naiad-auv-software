with Sax.Readers;           use Sax.Readers;
with Schema.Readers;        use Schema.Readers;
with Schema.Schema_Readers; use Schema.Schema_Readers;
with Schema.Validators;     use Schema.Validators;
with Input_Sources.Strings;    use Input_Sources.Strings;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents;
with DOM.Core.Elements;
with DOM.Core.Nodes;
with Ada.Text_IO; use Ada.Text_IO;
with Schema.DOM_Readers; use Schema.DOM_Readers;
with Unicode.CES.Utf8;
with SAX.Symbols;
with SAX.Utils;
procedure main is
   XSD : constant String := "<?xml version=""1.0"" encoding=""UTF-8""?>"
      & "<xs:schema xmlns:xs=""http://www.w3.org/2001/XMLSchema"" elementFormDefault=""qualified"" targetNamespace=""http://singo1.com/schemas/agent"" xmlns:agent=""http://singo1.com/schemas/agent"">"
      & "  <xs:element name=""response"" type=""agent:agent-message""/>"
      & "  <xs:complexType name=""agent-message"">"
      & "    <xs:sequence>"
      & "      <xs:element ref=""agent:message""/>"
      & "    </xs:sequence>"
      & "  </xs:complexType>"
      & "  <xs:element name=""message"" type=""xs:string""/>"
      & "</xs:schema>";

   XML : constant String := "<?xml version=""1.0""?>"
      & "<agent:response xmlns:agent=""http://singo1.com/schemas/agent"">"
      & "  <agent:message>Zerg</agent:message>"
      & "</agent:response>";

   Grammar   : XML_Grammar;
   S_Reader  : Schema_Reader;
   Input     : String_Input;
   My_Reader : Schema.DOM_Readers.Tree_Reader;

   Document : DOM.Core.Document;

   Messages : DOM.Core.Node_List;
--     Length   : Natural;
   Node : DOM.Core.Node;

   Agent_NS : constant String := "http://singo1.com/schemas/agent";
begin
   Input_Sources.Strings.Open (Str => XSD, Encoding => Unicode.CES.Utf8.Utf8_Encoding, Input => Input);
   Parse (S_Reader, Input);
   Close (Input);

   Grammar := Get_Grammar (S_Reader);

   Set_Public_Id (Input, "Agent file");
   Input_Sources.Strings.Open (Str => XML, Encoding => Unicode.CES.Utf8.Utf8_Encoding, Input => Input);

   Set_Grammar (My_Reader, Grammar);

   Set_Feature (My_Reader, Schema_Validation_Feature, True);
--   Schema.DOM_Readers.Set_Feature (My_Reader, SAX.Readers.Namespace_Prefixes_Feature, True);
   Schema.DOM_Readers.Set_Feature (My_Reader, SAX.Readers.Namespace_Feature, True);
   Schema.DOM_Readers.Set_Feature (My_Reader, SAX.Readers.Test_Valid_Chars_Feature, True);

   Parse (My_Reader, Input);

   Close (Input);

   Document := Schema.DOM_Readers.Get_Tree (My_Reader);

   DOM.Core.Nodes.Print (Document);
   Ada.Text_IO.New_Line;

   Messages := DOM.Core.Documents.Get_Elements_By_Tag_Name_NS (Doc => Document, Namespace_URI => Agent_NS, Local_Name => "message");
   Node := DOM.Core.Nodes.Item (Messages, 0);

   Put_Line ("Length => " & Natural'Image (DOM.Core.Nodes.Length (Messages) ) );
   Put_Line ("OK. => " & DOM.Core.Nodes.Node_Value (DOM.Core.Nodes.First_Child (Node) ) );
   DOM.Core.Nodes.Print (DOM.Core.Nodes.Item (Messages, 0));

   Schema.DOM_Readers.Free (My_Reader);
   DOM.Core.Free (Messages);
end main;


--  --  with Input_Sources.File;
--  --  with Sax.Readers;
--  --  with DOM.Readers;
--  --  -- with Schema.Readers;
--  --  with DOM.Core;
--  --  with DOM.Core.Documents;
--  --  with DOM.Core.Nodes;
--  --  with DOM.Core.Attrs;
--  --  with Ada.Command_line;
--  --  with Ada.Text_IO;
--  with Schema.Schema_Readers, Schema.Validators, Input_Sources.File;
--  use  Schema.Schema_Readers, Schema.Validators, Input_Sources.File;
--
--  procedure main is
--     Grammar : XML_Grammar;
--     Schema  : Schema_Reader;
--     Read    : File_Input;
--  begin
--     Open ("file.xsd", Read);
--     Parse (Schema, Read);
--     Close (Read);
--
--  --     Grammar := Get_Grammar (Schema);
--  --     declare
--  --     	Read2      : File_Input;
--  --     	My_Reader : Validating_Reader;
--  --     begin
--  --     	Set_Grammar (My_Reader, Grammar);
--  --     	Set_Feature (My_Reader, Schema_Validation_Feature, True);
--  --     	Open ("file.xml", Read2);
--  --     	Parse (My_Reader, Read2);
--  --    	Close (Read2);
--  --     end;
--  end main;
--
--  --  procedure main is
--  --      Input   : Input_Sources.File.File_Input;
--  --      Reader  : DOM.Readers.Tree_Reader;
--  --  --  Reader  : Schema.Readers.Validating_Reader;
--  --      Doc     : DOM.Core.Document;
--  --      File_Name : String := Ada.Command_Line.Argument(1);
--  --      Schema_File_Name : String := Ada.Command_Line.Argument(2);
--  --      List : DOM.Core.Node_List;
--  --      N : DOM.Core.Node;
--  --      A : DOM.Core.Attr;
--  --  begin
--  --      Input_Sources.File.Set_Public_Id (Input, "Preferences file");
--  --      Input_Sources.File.Open (File_Name, Input);
--  --
--  --      DOM.Readers.Set_Feature (Reader, Sax.Readers.Validation_Feature, False);
--  --      DOM.Readers.Set_Feature (Reader, Sax.Readers.Namespace_Feature, False);
--  --
--  --      DOM.Readers.Parse (Reader, Input);
--  --      Input_Sources.File.Close (Input);
--  --
--  --      Doc := DOM.Readers.Get_Tree (Reader);
--  --
--  --      List := DOM.Core.Documents.Get_Elements_By_Tag_Name (Doc, "pref");
--  --
--  --      for Index in 1 .. DOM.Core.Nodes.Length (List) loop
--  --          N := DOM.Core.Nodes.Item (List, Index - 1);
--  --          A := DOM.Core.Nodes.Get_Named_Item (DOM.Core.Nodes.Attributes (N),
--  --                                              "name");
--  --          Ada.Text_IO.Put_Line ("Value of """ & DOM.Core.Attrs.Value (A) & """ is "
--  --              & DOM.Core.Nodes.Node_Value (DOM.Core.Nodes.First_Child (N)));
--  --      end loop;
--  --
--  --      DOM.Core.Free (List);
--  --      DOM.Readers.Free (Reader);
--  --
--  --  end main;
