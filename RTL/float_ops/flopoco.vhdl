--------------------------------------------------------------------------------
--                      InputIEEE_8_23_to_8_23_comb_uid2
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin (2008)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X
-- Output signals: R
--  approx. input signal timings: X: 0.000000ns
--  approx. output signal timings: R: 0.000000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity InputIEEE_8_23_to_8_23_comb_uid2 is
    port (X : in  std_logic_vector(31 downto 0);
          R : out  std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of InputIEEE_8_23_to_8_23_comb_uid2 is
signal expX :  std_logic_vector(7 downto 0);
   -- timing of expX: 0.000000ns
signal fracX :  std_logic_vector(22 downto 0);
   -- timing of fracX: 0.000000ns
signal sX :  std_logic;
   -- timing of sX: 0.000000ns
signal expZero :  std_logic;
   -- timing of expZero: 0.000000ns
signal expInfty :  std_logic;
   -- timing of expInfty: 0.000000ns
signal fracZero :  std_logic;
   -- timing of fracZero: 0.000000ns
signal reprSubNormal :  std_logic;
   -- timing of reprSubNormal: 0.000000ns
signal sfracX :  std_logic_vector(22 downto 0);
   -- timing of sfracX: 0.000000ns
signal fracR :  std_logic_vector(22 downto 0);
   -- timing of fracR: 0.000000ns
signal expR :  std_logic_vector(7 downto 0);
   -- timing of expR: 0.000000ns
signal infinity :  std_logic;
   -- timing of infinity: 0.000000ns
signal zero :  std_logic;
   -- timing of zero: 0.000000ns
signal NaN :  std_logic;
   -- timing of NaN: 0.000000ns
signal exnR :  std_logic_vector(1 downto 0);
   -- timing of exnR: 0.000000ns
begin
   expX  <= X(30 downto 23);
   fracX  <= X(22 downto 0);
   sX  <= X(31);
   expZero  <= '1' when expX = (7 downto 0 => '0') else '0';
   expInfty  <= '1' when expX = (7 downto 0 => '1') else '0';
   fracZero <= '1' when fracX = (22 downto 0 => '0') else '0';
   reprSubNormal <= fracX(22);
   -- since we have one more exponent value than IEEE (field 0...0, value emin-1),
   -- we can represent subnormal numbers whose mantissa field begins with a 1
   sfracX <= fracX(21 downto 0) & '0' when (expZero='1' and reprSubNormal='1')    else fracX;
   fracR <= sfracX;
   -- copy exponent. This will be OK even for subnormals, zero and infty since in such cases the exn bits will prevail
   expR <= expX;
   infinity <= expInfty and fracZero;
   zero <= expZero and not reprSubNormal;
   NaN <= expInfty and not fracZero;
   exnR <= 
           "00" when zero='1' 
      else "10" when infinity='1' 
      else "11" when NaN='1' 
      else "01" ;  -- normal number
   R <= exnR & sX & expR & fracR; 
end architecture;

--------------------------------------------------------------------------------
--                     OutputIEEE_8_23_to_8_23_comb_uid4
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: F. Ferrandi  (2009-2012)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X
-- Output signals: R
--  approx. input signal timings: X: 0.000000ns
--  approx. output signal timings: R: 0.100000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity OutputIEEE_8_23_to_8_23_comb_uid4 is
    port (X : in  std_logic_vector(8+23+2 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of OutputIEEE_8_23_to_8_23_comb_uid4 is
signal fracX :  std_logic_vector(22 downto 0);
   -- timing of fracX: 0.000000ns
signal exnX :  std_logic_vector(1 downto 0);
   -- timing of exnX: 0.000000ns
signal expX :  std_logic_vector(7 downto 0);
   -- timing of expX: 0.000000ns
signal sX :  std_logic;
   -- timing of sX: 0.050000ns
signal expZero :  std_logic;
   -- timing of expZero: 0.050000ns
signal fracR :  std_logic_vector(22 downto 0);
   -- timing of fracR: 0.100000ns
signal expR :  std_logic_vector(7 downto 0);
   -- timing of expR: 0.050000ns
begin
   fracX  <= X(22 downto 0);
   exnX  <= X(33 downto 32);
   expX  <= X(30 downto 23);
   sX  <= X(31) when (exnX = "01" or exnX = "10" or exnX = "00") else '0';
   expZero  <= '1' when expX = (7 downto 0 => '0') else '0';
   -- since we have one more exponent value than IEEE (field 0...0, value emin-1),
   -- we can represent subnormal numbers whose mantissa field begins with a 1
   fracR <= 
      "00000000000000000000000" when (exnX = "00") else
      '1' & fracX(22 downto 1) & "" when (expZero = '1' and exnX = "01") else
      fracX  & "" when (exnX = "01") else
      "0000000000000000000000" & exnX(0);
   expR <=  
      (7 downto 0 => '0') when (exnX = "00") else
      expX when (exnX = "01") else 
      (7 downto 0 => '1');
   R <= sX & expR & fracR; 
end architecture;

--------------------------------------------------------------------------------
--                  RightShifterSticky24_by_max_26_comb_uid8
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X S
-- Output signals: R Sticky
--  approx. input signal timings: X: 2.260000nsS: 2.830000ns
--  approx. output signal timings: R: 3.930000nsSticky: 6.220000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity RightShifterSticky24_by_max_26_comb_uid8 is
    port (X : in  std_logic_vector(23 downto 0);
          S : in  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(25 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky24_by_max_26_comb_uid8 is
signal ps :  std_logic_vector(4 downto 0);
   -- timing of ps: 2.830000ns
signal Xpadded :  std_logic_vector(25 downto 0);
   -- timing of Xpadded: 2.260000ns
signal level5 :  std_logic_vector(25 downto 0);
   -- timing of level5: 2.260000ns
signal stk4 :  std_logic;
   -- timing of stk4: 3.420000ns
signal level4 :  std_logic_vector(25 downto 0);
   -- timing of level4: 2.830000ns
signal stk3 :  std_logic;
   -- timing of stk3: 3.990000ns
signal level3 :  std_logic_vector(25 downto 0);
   -- timing of level3: 3.380000ns
signal stk2 :  std_logic;
   -- timing of stk2: 4.550000ns
signal level2 :  std_logic_vector(25 downto 0);
   -- timing of level2: 3.380000ns
signal stk1 :  std_logic;
   -- timing of stk1: 5.110000ns
signal level1 :  std_logic_vector(25 downto 0);
   -- timing of level1: 3.930000ns
signal stk0 :  std_logic;
   -- timing of stk0: 5.670000ns
signal level0 :  std_logic_vector(25 downto 0);
   -- timing of level0: 3.930000ns
signal stk :  std_logic;
   -- timing of stk: 6.220000ns
begin
   ps<= S;
   Xpadded <= X&(1 downto 0 => '0');
   level5<= Xpadded;
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1')   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => '0') & level5(25 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => '0') & level4(25 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => '0') & level3(25 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => '0') & level2(25 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => '0') & level1(25 downto 1);
   stk <= stk0;
   R <= level0;
   Sticky <= stk;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_27_comb_uid10
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y Cin
-- Output signals: R
--  approx. input signal timings: X: 1.710000nsY: 4.480000nsCin: 6.770000ns
--  approx. output signal timings: R: 8.030000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_27_comb_uid10 is
    port (X : in  std_logic_vector(26 downto 0);
          Y : in  std_logic_vector(26 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(26 downto 0)   );
end entity;

architecture arch of IntAdder_27_comb_uid10 is
signal Rtmp :  std_logic_vector(26 downto 0);
   -- timing of Rtmp: 8.030000ns
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                      Normalizer_Z_28_28_28_comb_uid12
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, (2007-2020)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X
-- Output signals: Count R
--  approx. input signal timings: X: 8.030000ns
--  approx. output signal timings: Count: 13.070000nsR: 13.620000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Normalizer_Z_28_28_28_comb_uid12 is
    port (X : in  std_logic_vector(27 downto 0);
          Count : out  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(27 downto 0)   );
end entity;

architecture arch of Normalizer_Z_28_28_28_comb_uid12 is
signal level5 :  std_logic_vector(27 downto 0);
   -- timing of level5: 8.030000ns
signal count4 :  std_logic;
   -- timing of count4: 8.620000ns
signal level4 :  std_logic_vector(27 downto 0);
   -- timing of level4: 9.170000ns
signal count3 :  std_logic;
   -- timing of count3: 9.740000ns
signal level3 :  std_logic_vector(27 downto 0);
   -- timing of level3: 10.290000ns
signal count2 :  std_logic;
   -- timing of count2: 10.850000ns
signal level2 :  std_logic_vector(27 downto 0);
   -- timing of level2: 11.400000ns
signal count1 :  std_logic;
   -- timing of count1: 11.960000ns
signal level1 :  std_logic_vector(27 downto 0);
   -- timing of level1: 12.510000ns
signal count0 :  std_logic;
   -- timing of count0: 13.070000ns
signal level0 :  std_logic_vector(27 downto 0);
   -- timing of level0: 13.620000ns
signal sCount :  std_logic_vector(4 downto 0);
   -- timing of sCount: 13.070000ns
begin
   level5 <= X ;
   count4<= '1' when level5(27 downto 12) = (27 downto 12=>'0') else '0';
   level4<= level5(27 downto 0) when count4='0' else level5(11 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(27 downto 20) = (27 downto 20=>'0') else '0';
   level3<= level4(27 downto 0) when count3='0' else level4(19 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(27 downto 24) = (27 downto 24=>'0') else '0';
   level2<= level3(27 downto 0) when count2='0' else level3(23 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(27 downto 26) = (27 downto 26=>'0') else '0';
   level1<= level2(27 downto 0) when count1='0' else level2(25 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(27 downto 27) = (27 downto 27=>'0') else '0';
   level0<= level1(27 downto 0) when count0='0' else level1(26 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_34_comb_uid15
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y Cin
-- Output signals: R
--  approx. input signal timings: X: 14.160000nsY: 0.000000nsCin: 14.170000ns
--  approx. output signal timings: R: 15.500000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_34_comb_uid15 is
    port (X : in  std_logic_vector(33 downto 0);
          Y : in  std_logic_vector(33 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(33 downto 0)   );
end entity;

architecture arch of IntAdder_34_comb_uid15 is
signal Rtmp :  std_logic_vector(33 downto 0);
   -- timing of Rtmp: 15.500000ns
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                            FPAdd_8_23_comb_uid6
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2010-2017)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y
-- Output signals: R
--  approx. input signal timings: X: 0.000000nsY: 0.000000ns
--  approx. output signal timings: R: 16.600000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdd_8_23_comb_uid6 is
    port (X : in  std_logic_vector(8+23+2 downto 0);
          Y : in  std_logic_vector(8+23+2 downto 0);
          R : out  std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPAdd_8_23_comb_uid6 is
   component RightShifterSticky24_by_max_26_comb_uid8 is
      port ( X : in  std_logic_vector(23 downto 0);
             S : in  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(25 downto 0);
             Sticky : out  std_logic   );
   end component;

   component IntAdder_27_comb_uid10 is
      port ( X : in  std_logic_vector(26 downto 0);
             Y : in  std_logic_vector(26 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(26 downto 0)   );
   end component;

   component Normalizer_Z_28_28_28_comb_uid12 is
      port ( X : in  std_logic_vector(27 downto 0);
             Count : out  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(27 downto 0)   );
   end component;

   component IntAdder_34_comb_uid15 is
      port ( X : in  std_logic_vector(33 downto 0);
             Y : in  std_logic_vector(33 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(33 downto 0)   );
   end component;

signal excExpFracX :  std_logic_vector(32 downto 0);
   -- timing of excExpFracX: 0.000000ns
signal excExpFracY :  std_logic_vector(32 downto 0);
   -- timing of excExpFracY: 0.000000ns
signal swap :  std_logic;
   -- timing of swap: 1.160000ns
signal eXmeY :  std_logic_vector(7 downto 0);
   -- timing of eXmeY: 1.080000ns
signal eYmeX :  std_logic_vector(7 downto 0);
   -- timing of eYmeX: 1.080000ns
signal expDiff :  std_logic_vector(7 downto 0);
   -- timing of expDiff: 1.710000ns
signal newX :  std_logic_vector(33 downto 0);
   -- timing of newX: 1.710000ns
signal newY :  std_logic_vector(33 downto 0);
   -- timing of newY: 1.710000ns
signal expX :  std_logic_vector(7 downto 0);
   -- timing of expX: 1.710000ns
signal excX :  std_logic_vector(1 downto 0);
   -- timing of excX: 1.710000ns
signal excY :  std_logic_vector(1 downto 0);
   -- timing of excY: 1.710000ns
signal signX :  std_logic;
   -- timing of signX: 1.710000ns
signal signY :  std_logic;
   -- timing of signY: 1.710000ns
signal EffSub :  std_logic;
   -- timing of EffSub: 2.260000ns
signal sXsYExnXY :  std_logic_vector(5 downto 0);
   -- timing of sXsYExnXY: 1.710000ns
signal sdExnXY :  std_logic_vector(3 downto 0);
   -- timing of sdExnXY: 1.710000ns
signal fracY :  std_logic_vector(23 downto 0);
   -- timing of fracY: 2.260000ns
signal excRt :  std_logic_vector(1 downto 0);
   -- timing of excRt: 2.310000ns
signal signR :  std_logic;
   -- timing of signR: 2.260000ns
signal shiftedOut :  std_logic;
   -- timing of shiftedOut: 2.280000ns
signal shiftVal :  std_logic_vector(4 downto 0);
   -- timing of shiftVal: 2.830000ns
signal shiftedFracY :  std_logic_vector(25 downto 0);
   -- timing of shiftedFracY: 3.930000ns
signal sticky :  std_logic;
   -- timing of sticky: 6.220000ns
signal fracYpad :  std_logic_vector(26 downto 0);
   -- timing of fracYpad: 3.930000ns
signal EffSubVector :  std_logic_vector(26 downto 0);
   -- timing of EffSubVector: 2.260000ns
signal fracYpadXorOp :  std_logic_vector(26 downto 0);
   -- timing of fracYpadXorOp: 4.480000ns
signal fracXpad :  std_logic_vector(26 downto 0);
   -- timing of fracXpad: 1.710000ns
signal cInSigAdd :  std_logic;
   -- timing of cInSigAdd: 6.770000ns
signal fracAddResult :  std_logic_vector(26 downto 0);
   -- timing of fracAddResult: 8.030000ns
signal fracSticky :  std_logic_vector(27 downto 0);
   -- timing of fracSticky: 8.030000ns
signal nZerosNew :  std_logic_vector(4 downto 0);
   -- timing of nZerosNew: 13.070000ns
signal shiftedFrac :  std_logic_vector(27 downto 0);
   -- timing of shiftedFrac: 13.620000ns
signal extendedExpInc :  std_logic_vector(8 downto 0);
   -- timing of extendedExpInc: 2.790000ns
signal updatedExp :  std_logic_vector(9 downto 0);
   -- timing of updatedExp: 14.160000ns
signal eqdiffsign :  std_logic;
   -- timing of eqdiffsign: 13.070000ns
signal expFrac :  std_logic_vector(33 downto 0);
   -- timing of expFrac: 14.160000ns
signal stk :  std_logic;
   -- timing of stk: 13.620000ns
signal rnd :  std_logic;
   -- timing of rnd: 13.620000ns
signal lsb :  std_logic;
   -- timing of lsb: 13.620000ns
signal needToRound :  std_logic;
   -- timing of needToRound: 14.170000ns
signal RoundedExpFrac :  std_logic_vector(33 downto 0);
   -- timing of RoundedExpFrac: 15.500000ns
signal upExc :  std_logic_vector(1 downto 0);
   -- timing of upExc: 15.500000ns
signal fracR :  std_logic_vector(22 downto 0);
   -- timing of fracR: 15.500000ns
signal expR :  std_logic_vector(7 downto 0);
   -- timing of expR: 15.500000ns
signal exExpExc :  std_logic_vector(3 downto 0);
   -- timing of exExpExc: 15.500000ns
signal excRt2 :  std_logic_vector(1 downto 0);
   -- timing of excRt2: 16.050000ns
signal excR :  std_logic_vector(1 downto 0);
   -- timing of excR: 16.600000ns
signal signR2 :  std_logic;
   -- timing of signR2: 13.620000ns
signal computedR :  std_logic_vector(33 downto 0);
   -- timing of computedR: 16.600000ns
begin
   excExpFracX <= X(33 downto 32) & X(30 downto 0);
   excExpFracY <= Y(33 downto 32) & Y(30 downto 0);
   swap <= '1' when excExpFracX < excExpFracY else '0';
   -- exponent difference
   eXmeY <= (X(30 downto 23)) - (Y(30 downto 23));
   eYmeX <= (Y(30 downto 23)) - (X(30 downto 23));
   expDiff <= eXmeY when swap = '0' else eYmeX;
   -- input swap so that |X|>|Y|
   newX <= X when swap = '0' else Y;
   newY <= Y when swap = '0' else X;
   -- now we decompose the inputs into their sign, exponent, fraction
   expX<= newX(30 downto 23);
   excX<= newX(33 downto 32);
   excY<= newY(33 downto 32);
   signX<= newX(31);
   signY<= newY(31);
   EffSub <= signX xor signY;
   sXsYExnXY <= signX & signY & excX & excY;
   sdExnXY <= excX & excY;
   fracY <= "000000000000000000000000" when excY="00" else ('1' & newY(22 downto 0));
   -- Exception management logic
   with sXsYExnXY  select  
   excRt <= "00" when "000000"|"010000"|"100000"|"110000",
      "01" when "000101"|"010101"|"100101"|"110101"|"000100"|"010100"|"100100"|"110100"|"000001"|"010001"|"100001"|"110001",
      "10" when "111010"|"001010"|"001000"|"011000"|"101000"|"111000"|"000010"|"010010"|"100010"|"110010"|"001001"|"011001"|"101001"|"111001"|"000110"|"010110"|"100110"|"110110", 
      "11" when others;
   signR<= '0' when (sXsYExnXY="100000" or sXsYExnXY="010000") else signX;
   shiftedOut <= '1' when (expDiff > 25) else '0';
   shiftVal <= expDiff(4 downto 0) when shiftedOut='0' else CONV_STD_LOGIC_VECTOR(26,5);
   RightShifterComponent: RightShifterSticky24_by_max_26_comb_uid8
      port map ( S => shiftVal,
                 X => fracY,
                 R => shiftedFracY,
                 Sticky => sticky);
   fracYpad <= "0" & shiftedFracY;
   EffSubVector <= (26 downto 0 => EffSub);
   fracYpadXorOp <= fracYpad xor EffSubVector;
   fracXpad <= "01" & (newX(22 downto 0)) & "00";
   cInSigAdd <= EffSub and not sticky; -- if we subtract and the sticky was one, some of the negated sticky bits would have absorbed this carry 
   fracAdder: IntAdder_27_comb_uid10
      port map ( Cin => cInSigAdd,
                 X => fracXpad,
                 Y => fracYpadXorOp,
                 R => fracAddResult);
   fracSticky<= fracAddResult & sticky; 
   LZCAndShifter: Normalizer_Z_28_28_28_comb_uid12
      port map ( X => fracSticky,
                 Count => nZerosNew,
                 R => shiftedFrac);
   extendedExpInc<= ("0" & expX) + '1';
   updatedExp <= ("0" &extendedExpInc) - ("00000" & nZerosNew);
   eqdiffsign <= '1' when nZerosNew="11111" else '0';
   expFrac<= updatedExp & shiftedFrac(26 downto 3);
   stk<= shiftedFrac(2) or shiftedFrac(1) or shiftedFrac(0);
   rnd<= shiftedFrac(3);
   lsb<= shiftedFrac(4);
   needToRound<= '1' when (rnd='1' and stk='1') or (rnd='1' and stk='0' and lsb='1')
  else '0';
   roundingAdder: IntAdder_34_comb_uid15
      port map ( Cin => needToRound,
                 X => expFrac,
                 Y => "0000000000000000000000000000000000",
                 R => RoundedExpFrac);
   -- possible update to exception bits
   upExc <= RoundedExpFrac(33 downto 32);
   fracR <= RoundedExpFrac(23 downto 1);
   expR <= RoundedExpFrac(31 downto 24);
   exExpExc <= upExc & excRt;
   with exExpExc  select  
   excRt2<= "00" when "0000"|"0100"|"1000"|"1100"|"1001"|"1101",
      "01" when "0001",
      "10" when "0010"|"0110"|"1010"|"1110"|"0101",
      "11" when others;
   excR <= "00" when (eqdiffsign='1' and EffSub='1'  and not(excRt="11")) else excRt2;
   signR2 <= '0' when (eqdiffsign='1' and EffSub='1') else signR;
   computedR <= excR & signR2 & expR & fracR;
   R <= computedR;
end architecture;

--------------------------------------------------------------------------------
--                 RightShifterSticky24_by_max_26_comb_uid19
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca (2008-2011), Florent de Dinechin (2008-2019)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X S
-- Output signals: R Sticky
--  approx. input signal timings: X: 2.260000nsS: 2.830000ns
--  approx. output signal timings: R: 3.930000nsSticky: 6.220000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity RightShifterSticky24_by_max_26_comb_uid19 is
    port (X : in  std_logic_vector(23 downto 0);
          S : in  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(25 downto 0);
          Sticky : out  std_logic   );
end entity;

architecture arch of RightShifterSticky24_by_max_26_comb_uid19 is
signal ps :  std_logic_vector(4 downto 0);
   -- timing of ps: 2.830000ns
signal Xpadded :  std_logic_vector(25 downto 0);
   -- timing of Xpadded: 2.260000ns
signal level5 :  std_logic_vector(25 downto 0);
   -- timing of level5: 2.260000ns
signal stk4 :  std_logic;
   -- timing of stk4: 3.420000ns
signal level4 :  std_logic_vector(25 downto 0);
   -- timing of level4: 2.830000ns
signal stk3 :  std_logic;
   -- timing of stk3: 3.990000ns
signal level3 :  std_logic_vector(25 downto 0);
   -- timing of level3: 3.380000ns
signal stk2 :  std_logic;
   -- timing of stk2: 4.550000ns
signal level2 :  std_logic_vector(25 downto 0);
   -- timing of level2: 3.380000ns
signal stk1 :  std_logic;
   -- timing of stk1: 5.110000ns
signal level1 :  std_logic_vector(25 downto 0);
   -- timing of level1: 3.930000ns
signal stk0 :  std_logic;
   -- timing of stk0: 5.670000ns
signal level0 :  std_logic_vector(25 downto 0);
   -- timing of level0: 3.930000ns
signal stk :  std_logic;
   -- timing of stk: 6.220000ns
begin
   ps<= S;
   Xpadded <= X&(1 downto 0 => '0');
   level5<= Xpadded;
   stk4 <= '1' when (level5(15 downto 0)/="0000000000000000" and ps(4)='1')   else '0';
   level4 <=  level5 when  ps(4)='0'    else (15 downto 0 => '0') & level5(25 downto 16);
   stk3 <= '1' when (level4(7 downto 0)/="00000000" and ps(3)='1') or stk4 ='1'   else '0';
   level3 <=  level4 when  ps(3)='0'    else (7 downto 0 => '0') & level4(25 downto 8);
   stk2 <= '1' when (level3(3 downto 0)/="0000" and ps(2)='1') or stk3 ='1'   else '0';
   level2 <=  level3 when  ps(2)='0'    else (3 downto 0 => '0') & level3(25 downto 4);
   stk1 <= '1' when (level2(1 downto 0)/="00" and ps(1)='1') or stk2 ='1'   else '0';
   level1 <=  level2 when  ps(1)='0'    else (1 downto 0 => '0') & level2(25 downto 2);
   stk0 <= '1' when (level1(0 downto 0)/="0" and ps(0)='1') or stk1 ='1'   else '0';
   level0 <=  level1 when  ps(0)='0'    else (0 downto 0 => '0') & level1(25 downto 1);
   stk <= stk0;
   R <= level0;
   Sticky <= stk;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_27_comb_uid21
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y Cin
-- Output signals: R
--  approx. input signal timings: X: 1.710000nsY: 4.480000nsCin: 6.770000ns
--  approx. output signal timings: R: 8.030000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_27_comb_uid21 is
    port (X : in  std_logic_vector(26 downto 0);
          Y : in  std_logic_vector(26 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(26 downto 0)   );
end entity;

architecture arch of IntAdder_27_comb_uid21 is
signal Rtmp :  std_logic_vector(26 downto 0);
   -- timing of Rtmp: 8.030000ns
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                      Normalizer_Z_28_28_28_comb_uid23
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, (2007-2020)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X
-- Output signals: Count R
--  approx. input signal timings: X: 8.030000ns
--  approx. output signal timings: Count: 13.070000nsR: 13.620000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Normalizer_Z_28_28_28_comb_uid23 is
    port (X : in  std_logic_vector(27 downto 0);
          Count : out  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(27 downto 0)   );
end entity;

architecture arch of Normalizer_Z_28_28_28_comb_uid23 is
signal level5 :  std_logic_vector(27 downto 0);
   -- timing of level5: 8.030000ns
signal count4 :  std_logic;
   -- timing of count4: 8.620000ns
signal level4 :  std_logic_vector(27 downto 0);
   -- timing of level4: 9.170000ns
signal count3 :  std_logic;
   -- timing of count3: 9.740000ns
signal level3 :  std_logic_vector(27 downto 0);
   -- timing of level3: 10.290000ns
signal count2 :  std_logic;
   -- timing of count2: 10.850000ns
signal level2 :  std_logic_vector(27 downto 0);
   -- timing of level2: 11.400000ns
signal count1 :  std_logic;
   -- timing of count1: 11.960000ns
signal level1 :  std_logic_vector(27 downto 0);
   -- timing of level1: 12.510000ns
signal count0 :  std_logic;
   -- timing of count0: 13.070000ns
signal level0 :  std_logic_vector(27 downto 0);
   -- timing of level0: 13.620000ns
signal sCount :  std_logic_vector(4 downto 0);
   -- timing of sCount: 13.070000ns
begin
   level5 <= X ;
   count4<= '1' when level5(27 downto 12) = (27 downto 12=>'0') else '0';
   level4<= level5(27 downto 0) when count4='0' else level5(11 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(27 downto 20) = (27 downto 20=>'0') else '0';
   level3<= level4(27 downto 0) when count3='0' else level4(19 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(27 downto 24) = (27 downto 24=>'0') else '0';
   level2<= level3(27 downto 0) when count2='0' else level3(23 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(27 downto 26) = (27 downto 26=>'0') else '0';
   level1<= level2(27 downto 0) when count1='0' else level2(25 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(27 downto 27) = (27 downto 27=>'0') else '0';
   level0<= level1(27 downto 0) when count0='0' else level1(26 downto 0) & (0 downto 0 => '0');

   R <= level0;
   sCount <= count4 & count3 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_34_comb_uid26
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y Cin
-- Output signals: R
--  approx. input signal timings: X: 14.160000nsY: 0.000000nsCin: 14.170000ns
--  approx. output signal timings: R: 15.500000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_34_comb_uid26 is
    port (X : in  std_logic_vector(33 downto 0);
          Y : in  std_logic_vector(33 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(33 downto 0)   );
end entity;

architecture arch of IntAdder_34_comb_uid26 is
signal Rtmp :  std_logic_vector(33 downto 0);
   -- timing of Rtmp: 15.500000ns
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                           FPSub_8_23_comb_uid17
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2010-2017)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y
-- Output signals: R
--  approx. input signal timings: X: 0.000000nsY: 0.000000ns
--  approx. output signal timings: R: 16.600000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPSub_8_23_comb_uid17 is
    port (X : in  std_logic_vector(8+23+2 downto 0);
          Y : in  std_logic_vector(8+23+2 downto 0);
          R : out  std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPSub_8_23_comb_uid17 is
   component RightShifterSticky24_by_max_26_comb_uid19 is
      port ( X : in  std_logic_vector(23 downto 0);
             S : in  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(25 downto 0);
             Sticky : out  std_logic   );
   end component;

   component IntAdder_27_comb_uid21 is
      port ( X : in  std_logic_vector(26 downto 0);
             Y : in  std_logic_vector(26 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(26 downto 0)   );
   end component;

   component Normalizer_Z_28_28_28_comb_uid23 is
      port ( X : in  std_logic_vector(27 downto 0);
             Count : out  std_logic_vector(4 downto 0);
             R : out  std_logic_vector(27 downto 0)   );
   end component;

   component IntAdder_34_comb_uid26 is
      port ( X : in  std_logic_vector(33 downto 0);
             Y : in  std_logic_vector(33 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(33 downto 0)   );
   end component;

signal excExpFracX :  std_logic_vector(32 downto 0);
   -- timing of excExpFracX: 0.000000ns
signal excExpFracY :  std_logic_vector(32 downto 0);
   -- timing of excExpFracY: 0.000000ns
signal swap :  std_logic;
   -- timing of swap: 1.160000ns
signal eXmeY :  std_logic_vector(7 downto 0);
   -- timing of eXmeY: 1.080000ns
signal eYmeX :  std_logic_vector(7 downto 0);
   -- timing of eYmeX: 1.080000ns
signal expDiff :  std_logic_vector(7 downto 0);
   -- timing of expDiff: 1.710000ns
signal mY :  std_logic_vector(33 downto 0);
   -- timing of mY: 0.550000ns
signal newX :  std_logic_vector(33 downto 0);
   -- timing of newX: 1.710000ns
signal newY :  std_logic_vector(33 downto 0);
   -- timing of newY: 1.710000ns
signal expX :  std_logic_vector(7 downto 0);
   -- timing of expX: 1.710000ns
signal excX :  std_logic_vector(1 downto 0);
   -- timing of excX: 1.710000ns
signal excY :  std_logic_vector(1 downto 0);
   -- timing of excY: 1.710000ns
signal signX :  std_logic;
   -- timing of signX: 1.710000ns
signal signY :  std_logic;
   -- timing of signY: 1.710000ns
signal EffSub :  std_logic;
   -- timing of EffSub: 2.260000ns
signal sXsYExnXY :  std_logic_vector(5 downto 0);
   -- timing of sXsYExnXY: 1.710000ns
signal sdExnXY :  std_logic_vector(3 downto 0);
   -- timing of sdExnXY: 1.710000ns
signal fracY :  std_logic_vector(23 downto 0);
   -- timing of fracY: 2.260000ns
signal excRt :  std_logic_vector(1 downto 0);
   -- timing of excRt: 2.310000ns
signal signR :  std_logic;
   -- timing of signR: 2.260000ns
signal shiftedOut :  std_logic;
   -- timing of shiftedOut: 2.280000ns
signal shiftVal :  std_logic_vector(4 downto 0);
   -- timing of shiftVal: 2.830000ns
signal shiftedFracY :  std_logic_vector(25 downto 0);
   -- timing of shiftedFracY: 3.930000ns
signal sticky :  std_logic;
   -- timing of sticky: 6.220000ns
signal fracYpad :  std_logic_vector(26 downto 0);
   -- timing of fracYpad: 3.930000ns
signal EffSubVector :  std_logic_vector(26 downto 0);
   -- timing of EffSubVector: 2.260000ns
signal fracYpadXorOp :  std_logic_vector(26 downto 0);
   -- timing of fracYpadXorOp: 4.480000ns
signal fracXpad :  std_logic_vector(26 downto 0);
   -- timing of fracXpad: 1.710000ns
signal cInSigAdd :  std_logic;
   -- timing of cInSigAdd: 6.770000ns
signal fracAddResult :  std_logic_vector(26 downto 0);
   -- timing of fracAddResult: 8.030000ns
signal fracSticky :  std_logic_vector(27 downto 0);
   -- timing of fracSticky: 8.030000ns
signal nZerosNew :  std_logic_vector(4 downto 0);
   -- timing of nZerosNew: 13.070000ns
signal shiftedFrac :  std_logic_vector(27 downto 0);
   -- timing of shiftedFrac: 13.620000ns
signal extendedExpInc :  std_logic_vector(8 downto 0);
   -- timing of extendedExpInc: 2.790000ns
signal updatedExp :  std_logic_vector(9 downto 0);
   -- timing of updatedExp: 14.160000ns
signal eqdiffsign :  std_logic;
   -- timing of eqdiffsign: 13.070000ns
signal expFrac :  std_logic_vector(33 downto 0);
   -- timing of expFrac: 14.160000ns
signal stk :  std_logic;
   -- timing of stk: 13.620000ns
signal rnd :  std_logic;
   -- timing of rnd: 13.620000ns
signal lsb :  std_logic;
   -- timing of lsb: 13.620000ns
signal needToRound :  std_logic;
   -- timing of needToRound: 14.170000ns
signal RoundedExpFrac :  std_logic_vector(33 downto 0);
   -- timing of RoundedExpFrac: 15.500000ns
signal upExc :  std_logic_vector(1 downto 0);
   -- timing of upExc: 15.500000ns
signal fracR :  std_logic_vector(22 downto 0);
   -- timing of fracR: 15.500000ns
signal expR :  std_logic_vector(7 downto 0);
   -- timing of expR: 15.500000ns
signal exExpExc :  std_logic_vector(3 downto 0);
   -- timing of exExpExc: 15.500000ns
signal excRt2 :  std_logic_vector(1 downto 0);
   -- timing of excRt2: 16.050000ns
signal excR :  std_logic_vector(1 downto 0);
   -- timing of excR: 16.600000ns
signal signR2 :  std_logic;
   -- timing of signR2: 13.620000ns
signal computedR :  std_logic_vector(33 downto 0);
   -- timing of computedR: 16.600000ns
begin
   excExpFracX <= X(33 downto 32) & X(30 downto 0);
   excExpFracY <= Y(33 downto 32) & Y(30 downto 0);
   swap <= '1' when excExpFracX < excExpFracY else '0';
   -- exponent difference
   eXmeY <= (X(30 downto 23)) - (Y(30 downto 23));
   eYmeX <= (Y(30 downto 23)) - (X(30 downto 23));
   expDiff <= eXmeY when swap = '0' else eYmeX;
   mY <= Y(33 downto 32) & not(Y(31)) & Y(30 downto 0);
   -- input swap so that |X|>|Y|
   newX <= X when swap = '0' else mY;
   newY <= mY when swap = '0' else X;
   -- now we decompose the inputs into their sign, exponent, fraction
   expX<= newX(30 downto 23);
   excX<= newX(33 downto 32);
   excY<= newY(33 downto 32);
   signX<= newX(31);
   signY<= newY(31);
   EffSub <= signX xor signY;
   sXsYExnXY <= signX & signY & excX & excY;
   sdExnXY <= excX & excY;
   fracY <= "000000000000000000000000" when excY="00" else ('1' & newY(22 downto 0));
   -- Exception management logic
   with sXsYExnXY  select  
   excRt <= "00" when "000000"|"010000"|"100000"|"110000",
      "01" when "000101"|"010101"|"100101"|"110101"|"000100"|"010100"|"100100"|"110100"|"000001"|"010001"|"100001"|"110001",
      "10" when "111010"|"001010"|"001000"|"011000"|"101000"|"111000"|"000010"|"010010"|"100010"|"110010"|"001001"|"011001"|"101001"|"111001"|"000110"|"010110"|"100110"|"110110", 
      "11" when others;
   signR<= '0' when (sXsYExnXY="100000" or sXsYExnXY="010000") else signX;
   shiftedOut <= '1' when (expDiff > 25) else '0';
   shiftVal <= expDiff(4 downto 0) when shiftedOut='0' else CONV_STD_LOGIC_VECTOR(26,5);
   RightShifterComponent: RightShifterSticky24_by_max_26_comb_uid19
      port map ( S => shiftVal,
                 X => fracY,
                 R => shiftedFracY,
                 Sticky => sticky);
   fracYpad <= "0" & shiftedFracY;
   EffSubVector <= (26 downto 0 => EffSub);
   fracYpadXorOp <= fracYpad xor EffSubVector;
   fracXpad <= "01" & (newX(22 downto 0)) & "00";
   cInSigAdd <= EffSub and not sticky; -- if we subtract and the sticky was one, some of the negated sticky bits would have absorbed this carry 
   fracAdder: IntAdder_27_comb_uid21
      port map ( Cin => cInSigAdd,
                 X => fracXpad,
                 Y => fracYpadXorOp,
                 R => fracAddResult);
   fracSticky<= fracAddResult & sticky; 
   LZCAndShifter: Normalizer_Z_28_28_28_comb_uid23
      port map ( X => fracSticky,
                 Count => nZerosNew,
                 R => shiftedFrac);
   extendedExpInc<= ("0" & expX) + '1';
   updatedExp <= ("0" &extendedExpInc) - ("00000" & nZerosNew);
   eqdiffsign <= '1' when nZerosNew="11111" else '0';
   expFrac<= updatedExp & shiftedFrac(26 downto 3);
   stk<= shiftedFrac(2) or shiftedFrac(1) or shiftedFrac(0);
   rnd<= shiftedFrac(3);
   lsb<= shiftedFrac(4);
   needToRound<= '1' when (rnd='1' and stk='1') or (rnd='1' and stk='0' and lsb='1')
  else '0';
   roundingAdder: IntAdder_34_comb_uid26
      port map ( Cin => needToRound,
                 X => expFrac,
                 Y => "0000000000000000000000000000000000",
                 R => RoundedExpFrac);
   -- possible update to exception bits
   upExc <= RoundedExpFrac(33 downto 32);
   fracR <= RoundedExpFrac(23 downto 1);
   expR <= RoundedExpFrac(31 downto 24);
   exExpExc <= upExc & excRt;
   with exExpExc  select  
   excRt2<= "00" when "0000"|"0100"|"1000"|"1100"|"1001"|"1101",
      "01" when "0001",
      "10" when "0010"|"0110"|"1010"|"1110"|"0101",
      "11" when others;
   excR <= "00" when (eqdiffsign='1' and EffSub='1'  and not(excRt="11")) else excRt2;
   signR2 <= '0' when (eqdiffsign='1' and EffSub='1') else signR;
   computedR <= excR & signR2 & expR & fracR;
   R <= computedR;
end architecture;

--------------------------------------------------------------------------------
--                     IntMultiplier_24x24_48_comb_uid31
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Martin Kumm, Florent de Dinechin, Andreas Böttcher, Kinga Illyes, Bogdan Popa, Bogdan Pasca, 2012-
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y
-- Output signals: R
--  approx. input signal timings: X: 0.000000nsY: 0.000000ns
--  approx. output signal timings: R: 0.000000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntMultiplier_24x24_48_comb_uid31 is
    port (X : in  std_logic_vector(23 downto 0);
          Y : in  std_logic_vector(23 downto 0);
          R : out  std_logic_vector(47 downto 0)   );
end entity;

architecture arch of IntMultiplier_24x24_48_comb_uid31 is
signal XX_m32 :  std_logic_vector(23 downto 0);
   -- timing of XX_m32: 0.000000ns
signal YY_m32 :  std_logic_vector(23 downto 0);
   -- timing of YY_m32: 0.000000ns
signal XX :  unsigned(-1+24 downto 0);
   -- timing of XX: 0.000000ns
signal YY :  unsigned(-1+24 downto 0);
   -- timing of YY: 0.000000ns
signal RR :  unsigned(-1+48 downto 0);
   -- timing of RR: 0.000000ns
begin
   XX_m32 <= X ;
   YY_m32 <= Y ;
   XX <= unsigned(X);
   YY <= unsigned(Y);
   RR <= XX*YY;
   R <= std_logic_vector(RR(47 downto 0));
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_33_comb_uid35
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2016)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y Cin
-- Output signals: R
--  approx. input signal timings: X: 2.180000nsY: 0.000000nsCin: 1.700000ns
--  approx. output signal timings: R: 3.500000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_33_comb_uid35 is
    port (X : in  std_logic_vector(32 downto 0);
          Y : in  std_logic_vector(32 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(32 downto 0)   );
end entity;

architecture arch of IntAdder_33_comb_uid35 is
signal Rtmp :  std_logic_vector(32 downto 0);
   -- timing of Rtmp: 3.500000ns
begin
   Rtmp <= X + Y + Cin;
   R <= Rtmp;
end architecture;

--------------------------------------------------------------------------------
--                        FPMult_8_23_uid28_comb_uid29
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin 2008-2021
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y
-- Output signals: R
--  approx. input signal timings: X: 0.000000nsY: 0.000000ns
--  approx. output signal timings: R: 3.500000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPMult_8_23_uid28_comb_uid29 is
    port (X : in  std_logic_vector(8+23+2 downto 0);
          Y : in  std_logic_vector(8+23+2 downto 0);
          R : out  std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPMult_8_23_uid28_comb_uid29 is
   component IntMultiplier_24x24_48_comb_uid31 is
      port ( X : in  std_logic_vector(23 downto 0);
             Y : in  std_logic_vector(23 downto 0);
             R : out  std_logic_vector(47 downto 0)   );
   end component;

   component IntAdder_33_comb_uid35 is
      port ( X : in  std_logic_vector(32 downto 0);
             Y : in  std_logic_vector(32 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(32 downto 0)   );
   end component;

signal sign :  std_logic;
   -- timing of sign: 0.050000ns
signal expX :  std_logic_vector(7 downto 0);
   -- timing of expX: 0.000000ns
signal expY :  std_logic_vector(7 downto 0);
   -- timing of expY: 0.000000ns
signal expSumPreSub :  std_logic_vector(9 downto 0);
   -- timing of expSumPreSub: 1.090000ns
signal bias :  std_logic_vector(9 downto 0);
   -- timing of bias: 0.000000ns
signal expSum :  std_logic_vector(9 downto 0);
   -- timing of expSum: 2.180000ns
signal sigX :  std_logic_vector(23 downto 0);
   -- timing of sigX: 0.000000ns
signal sigY :  std_logic_vector(23 downto 0);
   -- timing of sigY: 0.000000ns
signal sigProd :  std_logic_vector(47 downto 0);
   -- timing of sigProd: 0.000000ns
signal excSel :  std_logic_vector(3 downto 0);
   -- timing of excSel: 0.000000ns
signal exc :  std_logic_vector(1 downto 0);
   -- timing of exc: 0.050000ns
signal norm :  std_logic;
   -- timing of norm: 0.000000ns
signal expPostNorm :  std_logic_vector(9 downto 0);
   -- timing of expPostNorm: 2.180000ns
signal sigProdExt :  std_logic_vector(47 downto 0);
   -- timing of sigProdExt: 0.550000ns
signal expSig :  std_logic_vector(32 downto 0);
   -- timing of expSig: 2.180000ns
signal sticky :  std_logic;
   -- timing of sticky: 0.550000ns
signal guard :  std_logic;
   -- timing of guard: 1.150000ns
signal round :  std_logic;
   -- timing of round: 1.700000ns
signal expSigPostRound :  std_logic_vector(32 downto 0);
   -- timing of expSigPostRound: 3.500000ns
signal excPostNorm :  std_logic_vector(1 downto 0);
   -- timing of excPostNorm: 3.500000ns
signal finalExc :  std_logic_vector(1 downto 0);
   -- timing of finalExc: 3.500000ns
begin
   sign <= X(31) xor Y(31);
   expX <= X(30 downto 23);
   expY <= Y(30 downto 23);
   expSumPreSub <= ("00" & expX) + ("00" & expY);
   bias <= CONV_STD_LOGIC_VECTOR(127,10);
   expSum <= expSumPreSub - bias;
   sigX <= "1" & X(22 downto 0);
   sigY <= "1" & Y(22 downto 0);
   SignificandMultiplication: IntMultiplier_24x24_48_comb_uid31
      port map ( X => sigX,
                 Y => sigY,
                 R => sigProd);
   excSel <= X(33 downto 32) & Y(33 downto 32);
   with excSel  select  
   exc <= "00" when  "0000" | "0001" | "0100", 
          "01" when "0101",
          "10" when "0110" | "1001" | "1010" ,
          "11" when others;
   norm <= sigProd(47);
   -- exponent update
   expPostNorm <= expSum + ("000000000" & norm);
   -- significand normalization shift
   sigProdExt <= sigProd(46 downto 0) & "0" when norm='1' else
                         sigProd(45 downto 0) & "00";
   expSig <= expPostNorm & sigProdExt(47 downto 25);
   sticky <= sigProdExt(24);
   guard <= '0' when sigProdExt(23 downto 0)="000000000000000000000000" else '1';
   round <= sticky and ( (guard and not(sigProdExt(25))) or (sigProdExt(25) ))  ;
   RoundingAdder: IntAdder_33_comb_uid35
      port map ( Cin => round,
                 X => expSig,
                 Y => "000000000000000000000000000000000",
                 R => expSigPostRound);
   with expSigPostRound(32 downto 31)  select 
   excPostNorm <=  "01"  when  "00",
                               "10"             when "01", 
                               "00"             when "11"|"10",
                               "11"             when others;
   with exc  select  
   finalExc <= exc when  "11"|"10"|"00",
                       excPostNorm when others; 
   R <= finalExc & sign & expSigPostRound(30 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                           selFunction_comb_uid39
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Bogdan Pasca (2007-2022)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X
-- Output signals: Y
--  approx. input signal timings: X: 0.000000ns
--  approx. output signal timings: Y: 0.550000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity selFunction_comb_uid39 is
    port (X : in  std_logic_vector(8 downto 0);
          Y : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of selFunction_comb_uid39 is
signal Y0 :  std_logic_vector(2 downto 0);
   -- timing of Y0: 0.550000ns
attribute ram_extract: string;
attribute ram_style: string;
attribute ram_extract of Y0: signal is "yes";
attribute ram_style of Y0: signal is "distributed";
signal Y1 :  std_logic_vector(2 downto 0);
   -- timing of Y1: 0.550000ns
begin
   with X  select  Y0 <= 
      "000" when "000000000",
      "000" when "000000001",
      "000" when "000000010",
      "000" when "000000011",
      "000" when "000000100",
      "000" when "000000101",
      "000" when "000000110",
      "000" when "000000111",
      "000" when "000001000",
      "000" when "000001001",
      "000" when "000001010",
      "000" when "000001011",
      "000" when "000001100",
      "000" when "000001101",
      "000" when "000001110",
      "000" when "000001111",
      "001" when "000010000",
      "000" when "000010001",
      "000" when "000010010",
      "000" when "000010011",
      "000" when "000010100",
      "000" when "000010101",
      "000" when "000010110",
      "000" when "000010111",
      "001" when "000011000",
      "001" when "000011001",
      "001" when "000011010",
      "001" when "000011011",
      "000" when "000011100",
      "000" when "000011101",
      "000" when "000011110",
      "000" when "000011111",
      "001" when "000100000",
      "001" when "000100001",
      "001" when "000100010",
      "001" when "000100011",
      "001" when "000100100",
      "001" when "000100101",
      "001" when "000100110",
      "000" when "000100111",
      "001" when "000101000",
      "001" when "000101001",
      "001" when "000101010",
      "001" when "000101011",
      "001" when "000101100",
      "001" when "000101101",
      "001" when "000101110",
      "001" when "000101111",
      "010" when "000110000",
      "001" when "000110001",
      "001" when "000110010",
      "001" when "000110011",
      "001" when "000110100",
      "001" when "000110101",
      "001" when "000110110",
      "001" when "000110111",
      "010" when "000111000",
      "010" when "000111001",
      "001" when "000111010",
      "001" when "000111011",
      "001" when "000111100",
      "001" when "000111101",
      "001" when "000111110",
      "001" when "000111111",
      "010" when "001000000",
      "010" when "001000001",
      "010" when "001000010",
      "001" when "001000011",
      "001" when "001000100",
      "001" when "001000101",
      "001" when "001000110",
      "001" when "001000111",
      "010" when "001001000",
      "010" when "001001001",
      "010" when "001001010",
      "010" when "001001011",
      "001" when "001001100",
      "001" when "001001101",
      "001" when "001001110",
      "001" when "001001111",
      "010" when "001010000",
      "010" when "001010001",
      "010" when "001010010",
      "010" when "001010011",
      "010" when "001010100",
      "010" when "001010101",
      "001" when "001010110",
      "001" when "001010111",
      "010" when "001011000",
      "010" when "001011001",
      "010" when "001011010",
      "010" when "001011011",
      "010" when "001011100",
      "010" when "001011101",
      "010" when "001011110",
      "001" when "001011111",
      "010" when "001100000",
      "010" when "001100001",
      "010" when "001100010",
      "010" when "001100011",
      "010" when "001100100",
      "010" when "001100101",
      "010" when "001100110",
      "010" when "001100111",
      "010" when "001101000",
      "010" when "001101001",
      "010" when "001101010",
      "010" when "001101011",
      "010" when "001101100",
      "010" when "001101101",
      "010" when "001101110",
      "010" when "001101111",
      "010" when "001110000",
      "010" when "001110001",
      "010" when "001110010",
      "010" when "001110011",
      "010" when "001110100",
      "010" when "001110101",
      "010" when "001110110",
      "010" when "001110111",
      "010" when "001111000",
      "010" when "001111001",
      "010" when "001111010",
      "010" when "001111011",
      "010" when "001111100",
      "010" when "001111101",
      "010" when "001111110",
      "010" when "001111111",
      "010" when "010000000",
      "010" when "010000001",
      "010" when "010000010",
      "010" when "010000011",
      "010" when "010000100",
      "010" when "010000101",
      "010" when "010000110",
      "010" when "010000111",
      "010" when "010001000",
      "010" when "010001001",
      "010" when "010001010",
      "010" when "010001011",
      "010" when "010001100",
      "010" when "010001101",
      "010" when "010001110",
      "010" when "010001111",
      "010" when "010010000",
      "010" when "010010001",
      "010" when "010010010",
      "010" when "010010011",
      "010" when "010010100",
      "010" when "010010101",
      "010" when "010010110",
      "010" when "010010111",
      "010" when "010011000",
      "010" when "010011001",
      "010" when "010011010",
      "010" when "010011011",
      "010" when "010011100",
      "010" when "010011101",
      "010" when "010011110",
      "010" when "010011111",
      "010" when "010100000",
      "010" when "010100001",
      "010" when "010100010",
      "010" when "010100011",
      "010" when "010100100",
      "010" when "010100101",
      "010" when "010100110",
      "010" when "010100111",
      "010" when "010101000",
      "010" when "010101001",
      "010" when "010101010",
      "010" when "010101011",
      "010" when "010101100",
      "010" when "010101101",
      "010" when "010101110",
      "010" when "010101111",
      "010" when "010110000",
      "010" when "010110001",
      "010" when "010110010",
      "010" when "010110011",
      "010" when "010110100",
      "010" when "010110101",
      "010" when "010110110",
      "010" when "010110111",
      "010" when "010111000",
      "010" when "010111001",
      "010" when "010111010",
      "010" when "010111011",
      "010" when "010111100",
      "010" when "010111101",
      "010" when "010111110",
      "010" when "010111111",
      "010" when "011000000",
      "010" when "011000001",
      "010" when "011000010",
      "010" when "011000011",
      "010" when "011000100",
      "010" when "011000101",
      "010" when "011000110",
      "010" when "011000111",
      "010" when "011001000",
      "010" when "011001001",
      "010" when "011001010",
      "010" when "011001011",
      "010" when "011001100",
      "010" when "011001101",
      "010" when "011001110",
      "010" when "011001111",
      "010" when "011010000",
      "010" when "011010001",
      "010" when "011010010",
      "010" when "011010011",
      "010" when "011010100",
      "010" when "011010101",
      "010" when "011010110",
      "010" when "011010111",
      "010" when "011011000",
      "010" when "011011001",
      "010" when "011011010",
      "010" when "011011011",
      "010" when "011011100",
      "010" when "011011101",
      "010" when "011011110",
      "010" when "011011111",
      "010" when "011100000",
      "010" when "011100001",
      "010" when "011100010",
      "010" when "011100011",
      "010" when "011100100",
      "010" when "011100101",
      "010" when "011100110",
      "010" when "011100111",
      "010" when "011101000",
      "010" when "011101001",
      "010" when "011101010",
      "010" when "011101011",
      "010" when "011101100",
      "010" when "011101101",
      "010" when "011101110",
      "010" when "011101111",
      "010" when "011110000",
      "010" when "011110001",
      "010" when "011110010",
      "010" when "011110011",
      "010" when "011110100",
      "010" when "011110101",
      "010" when "011110110",
      "010" when "011110111",
      "010" when "011111000",
      "010" when "011111001",
      "010" when "011111010",
      "010" when "011111011",
      "010" when "011111100",
      "010" when "011111101",
      "010" when "011111110",
      "010" when "011111111",
      "110" when "100000000",
      "110" when "100000001",
      "110" when "100000010",
      "110" when "100000011",
      "110" when "100000100",
      "110" when "100000101",
      "110" when "100000110",
      "110" when "100000111",
      "110" when "100001000",
      "110" when "100001001",
      "110" when "100001010",
      "110" when "100001011",
      "110" when "100001100",
      "110" when "100001101",
      "110" when "100001110",
      "110" when "100001111",
      "110" when "100010000",
      "110" when "100010001",
      "110" when "100010010",
      "110" when "100010011",
      "110" when "100010100",
      "110" when "100010101",
      "110" when "100010110",
      "110" when "100010111",
      "110" when "100011000",
      "110" when "100011001",
      "110" when "100011010",
      "110" when "100011011",
      "110" when "100011100",
      "110" when "100011101",
      "110" when "100011110",
      "110" when "100011111",
      "110" when "100100000",
      "110" when "100100001",
      "110" when "100100010",
      "110" when "100100011",
      "110" when "100100100",
      "110" when "100100101",
      "110" when "100100110",
      "110" when "100100111",
      "110" when "100101000",
      "110" when "100101001",
      "110" when "100101010",
      "110" when "100101011",
      "110" when "100101100",
      "110" when "100101101",
      "110" when "100101110",
      "110" when "100101111",
      "110" when "100110000",
      "110" when "100110001",
      "110" when "100110010",
      "110" when "100110011",
      "110" when "100110100",
      "110" when "100110101",
      "110" when "100110110",
      "110" when "100110111",
      "110" when "100111000",
      "110" when "100111001",
      "110" when "100111010",
      "110" when "100111011",
      "110" when "100111100",
      "110" when "100111101",
      "110" when "100111110",
      "110" when "100111111",
      "110" when "101000000",
      "110" when "101000001",
      "110" when "101000010",
      "110" when "101000011",
      "110" when "101000100",
      "110" when "101000101",
      "110" when "101000110",
      "110" when "101000111",
      "110" when "101001000",
      "110" when "101001001",
      "110" when "101001010",
      "110" when "101001011",
      "110" when "101001100",
      "110" when "101001101",
      "110" when "101001110",
      "110" when "101001111",
      "110" when "101010000",
      "110" when "101010001",
      "110" when "101010010",
      "110" when "101010011",
      "110" when "101010100",
      "110" when "101010101",
      "110" when "101010110",
      "110" when "101010111",
      "110" when "101011000",
      "110" when "101011001",
      "110" when "101011010",
      "110" when "101011011",
      "110" when "101011100",
      "110" when "101011101",
      "110" when "101011110",
      "110" when "101011111",
      "110" when "101100000",
      "110" when "101100001",
      "110" when "101100010",
      "110" when "101100011",
      "110" when "101100100",
      "110" when "101100101",
      "110" when "101100110",
      "110" when "101100111",
      "110" when "101101000",
      "110" when "101101001",
      "110" when "101101010",
      "110" when "101101011",
      "110" when "101101100",
      "110" when "101101101",
      "110" when "101101110",
      "110" when "101101111",
      "110" when "101110000",
      "110" when "101110001",
      "110" when "101110010",
      "110" when "101110011",
      "110" when "101110100",
      "110" when "101110101",
      "110" when "101110110",
      "110" when "101110111",
      "110" when "101111000",
      "110" when "101111001",
      "110" when "101111010",
      "110" when "101111011",
      "110" when "101111100",
      "110" when "101111101",
      "110" when "101111110",
      "110" when "101111111",
      "110" when "110000000",
      "110" when "110000001",
      "110" when "110000010",
      "110" when "110000011",
      "110" when "110000100",
      "110" when "110000101",
      "110" when "110000110",
      "110" when "110000111",
      "110" when "110001000",
      "110" when "110001001",
      "110" when "110001010",
      "110" when "110001011",
      "110" when "110001100",
      "110" when "110001101",
      "110" when "110001110",
      "110" when "110001111",
      "110" when "110010000",
      "110" when "110010001",
      "110" when "110010010",
      "110" when "110010011",
      "110" when "110010100",
      "110" when "110010101",
      "110" when "110010110",
      "110" when "110010111",
      "110" when "110011000",
      "110" when "110011001",
      "110" when "110011010",
      "110" when "110011011",
      "110" when "110011100",
      "110" when "110011101",
      "110" when "110011110",
      "110" when "110011111",
      "110" when "110100000",
      "110" when "110100001",
      "110" when "110100010",
      "110" when "110100011",
      "110" when "110100100",
      "110" when "110100101",
      "110" when "110100110",
      "110" when "110100111",
      "110" when "110101000",
      "110" when "110101001",
      "110" when "110101010",
      "110" when "110101011",
      "110" when "110101100",
      "110" when "110101101",
      "110" when "110101110",
      "111" when "110101111",
      "110" when "110110000",
      "110" when "110110001",
      "110" when "110110010",
      "110" when "110110011",
      "110" when "110110100",
      "111" when "110110101",
      "111" when "110110110",
      "111" when "110110111",
      "110" when "110111000",
      "110" when "110111001",
      "110" when "110111010",
      "110" when "110111011",
      "111" when "110111100",
      "111" when "110111101",
      "111" when "110111110",
      "111" when "110111111",
      "110" when "111000000",
      "110" when "111000001",
      "111" when "111000010",
      "111" when "111000011",
      "111" when "111000100",
      "111" when "111000101",
      "111" when "111000110",
      "111" when "111000111",
      "110" when "111001000",
      "111" when "111001001",
      "111" when "111001010",
      "111" when "111001011",
      "111" when "111001100",
      "111" when "111001101",
      "111" when "111001110",
      "111" when "111001111",
      "111" when "111010000",
      "111" when "111010001",
      "111" when "111010010",
      "111" when "111010011",
      "111" when "111010100",
      "111" when "111010101",
      "111" when "111010110",
      "111" when "111010111",
      "111" when "111011000",
      "111" when "111011001",
      "111" when "111011010",
      "111" when "111011011",
      "111" when "111011100",
      "111" when "111011101",
      "111" when "111011110",
      "111" when "111011111",
      "111" when "111100000",
      "111" when "111100001",
      "111" when "111100010",
      "111" when "111100011",
      "111" when "111100100",
      "111" when "111100101",
      "111" when "111100110",
      "111" when "111100111",
      "111" when "111101000",
      "111" when "111101001",
      "111" when "111101010",
      "111" when "111101011",
      "000" when "111101100",
      "000" when "111101101",
      "000" when "111101110",
      "000" when "111101111",
      "000" when "111110000",
      "000" when "111110001",
      "000" when "111110010",
      "000" when "111110011",
      "000" when "111110100",
      "000" when "111110101",
      "000" when "111110110",
      "000" when "111110111",
      "000" when "111111000",
      "000" when "111111001",
      "000" when "111111010",
      "000" when "111111011",
      "000" when "111111100",
      "000" when "111111101",
      "000" when "111111110",
      "000" when "111111111",
      "---" when others;
   Y1 <= Y0; -- for the possible blockram register
   Y <= Y1;
end architecture;

--------------------------------------------------------------------------------
--                           FPDiv_8_23_comb_uid37
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Maxime Christ, Florent de Dinechin (2015)
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X Y
-- Output signals: R
--  approx. input signal timings: X: 0.000000nsY: 0.000000ns
--  approx. output signal timings: R: 27.870000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPDiv_8_23_comb_uid37 is
    port (X : in  std_logic_vector(8+23+2 downto 0);
          Y : in  std_logic_vector(8+23+2 downto 0);
          R : out  std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPDiv_8_23_comb_uid37 is
   component selFunction_comb_uid39 is
      port ( X : in  std_logic_vector(8 downto 0);
             Y : out  std_logic_vector(2 downto 0)   );
   end component;

signal fX :  std_logic_vector(23 downto 0);
   -- timing of fX: 0.000000ns
signal fY :  std_logic_vector(23 downto 0);
   -- timing of fY: 0.000000ns
signal expR0 :  std_logic_vector(9 downto 0);
   -- timing of expR0: 0.000000ns
signal sR :  std_logic;
   -- timing of sR: 0.050000ns
signal exnXY :  std_logic_vector(3 downto 0);
   -- timing of exnXY: 0.000000ns
signal exnR0 :  std_logic_vector(1 downto 0);
   -- timing of exnR0: 0.050000ns
signal D :  std_logic_vector(23 downto 0);
   -- timing of D: 0.000000ns
signal psX :  std_logic_vector(24 downto 0);
   -- timing of psX: 0.000000ns
signal betaw14 :  std_logic_vector(26 downto 0);
   -- timing of betaw14: 0.000000ns
signal sel14 :  std_logic_vector(8 downto 0);
   -- timing of sel14: 0.000000ns
signal q14 :  std_logic_vector(2 downto 0);
   -- timing of q14: 0.550000ns
signal absq14D :  std_logic_vector(26 downto 0);
   -- timing of absq14D: 0.550000ns
signal w13 :  std_logic_vector(26 downto 0);
   -- timing of w13: 1.810000ns
signal betaw13 :  std_logic_vector(26 downto 0);
   -- timing of betaw13: 1.810000ns
signal sel13 :  std_logic_vector(8 downto 0);
   -- timing of sel13: 1.810000ns
signal q13 :  std_logic_vector(2 downto 0);
   -- timing of q13: 2.360000ns
signal absq13D :  std_logic_vector(26 downto 0);
   -- timing of absq13D: 2.360000ns
signal w12 :  std_logic_vector(26 downto 0);
   -- timing of w12: 3.620000ns
signal betaw12 :  std_logic_vector(26 downto 0);
   -- timing of betaw12: 3.620000ns
signal sel12 :  std_logic_vector(8 downto 0);
   -- timing of sel12: 3.620000ns
signal q12 :  std_logic_vector(2 downto 0);
   -- timing of q12: 4.170000ns
signal absq12D :  std_logic_vector(26 downto 0);
   -- timing of absq12D: 4.170000ns
signal w11 :  std_logic_vector(26 downto 0);
   -- timing of w11: 5.430000ns
signal betaw11 :  std_logic_vector(26 downto 0);
   -- timing of betaw11: 5.430000ns
signal sel11 :  std_logic_vector(8 downto 0);
   -- timing of sel11: 5.430000ns
signal q11 :  std_logic_vector(2 downto 0);
   -- timing of q11: 5.980000ns
signal absq11D :  std_logic_vector(26 downto 0);
   -- timing of absq11D: 5.980000ns
signal w10 :  std_logic_vector(26 downto 0);
   -- timing of w10: 7.240000ns
signal betaw10 :  std_logic_vector(26 downto 0);
   -- timing of betaw10: 7.240000ns
signal sel10 :  std_logic_vector(8 downto 0);
   -- timing of sel10: 7.240000ns
signal q10 :  std_logic_vector(2 downto 0);
   -- timing of q10: 7.790000ns
signal absq10D :  std_logic_vector(26 downto 0);
   -- timing of absq10D: 7.790000ns
signal w9 :  std_logic_vector(26 downto 0);
   -- timing of w9: 9.050000ns
signal betaw9 :  std_logic_vector(26 downto 0);
   -- timing of betaw9: 9.050000ns
signal sel9 :  std_logic_vector(8 downto 0);
   -- timing of sel9: 9.050000ns
signal q9 :  std_logic_vector(2 downto 0);
   -- timing of q9: 9.600000ns
signal absq9D :  std_logic_vector(26 downto 0);
   -- timing of absq9D: 9.600000ns
signal w8 :  std_logic_vector(26 downto 0);
   -- timing of w8: 10.860000ns
signal betaw8 :  std_logic_vector(26 downto 0);
   -- timing of betaw8: 10.860000ns
signal sel8 :  std_logic_vector(8 downto 0);
   -- timing of sel8: 10.860000ns
signal q8 :  std_logic_vector(2 downto 0);
   -- timing of q8: 11.410000ns
signal absq8D :  std_logic_vector(26 downto 0);
   -- timing of absq8D: 11.410000ns
signal w7 :  std_logic_vector(26 downto 0);
   -- timing of w7: 12.670000ns
signal betaw7 :  std_logic_vector(26 downto 0);
   -- timing of betaw7: 12.670000ns
signal sel7 :  std_logic_vector(8 downto 0);
   -- timing of sel7: 12.670000ns
signal q7 :  std_logic_vector(2 downto 0);
   -- timing of q7: 13.220000ns
signal absq7D :  std_logic_vector(26 downto 0);
   -- timing of absq7D: 13.220000ns
signal w6 :  std_logic_vector(26 downto 0);
   -- timing of w6: 14.480000ns
signal betaw6 :  std_logic_vector(26 downto 0);
   -- timing of betaw6: 14.480000ns
signal sel6 :  std_logic_vector(8 downto 0);
   -- timing of sel6: 14.480000ns
signal q6 :  std_logic_vector(2 downto 0);
   -- timing of q6: 15.030000ns
signal absq6D :  std_logic_vector(26 downto 0);
   -- timing of absq6D: 15.030000ns
signal w5 :  std_logic_vector(26 downto 0);
   -- timing of w5: 16.290000ns
signal betaw5 :  std_logic_vector(26 downto 0);
   -- timing of betaw5: 16.290000ns
signal sel5 :  std_logic_vector(8 downto 0);
   -- timing of sel5: 16.290000ns
signal q5 :  std_logic_vector(2 downto 0);
   -- timing of q5: 16.840000ns
signal absq5D :  std_logic_vector(26 downto 0);
   -- timing of absq5D: 16.840000ns
signal w4 :  std_logic_vector(26 downto 0);
   -- timing of w4: 18.100000ns
signal betaw4 :  std_logic_vector(26 downto 0);
   -- timing of betaw4: 18.100000ns
signal sel4 :  std_logic_vector(8 downto 0);
   -- timing of sel4: 18.100000ns
signal q4 :  std_logic_vector(2 downto 0);
   -- timing of q4: 18.650000ns
signal absq4D :  std_logic_vector(26 downto 0);
   -- timing of absq4D: 18.650000ns
signal w3 :  std_logic_vector(26 downto 0);
   -- timing of w3: 19.910000ns
signal betaw3 :  std_logic_vector(26 downto 0);
   -- timing of betaw3: 19.910000ns
signal sel3 :  std_logic_vector(8 downto 0);
   -- timing of sel3: 19.910000ns
signal q3 :  std_logic_vector(2 downto 0);
   -- timing of q3: 20.460000ns
signal absq3D :  std_logic_vector(26 downto 0);
   -- timing of absq3D: 20.460000ns
signal w2 :  std_logic_vector(26 downto 0);
   -- timing of w2: 21.720000ns
signal betaw2 :  std_logic_vector(26 downto 0);
   -- timing of betaw2: 21.720000ns
signal sel2 :  std_logic_vector(8 downto 0);
   -- timing of sel2: 21.720000ns
signal q2 :  std_logic_vector(2 downto 0);
   -- timing of q2: 22.270000ns
signal absq2D :  std_logic_vector(26 downto 0);
   -- timing of absq2D: 22.270000ns
signal w1 :  std_logic_vector(26 downto 0);
   -- timing of w1: 23.530000ns
signal betaw1 :  std_logic_vector(26 downto 0);
   -- timing of betaw1: 23.530000ns
signal sel1 :  std_logic_vector(8 downto 0);
   -- timing of sel1: 23.530000ns
signal q1 :  std_logic_vector(2 downto 0);
   -- timing of q1: 24.080000ns
signal absq1D :  std_logic_vector(26 downto 0);
   -- timing of absq1D: 24.080000ns
signal w0 :  std_logic_vector(26 downto 0);
   -- timing of w0: 25.340000ns
signal wfinal :  std_logic_vector(24 downto 0);
   -- timing of wfinal: 25.340000ns
signal qM0 :  std_logic;
   -- timing of qM0: 25.340000ns
signal qP14 :  std_logic_vector(1 downto 0);
   -- timing of qP14: 0.550000ns
signal qM14 :  std_logic_vector(1 downto 0);
   -- timing of qM14: 0.550000ns
signal qP13 :  std_logic_vector(1 downto 0);
   -- timing of qP13: 2.360000ns
signal qM13 :  std_logic_vector(1 downto 0);
   -- timing of qM13: 2.360000ns
signal qP12 :  std_logic_vector(1 downto 0);
   -- timing of qP12: 4.170000ns
signal qM12 :  std_logic_vector(1 downto 0);
   -- timing of qM12: 4.170000ns
signal qP11 :  std_logic_vector(1 downto 0);
   -- timing of qP11: 5.980000ns
signal qM11 :  std_logic_vector(1 downto 0);
   -- timing of qM11: 5.980000ns
signal qP10 :  std_logic_vector(1 downto 0);
   -- timing of qP10: 7.790000ns
signal qM10 :  std_logic_vector(1 downto 0);
   -- timing of qM10: 7.790000ns
signal qP9 :  std_logic_vector(1 downto 0);
   -- timing of qP9: 9.600000ns
signal qM9 :  std_logic_vector(1 downto 0);
   -- timing of qM9: 9.600000ns
signal qP8 :  std_logic_vector(1 downto 0);
   -- timing of qP8: 11.410000ns
signal qM8 :  std_logic_vector(1 downto 0);
   -- timing of qM8: 11.410000ns
signal qP7 :  std_logic_vector(1 downto 0);
   -- timing of qP7: 13.220000ns
signal qM7 :  std_logic_vector(1 downto 0);
   -- timing of qM7: 13.220000ns
signal qP6 :  std_logic_vector(1 downto 0);
   -- timing of qP6: 15.030000ns
signal qM6 :  std_logic_vector(1 downto 0);
   -- timing of qM6: 15.030000ns
signal qP5 :  std_logic_vector(1 downto 0);
   -- timing of qP5: 16.840000ns
signal qM5 :  std_logic_vector(1 downto 0);
   -- timing of qM5: 16.840000ns
signal qP4 :  std_logic_vector(1 downto 0);
   -- timing of qP4: 18.650000ns
signal qM4 :  std_logic_vector(1 downto 0);
   -- timing of qM4: 18.650000ns
signal qP3 :  std_logic_vector(1 downto 0);
   -- timing of qP3: 20.460000ns
signal qM3 :  std_logic_vector(1 downto 0);
   -- timing of qM3: 20.460000ns
signal qP2 :  std_logic_vector(1 downto 0);
   -- timing of qP2: 22.270000ns
signal qM2 :  std_logic_vector(1 downto 0);
   -- timing of qM2: 22.270000ns
signal qP1 :  std_logic_vector(1 downto 0);
   -- timing of qP1: 24.080000ns
signal qM1 :  std_logic_vector(1 downto 0);
   -- timing of qM1: 24.080000ns
signal qP :  std_logic_vector(27 downto 0);
   -- timing of qP: 24.080000ns
signal qM :  std_logic_vector(27 downto 0);
   -- timing of qM: 25.340000ns
signal quotient :  std_logic_vector(27 downto 0);
   -- timing of quotient: 26.630000ns
signal mR :  std_logic_vector(25 downto 0);
   -- timing of mR: 26.680000ns
signal fRnorm :  std_logic_vector(23 downto 0);
   -- timing of fRnorm: 26.730000ns
signal round :  std_logic;
   -- timing of round: 26.780000ns
signal expR1 :  std_logic_vector(9 downto 0);
   -- timing of expR1: 27.770000ns
signal expfrac :  std_logic_vector(32 downto 0);
   -- timing of expfrac: 27.770000ns
signal expfracR :  std_logic_vector(32 downto 0);
   -- timing of expfracR: 27.770000ns
signal exnR :  std_logic_vector(1 downto 0);
   -- timing of exnR: 27.820000ns
signal exnRfinal :  std_logic_vector(1 downto 0);
   -- timing of exnRfinal: 27.870000ns
begin
   fX <= "1" & X(22 downto 0);
   fY <= "1" & Y(22 downto 0);
   -- exponent difference, sign and exception combination computed early, to have fewer bits to pipeline
   expR0 <= ("00" & X(30 downto 23)) - ("00" & Y(30 downto 23));
   sR <= X(31) xor Y(31);
   -- early exception handling 
   exnXY <= X(33 downto 32) & Y(33 downto 32);
   with exnXY  select 
      exnR0 <= 
         "01"	 when "0101",										-- normal
         "00"	 when "0001" | "0010" | "0110", -- zero
         "10"	 when "0100" | "1000" | "1001", -- overflow
         "11"	 when others;										-- NaN
   D <= fY ;
   psX <= "0" & fX ;
   betaw14 <=  "00" & psX;
   sel14 <= betaw14(26 downto 21) & D(22 downto 20);
   SelFunctionTable14: selFunction_comb_uid39
      port map ( X => sel14,
                 Y => q14);

   with q14  select 
      absq14D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q14(2)  select 
   w13<= betaw14 - absq14D when '0',
         betaw14 + absq14D when others;

   betaw13 <= w13(24 downto 0) & "00"; -- multiplication by the radix
   sel13 <= betaw13(26 downto 21) & D(22 downto 20);
   SelFunctionTable13: selFunction_comb_uid39
      port map ( X => sel13,
                 Y => q13);

   with q13  select 
      absq13D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q13(2)  select 
   w12<= betaw13 - absq13D when '0',
         betaw13 + absq13D when others;

   betaw12 <= w12(24 downto 0) & "00"; -- multiplication by the radix
   sel12 <= betaw12(26 downto 21) & D(22 downto 20);
   SelFunctionTable12: selFunction_comb_uid39
      port map ( X => sel12,
                 Y => q12);

   with q12  select 
      absq12D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q12(2)  select 
   w11<= betaw12 - absq12D when '0',
         betaw12 + absq12D when others;

   betaw11 <= w11(24 downto 0) & "00"; -- multiplication by the radix
   sel11 <= betaw11(26 downto 21) & D(22 downto 20);
   SelFunctionTable11: selFunction_comb_uid39
      port map ( X => sel11,
                 Y => q11);

   with q11  select 
      absq11D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q11(2)  select 
   w10<= betaw11 - absq11D when '0',
         betaw11 + absq11D when others;

   betaw10 <= w10(24 downto 0) & "00"; -- multiplication by the radix
   sel10 <= betaw10(26 downto 21) & D(22 downto 20);
   SelFunctionTable10: selFunction_comb_uid39
      port map ( X => sel10,
                 Y => q10);

   with q10  select 
      absq10D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q10(2)  select 
   w9<= betaw10 - absq10D when '0',
         betaw10 + absq10D when others;

   betaw9 <= w9(24 downto 0) & "00"; -- multiplication by the radix
   sel9 <= betaw9(26 downto 21) & D(22 downto 20);
   SelFunctionTable9: selFunction_comb_uid39
      port map ( X => sel9,
                 Y => q9);

   with q9  select 
      absq9D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q9(2)  select 
   w8<= betaw9 - absq9D when '0',
         betaw9 + absq9D when others;

   betaw8 <= w8(24 downto 0) & "00"; -- multiplication by the radix
   sel8 <= betaw8(26 downto 21) & D(22 downto 20);
   SelFunctionTable8: selFunction_comb_uid39
      port map ( X => sel8,
                 Y => q8);

   with q8  select 
      absq8D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q8(2)  select 
   w7<= betaw8 - absq8D when '0',
         betaw8 + absq8D when others;

   betaw7 <= w7(24 downto 0) & "00"; -- multiplication by the radix
   sel7 <= betaw7(26 downto 21) & D(22 downto 20);
   SelFunctionTable7: selFunction_comb_uid39
      port map ( X => sel7,
                 Y => q7);

   with q7  select 
      absq7D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q7(2)  select 
   w6<= betaw7 - absq7D when '0',
         betaw7 + absq7D when others;

   betaw6 <= w6(24 downto 0) & "00"; -- multiplication by the radix
   sel6 <= betaw6(26 downto 21) & D(22 downto 20);
   SelFunctionTable6: selFunction_comb_uid39
      port map ( X => sel6,
                 Y => q6);

   with q6  select 
      absq6D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q6(2)  select 
   w5<= betaw6 - absq6D when '0',
         betaw6 + absq6D when others;

   betaw5 <= w5(24 downto 0) & "00"; -- multiplication by the radix
   sel5 <= betaw5(26 downto 21) & D(22 downto 20);
   SelFunctionTable5: selFunction_comb_uid39
      port map ( X => sel5,
                 Y => q5);

   with q5  select 
      absq5D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q5(2)  select 
   w4<= betaw5 - absq5D when '0',
         betaw5 + absq5D when others;

   betaw4 <= w4(24 downto 0) & "00"; -- multiplication by the radix
   sel4 <= betaw4(26 downto 21) & D(22 downto 20);
   SelFunctionTable4: selFunction_comb_uid39
      port map ( X => sel4,
                 Y => q4);

   with q4  select 
      absq4D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q4(2)  select 
   w3<= betaw4 - absq4D when '0',
         betaw4 + absq4D when others;

   betaw3 <= w3(24 downto 0) & "00"; -- multiplication by the radix
   sel3 <= betaw3(26 downto 21) & D(22 downto 20);
   SelFunctionTable3: selFunction_comb_uid39
      port map ( X => sel3,
                 Y => q3);

   with q3  select 
      absq3D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q3(2)  select 
   w2<= betaw3 - absq3D when '0',
         betaw3 + absq3D when others;

   betaw2 <= w2(24 downto 0) & "00"; -- multiplication by the radix
   sel2 <= betaw2(26 downto 21) & D(22 downto 20);
   SelFunctionTable2: selFunction_comb_uid39
      port map ( X => sel2,
                 Y => q2);

   with q2  select 
      absq2D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q2(2)  select 
   w1<= betaw2 - absq2D when '0',
         betaw2 + absq2D when others;

   betaw1 <= w1(24 downto 0) & "00"; -- multiplication by the radix
   sel1 <= betaw1(26 downto 21) & D(22 downto 20);
   SelFunctionTable1: selFunction_comb_uid39
      port map ( X => sel1,
                 Y => q1);

   with q1  select 
      absq1D <= 
         "000" & D						 when "001" | "111", -- mult by 1
         "00" & D & "0"			   when "010" | "110", -- mult by 2
         (26 downto 0 => '0')	 when others;        -- mult by 0

   with q1(2)  select 
   w0<= betaw1 - absq1D when '0',
         betaw1 + absq1D when others;

   wfinal <= w0(24 downto 0);
   qM0 <= wfinal(24); -- rounding bit is the sign of the remainder
   qP14 <=      q14(1 downto 0);
   qM14 <=      q14(2) & "0";
   qP13 <=      q13(1 downto 0);
   qM13 <=      q13(2) & "0";
   qP12 <=      q12(1 downto 0);
   qM12 <=      q12(2) & "0";
   qP11 <=      q11(1 downto 0);
   qM11 <=      q11(2) & "0";
   qP10 <=      q10(1 downto 0);
   qM10 <=      q10(2) & "0";
   qP9 <=      q9(1 downto 0);
   qM9 <=      q9(2) & "0";
   qP8 <=      q8(1 downto 0);
   qM8 <=      q8(2) & "0";
   qP7 <=      q7(1 downto 0);
   qM7 <=      q7(2) & "0";
   qP6 <=      q6(1 downto 0);
   qM6 <=      q6(2) & "0";
   qP5 <=      q5(1 downto 0);
   qM5 <=      q5(2) & "0";
   qP4 <=      q4(1 downto 0);
   qM4 <=      q4(2) & "0";
   qP3 <=      q3(1 downto 0);
   qM3 <=      q3(2) & "0";
   qP2 <=      q2(1 downto 0);
   qM2 <=      q2(2) & "0";
   qP1 <=      q1(1 downto 0);
   qM1 <=      q1(2) & "0";
   qP <= qP14 & qP13 & qP12 & qP11 & qP10 & qP9 & qP8 & qP7 & qP6 & qP5 & qP4 & qP3 & qP2 & qP1;
   qM <= qM14(0) & qM13 & qM12 & qM11 & qM10 & qM9 & qM8 & qM7 & qM6 & qM5 & qM4 & qM3 & qM2 & qM1 & qM0;
   quotient <= qP - qM;
   -- We need a mR in (0, -wf-2) format: 1+wF fraction bits, 1 round bit, and 1 guard bit for the normalisation,
   -- quotient is the truncation of the exact quotient to at least 2^(-wF-2) bits
   -- now discarding its possible known MSB zeroes, and dropping the possible extra LSB bit (due to radix 4) 
   mR <= quotient(26 downto 1); 
   -- normalisation
   fRnorm <=    mR(24 downto 1)  when mR(25)= '1'
           else mR(23 downto 0);  -- now fRnorm is a (-1, -wF-1) fraction
   round <= fRnorm(0); 
   expR1 <= expR0 + ("000" & (6 downto 1 => '1') & mR(25)); -- add back bias
   -- final rounding
   expfrac <= expR1 & fRnorm(23 downto 1) ;
   expfracR <= expfrac + ((32 downto 1 => '0') & round);
   exnR <=      "00"  when expfracR(32) = '1'   -- underflow
           else "10"  when  expfracR(32 downto 31) =  "01" -- overflow
           else "01";      -- 00, normal case
   with exnR0  select 
      exnRfinal <= 
         exnR   when "01", -- normal
         exnR0  when others;
   R <= exnRfinal & sR & expfracR(30 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                                FPSqrt_8_23
-- VHDL generated for DummyFPGA @ 0MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: 
--------------------------------------------------------------------------------
-- combinatorial
-- Clock period (ns): inf
-- Target frequency (MHz): 0
-- Input signals: X
-- Output signals: R
--  approx. input signal timings: X: 0.000000ns
--  approx. output signal timings: R: 28.290000ns

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPSqrt_8_23 is
    port (X : in  std_logic_vector(8+23+2 downto 0);
          R : out  std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FPSqrt_8_23 is
signal fracX :  std_logic_vector(22 downto 0);
   -- timing of fracX: 0.000000ns
signal eRn0 :  std_logic_vector(7 downto 0);
   -- timing of eRn0: 0.000000ns
signal xsX :  std_logic_vector(2 downto 0);
   -- timing of xsX: 0.000000ns
signal eRn1 :  std_logic_vector(7 downto 0);
   -- timing of eRn1: 0.000000ns
signal fracXnorm :  std_logic_vector(26 downto 0);
   -- timing of fracXnorm: 0.050000ns
signal S0 :  std_logic_vector(1 downto 0);
   -- timing of S0: 0.000000ns
signal T1 :  std_logic_vector(26 downto 0);
   -- timing of T1: 1.080000ns
signal d1 :  std_logic;
   -- timing of d1: 1.080000ns
signal T1s :  std_logic_vector(27 downto 0);
   -- timing of T1s: 1.080000ns
signal T1s_h :  std_logic_vector(5 downto 0);
   -- timing of T1s_h: 1.080000ns
signal T1s_l :  std_logic_vector(21 downto 0);
   -- timing of T1s_l: 1.080000ns
signal U1 :  std_logic_vector(5 downto 0);
   -- timing of U1: 1.080000ns
signal T3_h :  std_logic_vector(5 downto 0);
   -- timing of T3_h: 2.100000ns
signal T2 :  std_logic_vector(26 downto 0);
   -- timing of T2: 2.100000ns
signal S1 :  std_logic_vector(2 downto 0);
   -- timing of S1: 1.080000ns
signal d2 :  std_logic;
   -- timing of d2: 2.100000ns
signal T2s :  std_logic_vector(27 downto 0);
   -- timing of T2s: 2.100000ns
signal T2s_h :  std_logic_vector(6 downto 0);
   -- timing of T2s_h: 2.100000ns
signal T2s_l :  std_logic_vector(20 downto 0);
   -- timing of T2s_l: 2.100000ns
signal U2 :  std_logic_vector(6 downto 0);
   -- timing of U2: 2.100000ns
signal T4_h :  std_logic_vector(6 downto 0);
   -- timing of T4_h: 3.130000ns
signal T3 :  std_logic_vector(26 downto 0);
   -- timing of T3: 3.130000ns
signal S2 :  std_logic_vector(3 downto 0);
   -- timing of S2: 2.100000ns
signal d3 :  std_logic;
   -- timing of d3: 3.130000ns
signal T3s :  std_logic_vector(27 downto 0);
   -- timing of T3s: 3.130000ns
signal T3s_h :  std_logic_vector(7 downto 0);
   -- timing of T3s_h: 3.130000ns
signal T3s_l :  std_logic_vector(19 downto 0);
   -- timing of T3s_l: 3.130000ns
signal U3 :  std_logic_vector(7 downto 0);
   -- timing of U3: 3.130000ns
signal T5_h :  std_logic_vector(7 downto 0);
   -- timing of T5_h: 4.170000ns
signal T4 :  std_logic_vector(26 downto 0);
   -- timing of T4: 4.170000ns
signal S3 :  std_logic_vector(4 downto 0);
   -- timing of S3: 3.130000ns
signal d4 :  std_logic;
   -- timing of d4: 4.170000ns
signal T4s :  std_logic_vector(27 downto 0);
   -- timing of T4s: 4.170000ns
signal T4s_h :  std_logic_vector(8 downto 0);
   -- timing of T4s_h: 4.170000ns
signal T4s_l :  std_logic_vector(18 downto 0);
   -- timing of T4s_l: 4.170000ns
signal U4 :  std_logic_vector(8 downto 0);
   -- timing of U4: 4.170000ns
signal T6_h :  std_logic_vector(8 downto 0);
   -- timing of T6_h: 5.220000ns
signal T5 :  std_logic_vector(26 downto 0);
   -- timing of T5: 5.220000ns
signal S4 :  std_logic_vector(5 downto 0);
   -- timing of S4: 4.170000ns
signal d5 :  std_logic;
   -- timing of d5: 5.220000ns
signal T5s :  std_logic_vector(27 downto 0);
   -- timing of T5s: 5.220000ns
signal T5s_h :  std_logic_vector(9 downto 0);
   -- timing of T5s_h: 5.220000ns
signal T5s_l :  std_logic_vector(17 downto 0);
   -- timing of T5s_l: 5.220000ns
signal U5 :  std_logic_vector(9 downto 0);
   -- timing of U5: 5.220000ns
signal T7_h :  std_logic_vector(9 downto 0);
   -- timing of T7_h: 6.280000ns
signal T6 :  std_logic_vector(26 downto 0);
   -- timing of T6: 6.280000ns
signal S5 :  std_logic_vector(6 downto 0);
   -- timing of S5: 5.220000ns
signal d6 :  std_logic;
   -- timing of d6: 6.280000ns
signal T6s :  std_logic_vector(27 downto 0);
   -- timing of T6s: 6.280000ns
signal T6s_h :  std_logic_vector(10 downto 0);
   -- timing of T6s_h: 6.280000ns
signal T6s_l :  std_logic_vector(16 downto 0);
   -- timing of T6s_l: 6.280000ns
signal U6 :  std_logic_vector(10 downto 0);
   -- timing of U6: 6.280000ns
signal T8_h :  std_logic_vector(10 downto 0);
   -- timing of T8_h: 7.350000ns
signal T7 :  std_logic_vector(26 downto 0);
   -- timing of T7: 7.350000ns
signal S6 :  std_logic_vector(7 downto 0);
   -- timing of S6: 6.280000ns
signal d7 :  std_logic;
   -- timing of d7: 7.350000ns
signal T7s :  std_logic_vector(27 downto 0);
   -- timing of T7s: 7.350000ns
signal T7s_h :  std_logic_vector(11 downto 0);
   -- timing of T7s_h: 7.350000ns
signal T7s_l :  std_logic_vector(15 downto 0);
   -- timing of T7s_l: 7.350000ns
signal U7 :  std_logic_vector(11 downto 0);
   -- timing of U7: 7.350000ns
signal T9_h :  std_logic_vector(11 downto 0);
   -- timing of T9_h: 8.430000ns
signal T8 :  std_logic_vector(26 downto 0);
   -- timing of T8: 8.430000ns
signal S7 :  std_logic_vector(8 downto 0);
   -- timing of S7: 7.350000ns
signal d8 :  std_logic;
   -- timing of d8: 8.430000ns
signal T8s :  std_logic_vector(27 downto 0);
   -- timing of T8s: 8.430000ns
signal T8s_h :  std_logic_vector(12 downto 0);
   -- timing of T8s_h: 8.430000ns
signal T8s_l :  std_logic_vector(14 downto 0);
   -- timing of T8s_l: 8.430000ns
signal U8 :  std_logic_vector(12 downto 0);
   -- timing of U8: 8.430000ns
signal T10_h :  std_logic_vector(12 downto 0);
   -- timing of T10_h: 9.520000ns
signal T9 :  std_logic_vector(26 downto 0);
   -- timing of T9: 9.520000ns
signal S8 :  std_logic_vector(9 downto 0);
   -- timing of S8: 8.430000ns
signal d9 :  std_logic;
   -- timing of d9: 9.520000ns
signal T9s :  std_logic_vector(27 downto 0);
   -- timing of T9s: 9.520000ns
signal T9s_h :  std_logic_vector(13 downto 0);
   -- timing of T9s_h: 9.520000ns
signal T9s_l :  std_logic_vector(13 downto 0);
   -- timing of T9s_l: 9.520000ns
signal U9 :  std_logic_vector(13 downto 0);
   -- timing of U9: 9.520000ns
signal T11_h :  std_logic_vector(13 downto 0);
   -- timing of T11_h: 10.620000ns
signal T10 :  std_logic_vector(26 downto 0);
   -- timing of T10: 10.620000ns
signal S9 :  std_logic_vector(10 downto 0);
   -- timing of S9: 9.520000ns
signal d10 :  std_logic;
   -- timing of d10: 10.620000ns
signal T10s :  std_logic_vector(27 downto 0);
   -- timing of T10s: 10.620000ns
signal T10s_h :  std_logic_vector(14 downto 0);
   -- timing of T10s_h: 10.620000ns
signal T10s_l :  std_logic_vector(12 downto 0);
   -- timing of T10s_l: 10.620000ns
signal U10 :  std_logic_vector(14 downto 0);
   -- timing of U10: 10.620000ns
signal T12_h :  std_logic_vector(14 downto 0);
   -- timing of T12_h: 11.730000ns
signal T11 :  std_logic_vector(26 downto 0);
   -- timing of T11: 11.730000ns
signal S10 :  std_logic_vector(11 downto 0);
   -- timing of S10: 10.620000ns
signal d11 :  std_logic;
   -- timing of d11: 11.730000ns
signal T11s :  std_logic_vector(27 downto 0);
   -- timing of T11s: 11.730000ns
signal T11s_h :  std_logic_vector(15 downto 0);
   -- timing of T11s_h: 11.730000ns
signal T11s_l :  std_logic_vector(11 downto 0);
   -- timing of T11s_l: 11.730000ns
signal U11 :  std_logic_vector(15 downto 0);
   -- timing of U11: 11.730000ns
signal T13_h :  std_logic_vector(15 downto 0);
   -- timing of T13_h: 12.850000ns
signal T12 :  std_logic_vector(26 downto 0);
   -- timing of T12: 12.850000ns
signal S11 :  std_logic_vector(12 downto 0);
   -- timing of S11: 11.730000ns
signal d12 :  std_logic;
   -- timing of d12: 12.850000ns
signal T12s :  std_logic_vector(27 downto 0);
   -- timing of T12s: 12.850000ns
signal T12s_h :  std_logic_vector(16 downto 0);
   -- timing of T12s_h: 12.850000ns
signal T12s_l :  std_logic_vector(10 downto 0);
   -- timing of T12s_l: 12.850000ns
signal U12 :  std_logic_vector(16 downto 0);
   -- timing of U12: 12.850000ns
signal T14_h :  std_logic_vector(16 downto 0);
   -- timing of T14_h: 13.980000ns
signal T13 :  std_logic_vector(26 downto 0);
   -- timing of T13: 13.980000ns
signal S12 :  std_logic_vector(13 downto 0);
   -- timing of S12: 12.850000ns
signal d13 :  std_logic;
   -- timing of d13: 13.980000ns
signal T13s :  std_logic_vector(27 downto 0);
   -- timing of T13s: 13.980000ns
signal T13s_h :  std_logic_vector(17 downto 0);
   -- timing of T13s_h: 13.980000ns
signal T13s_l :  std_logic_vector(9 downto 0);
   -- timing of T13s_l: 13.980000ns
signal U13 :  std_logic_vector(17 downto 0);
   -- timing of U13: 13.980000ns
signal T15_h :  std_logic_vector(17 downto 0);
   -- timing of T15_h: 15.120000ns
signal T14 :  std_logic_vector(26 downto 0);
   -- timing of T14: 15.120000ns
signal S13 :  std_logic_vector(14 downto 0);
   -- timing of S13: 13.980000ns
signal d14 :  std_logic;
   -- timing of d14: 15.120000ns
signal T14s :  std_logic_vector(27 downto 0);
   -- timing of T14s: 15.120000ns
signal T14s_h :  std_logic_vector(18 downto 0);
   -- timing of T14s_h: 15.120000ns
signal T14s_l :  std_logic_vector(8 downto 0);
   -- timing of T14s_l: 15.120000ns
signal U14 :  std_logic_vector(18 downto 0);
   -- timing of U14: 15.120000ns
signal T16_h :  std_logic_vector(18 downto 0);
   -- timing of T16_h: 16.270000ns
signal T15 :  std_logic_vector(26 downto 0);
   -- timing of T15: 16.270000ns
signal S14 :  std_logic_vector(15 downto 0);
   -- timing of S14: 15.120000ns
signal d15 :  std_logic;
   -- timing of d15: 16.270000ns
signal T15s :  std_logic_vector(27 downto 0);
   -- timing of T15s: 16.270000ns
signal T15s_h :  std_logic_vector(19 downto 0);
   -- timing of T15s_h: 16.270000ns
signal T15s_l :  std_logic_vector(7 downto 0);
   -- timing of T15s_l: 16.270000ns
signal U15 :  std_logic_vector(19 downto 0);
   -- timing of U15: 16.270000ns
signal T17_h :  std_logic_vector(19 downto 0);
   -- timing of T17_h: 17.430000ns
signal T16 :  std_logic_vector(26 downto 0);
   -- timing of T16: 17.430000ns
signal S15 :  std_logic_vector(16 downto 0);
   -- timing of S15: 16.270000ns
signal d16 :  std_logic;
   -- timing of d16: 17.430000ns
signal T16s :  std_logic_vector(27 downto 0);
   -- timing of T16s: 17.430000ns
signal T16s_h :  std_logic_vector(20 downto 0);
   -- timing of T16s_h: 17.430000ns
signal T16s_l :  std_logic_vector(6 downto 0);
   -- timing of T16s_l: 17.430000ns
signal U16 :  std_logic_vector(20 downto 0);
   -- timing of U16: 17.430000ns
signal T18_h :  std_logic_vector(20 downto 0);
   -- timing of T18_h: 18.600000ns
signal T17 :  std_logic_vector(26 downto 0);
   -- timing of T17: 18.600000ns
signal S16 :  std_logic_vector(17 downto 0);
   -- timing of S16: 17.430000ns
signal d17 :  std_logic;
   -- timing of d17: 18.600000ns
signal T17s :  std_logic_vector(27 downto 0);
   -- timing of T17s: 18.600000ns
signal T17s_h :  std_logic_vector(21 downto 0);
   -- timing of T17s_h: 18.600000ns
signal T17s_l :  std_logic_vector(5 downto 0);
   -- timing of T17s_l: 18.600000ns
signal U17 :  std_logic_vector(21 downto 0);
   -- timing of U17: 18.600000ns
signal T19_h :  std_logic_vector(21 downto 0);
   -- timing of T19_h: 19.780000ns
signal T18 :  std_logic_vector(26 downto 0);
   -- timing of T18: 19.780000ns
signal S17 :  std_logic_vector(18 downto 0);
   -- timing of S17: 18.600000ns
signal d18 :  std_logic;
   -- timing of d18: 19.780000ns
signal T18s :  std_logic_vector(27 downto 0);
   -- timing of T18s: 19.780000ns
signal T18s_h :  std_logic_vector(22 downto 0);
   -- timing of T18s_h: 19.780000ns
signal T18s_l :  std_logic_vector(4 downto 0);
   -- timing of T18s_l: 19.780000ns
signal U18 :  std_logic_vector(22 downto 0);
   -- timing of U18: 19.780000ns
signal T20_h :  std_logic_vector(22 downto 0);
   -- timing of T20_h: 20.970000ns
signal T19 :  std_logic_vector(26 downto 0);
   -- timing of T19: 20.970000ns
signal S18 :  std_logic_vector(19 downto 0);
   -- timing of S18: 19.780000ns
signal d19 :  std_logic;
   -- timing of d19: 20.970000ns
signal T19s :  std_logic_vector(27 downto 0);
   -- timing of T19s: 20.970000ns
signal T19s_h :  std_logic_vector(23 downto 0);
   -- timing of T19s_h: 20.970000ns
signal T19s_l :  std_logic_vector(3 downto 0);
   -- timing of T19s_l: 20.970000ns
signal U19 :  std_logic_vector(23 downto 0);
   -- timing of U19: 20.970000ns
signal T21_h :  std_logic_vector(23 downto 0);
   -- timing of T21_h: 22.170000ns
signal T20 :  std_logic_vector(26 downto 0);
   -- timing of T20: 22.170000ns
signal S19 :  std_logic_vector(20 downto 0);
   -- timing of S19: 20.970000ns
signal d20 :  std_logic;
   -- timing of d20: 22.170000ns
signal T20s :  std_logic_vector(27 downto 0);
   -- timing of T20s: 22.170000ns
signal T20s_h :  std_logic_vector(24 downto 0);
   -- timing of T20s_h: 22.170000ns
signal T20s_l :  std_logic_vector(2 downto 0);
   -- timing of T20s_l: 22.170000ns
signal U20 :  std_logic_vector(24 downto 0);
   -- timing of U20: 22.170000ns
signal T22_h :  std_logic_vector(24 downto 0);
   -- timing of T22_h: 23.380000ns
signal T21 :  std_logic_vector(26 downto 0);
   -- timing of T21: 23.380000ns
signal S20 :  std_logic_vector(21 downto 0);
   -- timing of S20: 22.170000ns
signal d21 :  std_logic;
   -- timing of d21: 23.380000ns
signal T21s :  std_logic_vector(27 downto 0);
   -- timing of T21s: 23.380000ns
signal T21s_h :  std_logic_vector(25 downto 0);
   -- timing of T21s_h: 23.380000ns
signal T21s_l :  std_logic_vector(1 downto 0);
   -- timing of T21s_l: 23.380000ns
signal U21 :  std_logic_vector(25 downto 0);
   -- timing of U21: 23.380000ns
signal T23_h :  std_logic_vector(25 downto 0);
   -- timing of T23_h: 24.600000ns
signal T22 :  std_logic_vector(26 downto 0);
   -- timing of T22: 24.600000ns
signal S21 :  std_logic_vector(22 downto 0);
   -- timing of S21: 23.380000ns
signal d22 :  std_logic;
   -- timing of d22: 24.600000ns
signal T22s :  std_logic_vector(27 downto 0);
   -- timing of T22s: 24.600000ns
signal T22s_h :  std_logic_vector(26 downto 0);
   -- timing of T22s_h: 24.600000ns
signal T22s_l :  std_logic_vector(0 downto 0);
   -- timing of T22s_l: 24.600000ns
signal U22 :  std_logic_vector(26 downto 0);
   -- timing of U22: 24.600000ns
signal T24_h :  std_logic_vector(26 downto 0);
   -- timing of T24_h: 25.830000ns
signal T23 :  std_logic_vector(26 downto 0);
   -- timing of T23: 25.830000ns
signal S22 :  std_logic_vector(23 downto 0);
   -- timing of S22: 24.600000ns
signal d23 :  std_logic;
   -- timing of d23: 25.830000ns
signal T23s :  std_logic_vector(27 downto 0);
   -- timing of T23s: 25.830000ns
signal T23s_h :  std_logic_vector(27 downto 0);
   -- timing of T23s_h: 25.830000ns
signal U23 :  std_logic_vector(27 downto 0);
   -- timing of U23: 25.830000ns
signal T25_h :  std_logic_vector(27 downto 0);
   -- timing of T25_h: 27.070000ns
signal T24 :  std_logic_vector(26 downto 0);
   -- timing of T24: 27.070000ns
signal S23 :  std_logic_vector(24 downto 0);
   -- timing of S23: 25.830000ns
signal d25 :  std_logic;
   -- timing of d25: 27.070000ns
signal mR :  std_logic_vector(25 downto 0);
   -- timing of mR: 27.070000ns
signal fR :  std_logic_vector(22 downto 0);
   -- timing of fR: 27.070000ns
signal round :  std_logic;
   -- timing of round: 27.070000ns
signal fRrnd :  std_logic_vector(22 downto 0);
   -- timing of fRrnd: 28.290000ns
signal Rn2 :  std_logic_vector(30 downto 0);
   -- timing of Rn2: 28.290000ns
signal xsR :  std_logic_vector(2 downto 0);
   -- timing of xsR: 0.050000ns
begin
   fracX <= X(22 downto 0); -- fraction
   eRn0 <= "0" & X(30 downto 24); -- exponent
   xsX <= X(33 downto 31); -- exception and sign
   eRn1 <= eRn0 + ("00" & (5 downto 0 => '1')) + X(23);
   fracXnorm <= "1" & fracX & "000" when X(23) = '0' else
         "01" & fracX&"00"; -- pre-normalization
   S0 <= "01";
   T1 <= ("0111" + fracXnorm(26 downto 23)) & fracXnorm(22 downto 0);
   -- now implementing the recurrence 
   --  this is a binary non-restoring algorithm, see ASA book
   -- Step 2
   d1 <= not T1(26); --  bit of weight -1
   T1s <= T1 & "0";
   T1s_h <= T1s(27 downto 22);
   T1s_l <= T1s(21 downto 0);
   U1 <=  "0" & S0 & d1 & (not d1) & "1"; 
   T3_h <=   T1s_h - U1 when d1='1'
        else T1s_h + U1;
   T2 <= T3_h(4 downto 0) & T1s_l;
   S1 <= S0 & d1; -- here -1 becomes 0 and 1 becomes 1
   -- Step 3
   d2 <= not T2(26); --  bit of weight -2
   T2s <= T2 & "0";
   T2s_h <= T2s(27 downto 21);
   T2s_l <= T2s(20 downto 0);
   U2 <=  "0" & S1 & d2 & (not d2) & "1"; 
   T4_h <=   T2s_h - U2 when d2='1'
        else T2s_h + U2;
   T3 <= T4_h(5 downto 0) & T2s_l;
   S2 <= S1 & d2; -- here -1 becomes 0 and 1 becomes 1
   -- Step 4
   d3 <= not T3(26); --  bit of weight -3
   T3s <= T3 & "0";
   T3s_h <= T3s(27 downto 20);
   T3s_l <= T3s(19 downto 0);
   U3 <=  "0" & S2 & d3 & (not d3) & "1"; 
   T5_h <=   T3s_h - U3 when d3='1'
        else T3s_h + U3;
   T4 <= T5_h(6 downto 0) & T3s_l;
   S3 <= S2 & d3; -- here -1 becomes 0 and 1 becomes 1
   -- Step 5
   d4 <= not T4(26); --  bit of weight -4
   T4s <= T4 & "0";
   T4s_h <= T4s(27 downto 19);
   T4s_l <= T4s(18 downto 0);
   U4 <=  "0" & S3 & d4 & (not d4) & "1"; 
   T6_h <=   T4s_h - U4 when d4='1'
        else T4s_h + U4;
   T5 <= T6_h(7 downto 0) & T4s_l;
   S4 <= S3 & d4; -- here -1 becomes 0 and 1 becomes 1
   -- Step 6
   d5 <= not T5(26); --  bit of weight -5
   T5s <= T5 & "0";
   T5s_h <= T5s(27 downto 18);
   T5s_l <= T5s(17 downto 0);
   U5 <=  "0" & S4 & d5 & (not d5) & "1"; 
   T7_h <=   T5s_h - U5 when d5='1'
        else T5s_h + U5;
   T6 <= T7_h(8 downto 0) & T5s_l;
   S5 <= S4 & d5; -- here -1 becomes 0 and 1 becomes 1
   -- Step 7
   d6 <= not T6(26); --  bit of weight -6
   T6s <= T6 & "0";
   T6s_h <= T6s(27 downto 17);
   T6s_l <= T6s(16 downto 0);
   U6 <=  "0" & S5 & d6 & (not d6) & "1"; 
   T8_h <=   T6s_h - U6 when d6='1'
        else T6s_h + U6;
   T7 <= T8_h(9 downto 0) & T6s_l;
   S6 <= S5 & d6; -- here -1 becomes 0 and 1 becomes 1
   -- Step 8
   d7 <= not T7(26); --  bit of weight -7
   T7s <= T7 & "0";
   T7s_h <= T7s(27 downto 16);
   T7s_l <= T7s(15 downto 0);
   U7 <=  "0" & S6 & d7 & (not d7) & "1"; 
   T9_h <=   T7s_h - U7 when d7='1'
        else T7s_h + U7;
   T8 <= T9_h(10 downto 0) & T7s_l;
   S7 <= S6 & d7; -- here -1 becomes 0 and 1 becomes 1
   -- Step 9
   d8 <= not T8(26); --  bit of weight -8
   T8s <= T8 & "0";
   T8s_h <= T8s(27 downto 15);
   T8s_l <= T8s(14 downto 0);
   U8 <=  "0" & S7 & d8 & (not d8) & "1"; 
   T10_h <=   T8s_h - U8 when d8='1'
        else T8s_h + U8;
   T9 <= T10_h(11 downto 0) & T8s_l;
   S8 <= S7 & d8; -- here -1 becomes 0 and 1 becomes 1
   -- Step 10
   d9 <= not T9(26); --  bit of weight -9
   T9s <= T9 & "0";
   T9s_h <= T9s(27 downto 14);
   T9s_l <= T9s(13 downto 0);
   U9 <=  "0" & S8 & d9 & (not d9) & "1"; 
   T11_h <=   T9s_h - U9 when d9='1'
        else T9s_h + U9;
   T10 <= T11_h(12 downto 0) & T9s_l;
   S9 <= S8 & d9; -- here -1 becomes 0 and 1 becomes 1
   -- Step 11
   d10 <= not T10(26); --  bit of weight -10
   T10s <= T10 & "0";
   T10s_h <= T10s(27 downto 13);
   T10s_l <= T10s(12 downto 0);
   U10 <=  "0" & S9 & d10 & (not d10) & "1"; 
   T12_h <=   T10s_h - U10 when d10='1'
        else T10s_h + U10;
   T11 <= T12_h(13 downto 0) & T10s_l;
   S10 <= S9 & d10; -- here -1 becomes 0 and 1 becomes 1
   -- Step 12
   d11 <= not T11(26); --  bit of weight -11
   T11s <= T11 & "0";
   T11s_h <= T11s(27 downto 12);
   T11s_l <= T11s(11 downto 0);
   U11 <=  "0" & S10 & d11 & (not d11) & "1"; 
   T13_h <=   T11s_h - U11 when d11='1'
        else T11s_h + U11;
   T12 <= T13_h(14 downto 0) & T11s_l;
   S11 <= S10 & d11; -- here -1 becomes 0 and 1 becomes 1
   -- Step 13
   d12 <= not T12(26); --  bit of weight -12
   T12s <= T12 & "0";
   T12s_h <= T12s(27 downto 11);
   T12s_l <= T12s(10 downto 0);
   U12 <=  "0" & S11 & d12 & (not d12) & "1"; 
   T14_h <=   T12s_h - U12 when d12='1'
        else T12s_h + U12;
   T13 <= T14_h(15 downto 0) & T12s_l;
   S12 <= S11 & d12; -- here -1 becomes 0 and 1 becomes 1
   -- Step 14
   d13 <= not T13(26); --  bit of weight -13
   T13s <= T13 & "0";
   T13s_h <= T13s(27 downto 10);
   T13s_l <= T13s(9 downto 0);
   U13 <=  "0" & S12 & d13 & (not d13) & "1"; 
   T15_h <=   T13s_h - U13 when d13='1'
        else T13s_h + U13;
   T14 <= T15_h(16 downto 0) & T13s_l;
   S13 <= S12 & d13; -- here -1 becomes 0 and 1 becomes 1
   -- Step 15
   d14 <= not T14(26); --  bit of weight -14
   T14s <= T14 & "0";
   T14s_h <= T14s(27 downto 9);
   T14s_l <= T14s(8 downto 0);
   U14 <=  "0" & S13 & d14 & (not d14) & "1"; 
   T16_h <=   T14s_h - U14 when d14='1'
        else T14s_h + U14;
   T15 <= T16_h(17 downto 0) & T14s_l;
   S14 <= S13 & d14; -- here -1 becomes 0 and 1 becomes 1
   -- Step 16
   d15 <= not T15(26); --  bit of weight -15
   T15s <= T15 & "0";
   T15s_h <= T15s(27 downto 8);
   T15s_l <= T15s(7 downto 0);
   U15 <=  "0" & S14 & d15 & (not d15) & "1"; 
   T17_h <=   T15s_h - U15 when d15='1'
        else T15s_h + U15;
   T16 <= T17_h(18 downto 0) & T15s_l;
   S15 <= S14 & d15; -- here -1 becomes 0 and 1 becomes 1
   -- Step 17
   d16 <= not T16(26); --  bit of weight -16
   T16s <= T16 & "0";
   T16s_h <= T16s(27 downto 7);
   T16s_l <= T16s(6 downto 0);
   U16 <=  "0" & S15 & d16 & (not d16) & "1"; 
   T18_h <=   T16s_h - U16 when d16='1'
        else T16s_h + U16;
   T17 <= T18_h(19 downto 0) & T16s_l;
   S16 <= S15 & d16; -- here -1 becomes 0 and 1 becomes 1
   -- Step 18
   d17 <= not T17(26); --  bit of weight -17
   T17s <= T17 & "0";
   T17s_h <= T17s(27 downto 6);
   T17s_l <= T17s(5 downto 0);
   U17 <=  "0" & S16 & d17 & (not d17) & "1"; 
   T19_h <=   T17s_h - U17 when d17='1'
        else T17s_h + U17;
   T18 <= T19_h(20 downto 0) & T17s_l;
   S17 <= S16 & d17; -- here -1 becomes 0 and 1 becomes 1
   -- Step 19
   d18 <= not T18(26); --  bit of weight -18
   T18s <= T18 & "0";
   T18s_h <= T18s(27 downto 5);
   T18s_l <= T18s(4 downto 0);
   U18 <=  "0" & S17 & d18 & (not d18) & "1"; 
   T20_h <=   T18s_h - U18 when d18='1'
        else T18s_h + U18;
   T19 <= T20_h(21 downto 0) & T18s_l;
   S18 <= S17 & d18; -- here -1 becomes 0 and 1 becomes 1
   -- Step 20
   d19 <= not T19(26); --  bit of weight -19
   T19s <= T19 & "0";
   T19s_h <= T19s(27 downto 4);
   T19s_l <= T19s(3 downto 0);
   U19 <=  "0" & S18 & d19 & (not d19) & "1"; 
   T21_h <=   T19s_h - U19 when d19='1'
        else T19s_h + U19;
   T20 <= T21_h(22 downto 0) & T19s_l;
   S19 <= S18 & d19; -- here -1 becomes 0 and 1 becomes 1
   -- Step 21
   d20 <= not T20(26); --  bit of weight -20
   T20s <= T20 & "0";
   T20s_h <= T20s(27 downto 3);
   T20s_l <= T20s(2 downto 0);
   U20 <=  "0" & S19 & d20 & (not d20) & "1"; 
   T22_h <=   T20s_h - U20 when d20='1'
        else T20s_h + U20;
   T21 <= T22_h(23 downto 0) & T20s_l;
   S20 <= S19 & d20; -- here -1 becomes 0 and 1 becomes 1
   -- Step 22
   d21 <= not T21(26); --  bit of weight -21
   T21s <= T21 & "0";
   T21s_h <= T21s(27 downto 2);
   T21s_l <= T21s(1 downto 0);
   U21 <=  "0" & S20 & d21 & (not d21) & "1"; 
   T23_h <=   T21s_h - U21 when d21='1'
        else T21s_h + U21;
   T22 <= T23_h(24 downto 0) & T21s_l;
   S21 <= S20 & d21; -- here -1 becomes 0 and 1 becomes 1
   -- Step 23
   d22 <= not T22(26); --  bit of weight -22
   T22s <= T22 & "0";
   T22s_h <= T22s(27 downto 1);
   T22s_l <= T22s(0 downto 0);
   U22 <=  "0" & S21 & d22 & (not d22) & "1"; 
   T24_h <=   T22s_h - U22 when d22='1'
        else T22s_h + U22;
   T23 <= T24_h(25 downto 0) & T22s_l;
   S22 <= S21 & d22; -- here -1 becomes 0 and 1 becomes 1
   -- Step 24
   d23 <= not T23(26); --  bit of weight -23
   T23s <= T23 & "0";
   T23s_h <= T23s(27 downto 0);
   U23 <=  "0" & S22 & d23 & (not d23) & "1"; 
   T25_h <=   T23s_h - U23 when d23='1'
        else T23s_h + U23;
   T24 <= T25_h(26 downto 0);
   S23 <= S22 & d23; -- here -1 becomes 0 and 1 becomes 1
   d25 <= not T24(26) ; -- the sign of the remainder will become the round bit
   mR <= S23 & d25; -- result significand
   fR <= mR(23 downto 1);-- removing leading 1
   round <= mR(0); -- round bit
   fRrnd <= fR + ((22 downto 1 => '0') & round); -- rounding sqrt never changes exponents 
   Rn2 <= eRn1 & fRrnd;
   -- sign and exception processing
   with xsX  select 
      xsR <= "010"  when "010",  -- normal case
             "100"  when "100",  -- +infty
             "000"  when "000",  -- +0
             "001"  when "001",  -- the infamous sqrt(-0)=-0
             "110"  when others; -- return NaN
   R <= xsR & Rn2; 
end architecture;

