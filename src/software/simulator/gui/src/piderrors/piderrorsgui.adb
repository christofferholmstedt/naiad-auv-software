with Gtk.Main;
with Glib.Error;
with Gtk.Widget;
with Gtkada.Builder;
with Exception_Handling;

with Ada.Text_IO;
with Glib.Error;

with PIDErrorsGUILogic;
with Ada.Exceptions;

package body PIDErrorsGUI is

   procedure Register_Handlers(xBuilder : in out GtkAda.Builder.Gtkada_Builder) is
   begin
    Gtkada.Builder.Register_Handler
        (Builder      => xBuilder,
         Handler_Name => "initDraw",
         Handler      => PIDErrorsGUILogic.Draw_Timeout'Access);

   end Register_Handlers;


   procedure Start_GUI (xModel : Simulator.Model.pCModel) is

      use Glib.Error;
      use Gtkada.Builder;

      xBuilder : aliased Gtkada_Builder;
      xError   : Glib.Error.GError;
   begin
      Gtk.Main.Init;

      Gtk_New (xBuilder);
      xError := Add_From_File (xBuilder, "PIDErrors.glade");
      if xError /= null then
         Ada.Text_IO.Put("Error while loading .glade: ");
         Ada.Text_IO.Put(Glib.Error.Get_Message(xError));
         Error_Free (xError);
         return;
      end if;


      Register_Handlers(xBuilder);

      Ada.Text_IO.Put_Line("PIDErrors GUI handlers registred");

      Do_Connect (xBuilder);

      Ada.Text_IO.Put_Line("xBuilder connected");

      Gtk.Widget.Show_All (Get_Widget (xBuilder, "pidErrorsWindow"));
      Gtk.Main.Main;

      Unref (xBuilder);

   exception
      when E : others =>
         Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(E));
         Exception_Handling.Unhandled_Exception(E => E);

   end Start_GUI;

end PIDErrorsGUI;
