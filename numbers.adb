--Extra Credit was attempted
--This program takes in a number and finds all factors of the number
--If the number is prime then no factors are printed
--If the number is composite then all the factors are printed
--Then the prime factorization is printed

--Speed:

--To find the factors all numbers up to sqrt(n) are checked where n is input
--when a factor is found its co-factor is then found and added to a list
--in order to prevent sorting two arrays are maintained and
--the first array is returned

--A method to determine if something is prime checks in sqrt(n) where n is
--the input

--For each factor that can be put into the number we take that prime
--factor out of the number as many times as possible to determine
--its power

--When a prime factor is found it is printed

with Ada.Text_IO, Ada.Long_Long_Integer_Text_IO;
use Ada.Text_IO, Ada.Long_Long_Integer_Text_IO;

procedure numbers is

   subtype Positive_Large_Integer is
     Long_Long_Integer range 1 .. Long_Long_Integer'Last;
   procedure Iteration (Input_Integer : Positive_Large_Integer) is

      --binary search for square root functionally floor
      --should functionally floor the sqrt
      function Sqrt
        (Input : Positive_Large_Integer) return Positive_Large_Integer
      is
         Largest_Possible_Guess : Long_Long_Integer := 3_037_000_498;
         Lowest                 : Long_Long_Integer := 0;
         Highest : Long_Long_Integer := Largest_Possible_Guess * 2;
         Guess                  : Long_Long_Integer := Largest_Possible_Guess;
      begin

         --while there are values between
         while (Highest - Lowest > 1) loop

            --if the guess is correct return it
            --if the guess is too large make it smaller
            --if it is to small make it bigger
            --this algo should functionally floor the sqrt
            if (Guess**2 = Input) then
               return Guess;
            elsif (Guess**2 > Input) then
               Highest := Guess;
            else
               Lowest := Guess;
            end if;
            Guess := (Highest - Lowest) / 2 + Lowest;
         end loop;
         return Guess;
      end Sqrt;

      --simply an integer array type
      type Long_Array is array (Positive range <>) of Long_Long_Integer;

      --this is going to be the size allocation
      --not sure about the maximum number of factors
      Array_Size_Allocation : Integer := 100_000;

      --function intened to take an integer to factor
      --will return an array of the factors for that integer
      function Get_Factors
        (toFactor : Positive_Large_Integer) return Long_Array
      is

         --get the arrays as first and second to avoid sorting
         Factors_First             : Long_Array (1 .. Array_Size_Allocation);
         Factors_Second            : Long_Array (1 .. Array_Size_Allocation);
         First_Index, Second_Index : Integer := 1;

         --variable that is the cofactor of a factor
         Ipair : Positive_Large_Integer;

      begin

         --for every I from 1 to sqrt(input)
         for I in 1 .. Sqrt (toFactor) loop

            --if is a factor
            if toFactor mod I = 0 then

               --add to end of first list
               Factors_First (First_Index) := I;
               First_Index                 := First_Index + 1;

               --get cofactor
               Ipair := toFactor / I;

               --if coFactor is not the first factor^2
               if Ipair /= I then

                  --add to end of second list
                  Factors_Second (Second_Index) := Ipair;
                  Second_Index                  := Second_Index + 1;
               end if;
            end if;

         end loop;

         --just add to first should be sorted after
         for I in reverse 1 .. Second_Index - 1 loop
            Factors_First (First_Index) := Factors_Second (I);
            First_Index                 := First_Index + 1;
         end loop;

         --basically tell where this array ends
         Factors_First (First_Index) := 0;

         return Factors_First;
      end Get_Factors;

      --Takes a number in and if the number is divisible by any
      --possible factor then is false
      --assumes input number equal greater than 1
      --1 should have been caught before this method executes
      function Is_Prime (Number : Positive_Large_Integer) return Boolean is
      begin
         for I in 2 .. Sqrt (Number) loop
            if (Number mod I = 0) then
               return False;
            end if;

         end loop;
         return True;
      end Is_Prime;

      --the array of factors for a given number
      Factor_Array : Long_Array (1 .. Array_Size_Allocation);
      --This is the end of the factor array
      Array_End : Integer;
      --this is a variable to help find prime fact
      Many : Long_Long_Integer;
      --variable to also help find prime fact
      Left : Long_Long_Integer;
   begin

      Put (Input_Integer, 0);
      New_Line;

      if Input_Integer = 1 then

         Put ("1 is neither prime nor composite");
         New_Line;
      else

         --get factors and find the intended of the array
         Factor_Array := Get_Factors (Input_Integer);
         for I in Factor_Array'Range loop
            if (Factor_Array (I) = 0) then
               Array_End := I - 1;
               exit;
            end if;
         end loop;

         Put (Input_Integer, 0);

         if Array_End = 2 then

            Put (" is prime");
            New_Line;
         else

            Put_Line (" is composite");
            Put ("The positive factors of ");
            Put (Input_Integer, 0);
            Put (" are: ");

            --print factors
            Put (Factor_Array(1), 0);
            for I in 2 .. Array_End loop
               Put (", ");
               Put (Factor_Array(I), 0);
            end loop;
            New_Line;

            Put ("The prime factorization of ");
            Put (Input_Integer, 0);
            Put (" is: ");

            --prime factorization
            Left := Input_Integer;
            --for possible primes
            for I in 2 .. Array_End - 1 loop
               --if the factor is prime
               if (Is_Prime (Factor_Array (I))) then

                  --find how many times the factor can go into what is left
                  Many := 0;
                  loop
                     exit when Left mod Factor_Array (I) /= 0;
                     Many := Many + 1;
                     Left := Left / Factor_Array (I);
                  end loop;
                  --assumes the factor went into it at least once
                  Put (Factor_Array(I), 0);
                  if Many > 1 then
                     Put (" ** ");
                     Put (Many, 0);
                  end if;

                  if Left > 1 then
                     Put (" * ");
                  end if;
               end if;
            end loop;

            New_Line;
         end if;

      end if;
      New_Line;
   end Iteration;

   --input
   Input_Integer : Positive_Large_Integer;
begin
   loop
      --while not end of file
      exit when End_Of_File;
      --get next num
      Get (Input_Integer);
      --complete operations and provide output
      Iteration (Input_Integer);
   end loop;
end numbers;
