%{
   int currLine = 1, currPos = 1;
%}

DIGIT    [0-9]
LETTER [a-zA-Z]
U_SCORE [_]
IDENT ({LETTER}|{DIGIT}|{U_SCORE})*
ERROR1 ({U_SCORE}|{DIGIT}){IDENT} 
ERROR2 {IDENT}{U_SCORE}
NUMBER {DIGIT}*
SEMICOLON [;]
ENDLINE [\n]
COLON [:]
COMMA [,]
L_PAREN [(]
R_PAREN [)]
L_SQUARE_BRACKET [[]
R_SQUARE_BRACKET []]
ASSIGN (":=")
FUNCTION ("function")
BEGIN_PARAMS ("beginparams")
END_PARAMS ("endparams")
BEGIN_LOCALS ("beginlocals")
END_LOCALS ("endlocals")
BEGIN_BODY ("beginbody")
END_BODY ("endbody")
INTEGER ("integer")
ARRAY ("array")
OF ("of")
IF ("if")
THEN ("then")
ENDIF ("endif")
ELSE ("else")
WHILE ("while")
DO ("do")
BEGINLOOP ("beginloop")
ENDLOOP ("endloop")
CONTINUE ("continue")
READ ("read")
WRITE ("write")
AND ("and")
OR ("or")
NOT ("not")
TRUE ("true")
FALSE ("false")
SUB [-]
ADD [+]
MULT [*]
DIV [/]
MOD [%]
EQ ("==")
NEQ ("<>")
LT [<]
GT [>]
LTE ("<=")
GTE (">=")
COMMENT ("##").*

%%

{FUNCTION}		{printf("FUNCTION\n");currPos += yyleng;}
{BEGIN_PARAMS}		{printf("BEGIN_PARAMS\n");currPos += yyleng;}
{END_PARAMS}		{printf("END_PARAMS\n");currPos += yyleng;}
{BEGIN_LOCALS}           {printf("BEGIN_LOCALS\n");currPos += yyleng;}
{END_LOCALS}             {printf("END_LOCALS\n");currPos += yyleng;}
{BEGIN_BODY}             {printf("BEGIN_BODY\n");currPos += yyleng;}
{END_BODY}             {printf("END_BODY\n");currPos += yyleng;}
{INTEGER}             {printf("INTEGER\n");currPos += yyleng;}
{ARRAY}             {printf("ARRAY\n");currPos += yyleng;}
{OF}             {printf("OF\n");currPos += yyleng;}
{IF}             {printf("IF\n");currPos += yyleng;}
{THEN}             {printf("THEN\n");currPos += yyleng;}
{ENDIF}             {printf("ENDIF\n");currPos += yyleng;}
{ELSE}             {printf("ELSE\n");currPos += yyleng;}
{WHILE}             {printf("WHILE\n");currPos += yyleng;}
{DO}             {printf("DO\n");currPos += yyleng;}
{BEGINLOOP}             {printf("BEGINLOOP\n");currPos += yyleng;}
{ENDLOOP}             {printf("ENDLOOP\n");currPos += yyleng;}
{CONTINUE}             {printf("CONTINUE\n");currPos += yyleng;}
{READ}             {printf("READ\n");currPos += yyleng;}
{WRITE}             {printf("WRITE\n");currPos += yyleng;}
{AND}             {printf("AND\n");currPos += yyleng;}
{OR}             {printf("OR\n");currPos += yyleng;}
{NOT}             {printf("NOT\n");currPos += yyleng;}
{TRUE}             {printf("TRUE\n");currPos += yyleng;}
{FALSE}             {printf("FALSE\n");currPos += yyleng;}
{SUB}             {printf("SUB\n");currPos += yyleng;}
{ADD}             {printf("ADD\n");currPos += yyleng;}
{MULT}             {printf("MULT\n");currPos += yyleng;}
{DIV}             {printf("DIV\n");currPos += yyleng;}
{MOD}             {printf("MOD\n");currPos += yyleng;}
{EQ}             {printf("EQ\n");currPos += yyleng;}
{NEQ}             {printf("NEQ\n");currPos += yyleng;}
{LT}             {printf("LT\n");currPos += yyleng;}
{GT}             {printf("GT\n");currPos += yyleng;}
{LTE}             {printf("LTE\n");currPos += yyleng;}
{GTE}             {printf("GTE\n");currPos += yyleng;}
{SEMICOLON}             {printf("SEMICOLON\n");currPos += yyleng;}
{COLON}             {printf("COLON\n");currPos += yyleng;}
{COMMA}             {printf("COMMA\n");currPos += yyleng;}
{L_PAREN}             {printf("L_PAREN\n");currPos += yyleng;}
{R_PAREN}             {printf("R_PAREN\n");currPos += yyleng;}
{L_SQUARE_BRACKET}             {printf("L_SQUARE_BRACKET\n");currPos += yyleng;}
{R_SQUARE_BRACKET}             {printf("R_SQUARE_BRACKET\n");currPos += yyleng;}
{ASSIGN}             {printf("ASSIGN\n");currPos += yyleng;}

{COMMENT}		{/* ignore comments */}
{NUMBER}          {printf("NUMBER %s\n", yytext); currPos += yyleng;}
{ERROR1}                {printf("Error at line %d, column %d: identifier \"%s\" must start with a letter\n", currLine, currPos, yytext); exit(0);}
{ERROR2}                {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}
{IDENT}                 {printf("IDENT %s\n", yytext); currPos += yyleng;}

[ \t]+         {/* ignore spaces */ currPos += yyleng;}

{ENDLINE}           {currLine++; currPos = 1;}

.              {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%

int main(int argc, char ** argv)
{
   if(argc >= 2)
   {
      yyin = fopen(argv[1], "r");
      if(yyin == NULL)
      {
         yyin = stdin;
      }
   }
   else
   {
      yyin = stdin;
   }
   
   yylex();
   
}

