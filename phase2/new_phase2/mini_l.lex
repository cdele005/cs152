%{   
   #include "y.tab.h"
   int currLine = 1, currPos = 1;
   int numNumbers = 0;
   int numOperators = 0;
   int numParens = 0;
   int numEquals = 0;
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
RETURN ("return")
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

{FUNCTION}		    {currPos += yyleng;return FUNCTION; }
{BEGIN_PARAMS}		{currPos += yyleng;return BEGIN_PARAMS;}
{END_PARAMS}		{currPos += yyleng;return END_PARAMS;}
{BEGIN_LOCALS}      {currPos += yyleng;return BEGIN_LOCALS;}
{END_LOCALS}        {currPos += yyleng;return END_LOCALS;}
{BEGIN_BODY}        {currPos += yyleng;return BEGIN_BODY;}
{END_BODY}          {currPos += yyleng;return END_BODY;}
{INTEGER}           {currPos += yyleng;return INTEGER;}
{ARRAY}             {currPos += yyleng;return ARRAY;}
{OF}             	{currPos += yyleng;return OF;}
{IF}             	{currPos += yyleng;return IF;}
{THEN}              {currPos += yyleng;return THEN;}
{ENDIF}             {currPos += yyleng;return ENDIF;}
{ELSE}             	{currPos += yyleng;return ELSE;}
{WHILE}             {currPos += yyleng;return WHILE;}
{DO}             	{currPos += yyleng;return DO;}
{BEGINLOOP}         {currPos += yyleng;return BEGINLOOP;}
{ENDLOOP}           {currPos += yyleng;return ENDLOOP;}
{CONTINUE}          {currPos += yyleng;return CONTINUE;}
{READ}              {currPos += yyleng;return READ;}
{WRITE}             {currPos += yyleng;return WRITE;}
{AND}               {currPos += yyleng;return AND;}
{OR}             	{currPos += yyleng;return OR;}
{NOT}             	{currPos += yyleng;return NOT;}
{TRUE}              {currPos += yyleng;return TRUE;}
{FALSE}             {currPos += yyleng;return FALSE;}
{SUB}               {currPos += yyleng;return SUB;}
{ADD}               {currPos += yyleng;return ADD;}
{MULT}              {currPos += yyleng;return MULT;}
{DIV}               {currPos += yyleng;return DIV;}
{MOD}               {currPos += yyleng;return MOD;}
{EQ}             	{currPos += yyleng;return EQ;}
{NEQ}               {currPos += yyleng;return NEQ;}
{LT}             	{currPos += yyleng;return LT;}
{GT}             	{currPos += yyleng;return GT;}
{LTE}               {currPos += yyleng;return LTE;}
{GTE}             	{currPos += yyleng;return GTE;}
{SEMICOLON}         {currPos += yyleng;return SEMICOLON;}
{COLON}             {currPos += yyleng;return COLON;}
{COMMA}             {currPos += yyleng;return COMMA;}
{L_PAREN}           {currPos += yyleng;return L_PAREN;}
{R_PAREN}           {currPos += yyleng;return R_PAREN;}
{L_SQUARE_BRACKET}  {currPos += yyleng;return L_SQUARE_BRACKET;}
{R_SQUARE_BRACKET}  {currPos += yyleng;return R_SQUARE_BRACKET;}
{ASSIGN}            {currPos += yyleng;return ASSIGN;}
{RETURN}			{currPos += yyleng;return RETURN;}

{COMMENT}			{/* ignore comments */}
{NUMBER}        	{yylval.int_val = atoi(yytext); currPos += yyleng;return NUMBER;}
{ERROR1}            {printf("Error at line %d, column %d: identifier \"%s\" must start with a letter\n", currLine, currPos, yytext); exit(0);}
{ERROR2}            {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}
{IDENT}             {yylval.char_val = yytext; currPos += yyleng; currPos += yyleng; return IDENT;}

[ \t]+         		{/* ignore spaces */ currPos += yyleng;}

{ENDLINE}           {/* ignore endline*/ currLine++; currPos = 1;}

.              		{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%

