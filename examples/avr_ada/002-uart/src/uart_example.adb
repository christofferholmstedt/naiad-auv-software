-- Example from http://sourceforge.net/p/avr-ada/wiki/Echo/

with AVR;                          use AVR;
with AVR.MCU;
with AVR.UART;

procedure UART_Example is
   C : Character;
begin
   UART.Init (UART.Baud_19200_16MHz);
   loop
      C := UART.Get;
      UART.Put (C);
   end loop;
end UART_Example;
