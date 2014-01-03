
---------------------------------------------------------------------------
-- This code handles communication between the BeagleBone Black (BBB) and
-- the CAN-link.
-- This code is loosly based on the router.adb file from the Vasa project.

-- Written by Nils Brynedal Ignell for the Naiad AUV project
-- Last changed (yyyy-mm-dd): 2013-11-01

-- TODO: hardware testing

---------------------------------------------------------------------------

with Ada.Text_IO;
with GNAT.Serial_Communications;
with CAN_Link_Utils;
with Exception_Handling;

with Queue;

package body BBB_CAN is
   pragma Suppress (All_Checks);

   pxUart : UartWrapper.pCUartHandler;

   procedure Init(sPort : String; baud : UartWrapper.BaudRates) is
   begin
      --initiates UART commiunication:
    --  --Ada.Text_IO.Put_Line("Opening " & "/dev/" & sPort & ", baudrate: " & baud'Img);
    --  pxUart := UartWrapper.pxCreate(GNAT.Serial_Communications.Port_Name("/dev/" & sPort), baud, 0.2, 100);
      pxUart := UartWrapper.pxCreate("/dev/" & sPort, baud, 0, 200, 0);
   end Init;

--     function Handshake return Boolean is
--        sSend : String(1..5);
--        sReceive : String(1..6);
--        iBytesRead : Integer := 0;
--     begin
--        -- handshake message:
--        sSend(1) := Character'Val(3);
--        sSend(2) := Character'Val(0);
--        sSend(3) := Character'Val(0);
--        sSend(4) := Character'Val(0);
--        sSend(5) := Character'Val(0);
--
--        --send handshake message and wait for reply while keeping a look at the clock
--        sReceive := pxUart.sUartEcho(5, iBytesRead, sSend, Duration(iHANDSHAKE_WAIT_TIME_MS) / 1000);
--
--        if iBytesRead >= 5 then
--           if sReceive(1) = Character'Val(3) and
--             	sReceive(2) = Character'Val(0) and
--             	sReceive(3) = Character'Val(0) and
--             	sReceive(4) = Character'Val(0) and
--             	sReceive(5) = Character'Val(0) then
--              return true;
--           end if;
--        end if;
--        return false;
--     end Handshake;

   procedure Send(msg : CAN_Defs.CAN_Message) is
      sBuffer : String(1 .. (Integer(msg.Len) + CAN_Link_Utils.HEADLEN));
      nByteCount: Integer;
   begin
      CAN_Link_Utils.Message_To_Bytes(sBuffer, msg);

       Ada.Text_IO.Put("queue.Write():");
      nByteCount := 0;
      for Index in sBuffer'Range loop
         nByteCount := nByteCount + 1;
         if nByteCount > 1 then
            Ada.Text_IO.Put(", ");
         end if;
         Ada.Text_IO.Put(Character'Image(sBuffer(nByteCount)));
      end loop;

      Usart_Write(sBuffer, Integer(msg.Len) + CAN_Link_Utils.HEADLEN);
   end Send;

   procedure Get(msg : out CAN_Defs.CAN_Message; bMsgReceived : out Boolean; bUARTChecksumOK : out Boolean) is

      use Interfaces;

      sHeadBuf     : String(1..CAN_Link_Utils.HEADLEN);
      u8ActualChecksum    : Interfaces.Unsigned_8;
      u8ReceivedChecksum  : Interfaces.Unsigned_8;
      bReadComplete : Boolean;

   begin
      Usart_Read(sHeadBuf, CAN_Link_Utils.HEADLEN, bReadComplete);

      if not bReadComplete then
         bMsgReceived 	 := false;
         bUARTChecksumOK := false;
         return;
      end if;

      bMsgReceived := true;

      CAN_Link_Utils.Bytes_To_Message_Header(sHeadBuf, msg, u8ReceivedChecksum);

      if Integer(msg.Len) /= 0 then
         declare
            sData : String(1..Integer(msg.Len));
            iTempBytesRead : Integer := 0;
         begin

            if Queue.iDataAvailable >= Integer(msg.Len) then
               Queue.Read(sData, iTempBytesRead, Integer(msg.Len));
            else
               Usart_Read_Inf_Block(sData, Integer(msg.Len));
            end if;

            CAN_Link_Utils.Bytes_To_Message_Data(sData, msg, u8ActualChecksum);
         end;
         bUARTChecksumOK := (u8ActualChecksum = u8ReceivedChecksum);
      else
         bUARTChecksumOK := true; --if there is no data in the message, the checksum is defined as ok
      end if;

      --Queue.iFirst := 1;
      --Queue.iLast := 1;

     Exception
         when E : others =>
            Exception_Handling.Reraise_Exception(E       => E,
                                                 Message => "BBB_CAN.Get(msg : out AVR.AT90CAN128.CAN.CAN_Message; bMsgReceived : out Boolean; bUARTChecksumOK : out Boolean)");

   end Get;

   --------- private functions ------------------------------------

   procedure Usart_Write(sBuffer : String; iSize : Integer) is
   begin

      ----Ada.Text_IO.Put_Line("Usart_Write, iSize=" & iSize'Img);

      pxUart.Uart_Write(sBuffer, iSize, false);
   end Usart_Write;

   procedure Usart_Read(sBuffer : out String; iSize : Integer; bBytesRead : out Boolean) is

      sTempBuffer : String(1 .. Queue.iSIZE - Queue.iDataAvailable - 1);
      iTempBytesRead : Integer;
      iBytes : Integer;

      nByteCount : Natural;

   begin
      nByteCount := 0;

      --kks: read from uart as much as the queue can fit (if available).
      pxUart.UartReadSpecificAmount(sTempBuffer, Queue.iSIZE - Queue.iDataAvailable - 1, iTempBytesRead);

      --kks: if something was read from uart put it in the queue
      if iTempBytesRead > 0 then
         Queue.Write(sTempBuffer(sTempBuffer'First..sTempBuffer'Last), iTempBytesRead, iBytes);

         if iBytes /= iTempBytesRead then
            Exception_Handling.Raise_Exception(E       => Exception_Handling.BufferOverflow'Identity,
                                               Message => "BBB_CAN.Usart_Read(sBuffer : out String; iSize : Integer; iBytesRead : out Integer)");
         end if;
      end if;

      if Queue.iDataAvailable >= iSize then
         Queue.Read(sBuffer, iTempBytesRead, iSize);
         bBytesRead := true;
       --  --Ada.Text_IO.Put_Line("bBytesRead := true");
      else
         bBytesRead := false;
         ----Ada.Text_IO.Put_Line("bBytesRead := false");
      end if;

   end Usart_Read;

   procedure Usart_Read_Inf_Block(sBuffer : out String; iSize : Integer) is
      bReadCompleate : Boolean := false;
   begin
      while not bReadCompleate loop
         Usart_Read(sBuffer, iSize, bReadCompleate);
      end loop;

   Exception
      when E : others =>
         Exception_Handling.Reraise_Exception(E       => E,
                                              Message => "BBB_CAN.Usart_Read_Inf_Block(sBuffer : out String; iSize : Integer)");
   end Usart_Read_Inf_Block;

end BBB_CAN;