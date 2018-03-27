program matrix_project;

{ sčítání, násobení, inverze, determinant a LU-dekompozice. }

uses crt;

const max = 10;         { Maximální velikost matice }

type Matrix = record                                     { Naše matice budou definované podle tohoto seznamu }
              m: integer;
              n: integer;                              { počet řádků, počet sloupců }
              mat: array[1..max,1..max] of real;      { K uložení prvků matice použijeme dvoudimenzionální pole }
end;
    UkMat = ^Matrix;                                       {Ukazatel, který bude ukazovat na matici, s kterou si budeme přát pracovat}
    TMatrix = array[1..max,1..max] of real;

var
     matrices:array['a'..'z'] of UkMat;
     i, j, k, m, n: integer;
     command: string;
procedure title;
begin
     writeln;
     writeln('  __      ___   ______  _________  ________    __  ___    ___');
     writeln(' |  \    /   | /  __  \|__    ___||   ___  \  |  | \  \  /  /');
     writeln(' |   \  /    ||  /__\  |   |  |   |  |   \  \ |  |  \  \/  /');
     writeln(' |    \/     ||        |   |  |   |  |___/  / |  |   \    / ');
     writeln(' |       /|  ||   __   |   |  |   |   __   /  |  |   /    \');
     writeln(' |  |\  / |  ||  |  |  |   |  |   |  |  \  \  |  |  /  /\  \');
     writeln(' |  | \/  |  ||  |  |  |   |  |   |  |   \  \ |  | /  /  \  \');
     writeln(' |__/     |__/|__/  |__/   |__/   |__/    \__\|__|/__/    \__\');
     writeln('              ____      ___      _      ____      ');
     writeln('             /  __\    / _ \    | |    /  __\     ');
     writeln('             | |      / /_\ \   | |    | |        ');
     writeln('             | |__   / _____ \  | |__  | |__      ');
     writeln('             \____/ /_/     \_\ |____| \____/     ');
     writeln;
end;
procedure help;                           { Vypsání nápovědy - všechny příkazy }
begin
     writeln('H E L P');
     writeln;
     writeln('You can add 26 matrices from "a" to "z".');
     writeln;
     writeln('Commands:');
     writeln;
     writeln('help                 - shows you this text');
     writeln('about                - shows you the info about program');
     writeln('exit                 - exit the program');
     writeln('listall         - list all 26 matrices');
     writeln;
     writeln('store x              - store the matrix');
     writeln('clear x              - clear the matrix');
     writeln('list x               - list the matrix');
     writeln('det x                - counts the determinant (up to 3x3)');
     writeln;
     writeln('invert x y           - stores the inversion of x into y');
     writeln;
     writeln('add x y z            - add x + y and save into z');
     writeln('multiply x y z       - multiply x * y and save into z');
     writeln('dcmp x y z  - creates LUP decomposition of matrix');
     writeln;
end;
procedure listall;                       { Vypise seznam matic }
var  c:char;
begin
     writeln('List of all matrices:');
     writeln;
     for c:= 'a' to 'm' do begin
         write(c, ' - ');
         if matrices[c] = nil then write('[    ];   ')
         else write('[xxxx];   ');

         write(char(ord(c)+13), ' - ');
         if matrices[char(ord(c)+13)] = nil then write('[    ];   ')
         else write('[xxxx];    ');
         writeln;
     end;
     writeln;
     writeln('* [    ] - empty, [xxxx] - full');
end;
procedure about;
begin
     writeln;
     writeln('My name is Martin Studna and welcome in my program, which');
     writeln('is called Matrix Calculator. This program was created as');
     writeln('a school project for subject Programming I at Charles University');
     writeln('in Prague.');
     writeln;
end;
procedure store(place:char);                     { Procedura pro ukládání matice }
var  uk:UkMat;
begin

     if matrices[place] <> nil then begin                          { Pokud tam není NIlový ukazatel => znamená to, že místo v poli je už obsazené, takže se tam nová matice nedá zadat }
        writeln('This place is not empty');                    { Nemůžu vložit matici se stejným názvem => procedura se ukončí }
        exit;
     end;

     writeln;
     writeln('STORING THE MATRIX');
     writeln;

     new(uk);
     writeln('Insert the height of your matrix: '); read(uk^.m);
     writeln('Insert the width of your matrix: '); read(uk^.n);     { Pokud můžu matici vložit => zadám rozměry matice }

     if (uk^.m > max) or (uk^.n > max) then begin
        writeln('Matrix is too large!');                 { Pokud jeden z rozměrů bude větší jak 10 => program vypíše, že matice je moc velká a procedura se ukončí }
        exit;
     end;

     for m:= 1 to uk^.m do for n:= 1 to uk^.n do begin
        write('Matrix ', place, '(', m, ',', n, '): ');
        read(uk^.mat[m, n]);
        writeln;                                                { Pokud jsou všechny podmínky splněny => začnu ukládat prvky do matice }
     end;
     matrices[place] := uk;
     writeln('Matrix was successfully saved!');
end;
procedure list(place:char);                       { Procedura pro vypsani matice }
var uk:UkMat;
begin
     writeln;
     writeln('LISTING THE MATRIX');
     writeln;

     if matrices[place] = nil then begin        { Pokud ukazatel ukazuje na nil, matice je prazdna }
        writeln('This matrix is empty');
        exit;
     end;

     uk := matrices[place];
     writeln;
     writeln('----Matrix ', place, ': -----');
     write('__|__');
     for i:= 1 to uk^.n do write('__', i,'__', '|');
     writeln;

     for m:= 1 to uk^.m do begin
          writeln('  |');
          write('_', m,'|');
          for n:= 1 to uk^.n do begin
              write('    ', uk^.mat[m, n]:0:2);
          end;
     end;
end;
procedure clear(place:char);                        { Vymazat matici }
begin
     writeln;
     writeln('CLEARING THE MATRIX');
     writeln;

     if matrices[place] =  nil then begin               { Nemam, co smazat. Matice je uz prazdna }
        writeln('This matrix is already empty!');
        exit;
     end;
     dispose(matrices[place]);
     matrices[place] := nil;

     writeln('Matrix was successfully cleared!');
end;
procedure add(A: char; B: char; C: char);              { Scitani matic }
var  x,y,z: UkMat;
begin
     writeln;
     writeln('ADDING MATRICES');
     writeln;

     if (matrices[A]=nil) OR (matrices[B]=nil) then begin        { Jedna z matic je prazdna }
        writeln('One of two matrices is empty!');
        exit;
     end;

     if (matrices[C] <> nil)  then begin
        writeln('Matrix for storing is not empty!');             { matice pro ukladani neni prazdna}
        exit;
     end;

     x:=matrices[A];
     y:=matrices[B];

     if (x^.m <> y^.m) OR (x^.n <> y^.n)  then begin                   { Matice maji jine rozmery }
        writeln('Matrices have different size!');
        exit;
     end;

     new(z);
     z^.m:=x^.m;
     z^.n:=x^.n;
     for i:=1 to x^.m do for j:=1 to x^.n do
         z^.mat[i,j]:=x^.mat[i,j] + y^.mat[i,j];

     matrices[C]:=z
end;
procedure multiply(A: char; B: char; C: char);                       { Nasobeni matic }
var  x,y,z:UkMat;
begin
     writeln;
     writeln('MULTIPLYING MATRICES');
     writeln;

     if (matrices[A]=nil) OR (matrices[B]=nil) then begin            { Jedna z matic je prazdna }
        writeln('One of two matrices is empty!');
        exit;
       end;

     if (matrices[C] <> nil)  then begin                               { Matice pro ukladani neni prazdna }
        writeln('Matrix for storing is not empty!');
        exit;
     end;

     x:=matrices[A];
     y:=matrices[B];

     if (x^.n <> y^.m)  then begin
       writeln('The width of 1. matrix is not the same as the height of 2. matrix!');
       exit;
     end;

     new(z);
     z^.m:=x^.m;
     z^.n:=y^.n;

     for i:=1 to x^.m do for j:=1 to y^.n do begin
         z^.mat[i,j] := 0;
         for k := 1 to x^.n do
             z^.mat[i,j] := x^.mat[i,k]*y^.mat[k,j] + z^.mat[i,j];
         end;
     matrices[C]:=z;
end;
function grade(mat:TMatrix; m,n:Integer):TMatrix;
var     zeros: Array[1..max] of integer;     { pocet nul v kazdym radku }
        c, ic: Integer;
        v, w: Integer;
begin
     for v:= 1 to m do begin
         c:=0;                   { c je pocet nul }
         for w:= 1 to n do begin
             if mat[v,w]=0 then inc(c)
             else break;
         end;
         zeros[v]:= c;
     end;
     for v:= 1 to m do begin
         c := 10000;              { c - nejmensi pocet nul}
         ic:= 0;                  { index c }
         for w:= 1 to m do
             if zeros[w]<c then begin
                  c:=zeros[w]; ic:=w
             end;
             zeros[ic]:= 10000;
             for w:= 1 to n do grade[v,w]:=mat[ic,w];
     end;
end;
function gauss(mat: TMatrix; m: integer; n: integer):TMatrix;
var  c, pop: Integer;
     d: Real;
begin
     pop :=0;                               { pozice pivotu }
     for j := 1 to m do                     { jdu pres radky }
     begin
          inc(pop);
          mat := grade(mat,m,n);
          while mat[j,pop]=0 do inc(pop);

          for i:= j to m do                 { jdu pres tuto radku + zbytek radek }
          begin
               if (i > j) and (mat[i,pop] = 0) then break;
               d:= mat[i,pop];
               for c:= pop to n do  mat[i,c]:=mat[i,c]/d;
               if i > j then
                  for c:= pop to n do  mat[i,c]:=mat[i,c] - mat[j,c];
          end;
     end;
     gauss:=mat;
end;
function jordano(mat:TMatrix; m:integer; n:integer):TMatrix;
var  c: Integer;
     d: Real;
begin
     for i:= m-1 downto 1 do begin
         for c:= m downto i+1 do begin
             d:=jordano[i,c];
             for j:= 1 to n do
                 jordano[i,j]:= jordano[i,j] - d*jordano[c,j];
         end;
     end;
end;
procedure invert(place:char; target:char);
var  mat:TMatrix;
     c,p: UkMat;
begin

     if matrices[place] =  nil then begin                           { zdrojova matice je prazdna }
        writeln('The source matrix is empty!');
        exit;
     end;

     if matrices[target] <> nil  then begin                         { cilova matice je prazdna }
        writeln('Matrix for storing is not empty!');
        exit;
     end;

     if matrices[place]^.n <> matrices[place]^.m then begin          { vstupni matice neni ctvercova }
        writeln('The source matrix should be square!');
        exit;
     end;

     p:= matrices[place];

     for i:=1 to p^.m do for j:= 1 to p^.n do mat[i,j]:= p^.mat[i,j];    { ulozim  do 'mat' }

     for i:= 1 to p^.m do  for j:= p^.m+1 to 2*p^.m do
     if j=i+p^.m then mat[i,j]:= 1
     else mat[i,j]:=0;

     mat:=gauss(mat,p^.m, p^.m*2);    { prevod do odstupnovaneho tvaru }

     if mat[p^.m, p^.m] = 0 then begin
        writeln('This matrix is singular!');
        exit;
     end;

     mat:=jordano(mat,p^.m, p^.m*2);    { prevod do jednotkove matice + 'solution vector'}

     new(c);
     c^.m := p^.m;
     c^.n := p^.n;
     for i:= 1 to p^.n do for j:=1 to p^.n do
                c^.mat[i,j]:=mat[i,p^.n+j];
     matrices[target]:=c;

     writeln('Inverted matrix was successfully calculated!');
end;
procedure dcmp(A: char; L: char; U: char);                 { LU dekompozice }
var x,y,z:UkMat;
    sum: real;
    n: integer;
    i,j,k:integer;
begin
     if matrices[A] = nil then begin
        writeln('The source matrix is empty!');
        exit;
     end;

     if (matrices[L] <> nil) and (matrices[U] <> nil) then begin
        writeln('Matrices for storing are not empty!');
        exit;
     end;

     if matrices[A]^.n <> matrices[A]^.m then begin
        writeln('Matrix is not square!');
        exit;
     end;

     sum:=0;
     x:=matrices[A];



     n:=x^.n;
     new(y);
     new(z);
     y^.m := x^.n;
     y^.n := x^.n;
     z^.m := x^.n;
     z^.n := x^.n;

     for i:=1 to n do z^.mat[i,i] := 1;

     for j:= 1 to n do begin
         for i := j to n do begin
             sum:=0;
             for k:= 1 to j do begin
                 sum := sum + y^.mat[i,k]*z^.mat[k,j];
             end;
             y^.mat[i,j]:=x^.mat[i,j] - sum;
         end;

         for i := j to n do begin
             sum := 0;
             for k := 1 to j do begin
                 sum := sum + y^.mat[j,k]*z^.mat[k,i];
             end;
             if y^.mat[j,j] = 0 then begin
                writeln('Can not divide by 0!');
                exit;
             end;
             z^.mat[j,i] := (x^.mat[j,i] - sum) / y^.mat[j,j];
         end;
     end;

     for i:=1 to n do begin
         z^.mat[i,i] := 1;
     end;

     matrices[L]:=y;
     matrices[U]:=z;
end;
procedure det(A:char);
var  det: real;
     x:UkMat;
begin
     dcmp(A,'b','c');

     x:=matrices['b'];
     det:=1;
     for i := 1 to x^.n do det := det*x^.mat[i,i];
     writeln(det:0:2);
     clear('b');
     clear('c');
end;
procedure option(command:string);
var  a,b,c:string;
begin

     if (command = 'help') then   help;
     if (command = 'listall') then  listall;
     if (command = 'about') then    about;

     if (command = 'store') or (command = 'list') or (command = 'solve') or  (command = 'clear') or (command = 'det') then
     begin
          write('Matrix: ');
          readln(a);
          if (command='store') then store(a[1]);
          if (command='list') then  list(a[1]);
          if (command='clear') then clear(a[1]);
          if (command='det') then   det(a[1]);
     end;

     if (command = 'invert') then begin
          write('Matrix: ');
          readln(a);
          write('Store Result: ');
          readln(b);
          invert(a[1],b[1]);
     end;

     if (command = 'add') or (command = 'multiply') then begin
          write('Matrix_1: ');
          readln(a);
          write('Matrix_2: ');
          readln(b);
          write('Store Result: ');
          readln(c);
          if (command = 'add') then add(a[1],b[1],c[1]);
          if (command = 'multiply') then multiply(a[1],b[1],c[1]);
     end;

     if command = 'dcmp' then begin
         write('Matrix: ');
         readln(a);
         write('Lower Matrix: ');
         readln(b);
         write('Upper Matrix: ');
         readln(c);
         dcmp(a[1],b[1],c[1]);
     end;
end;
begin
     clrscr;
     title;
     writeln('Welcome in the Matrix Calculator program');
     writeln;
     writeln(' - type "help" for help');
     writeln;

     repeat
           writeln;
           write('Command: ');
           readln(command);
           option(command);
     until command = 'exit';
end.
