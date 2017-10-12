/* Mini Calculator */
/* calc.y */

%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
int 	       int_val;
char *         char_val;
}

%error-verbose
%start	program
 
%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF
%token  THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE SUB ADD MULT
%token  DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET
%token  ASSIGN RETURN 
%token  <int_val> NUMBER 
%token  <char_val> IDENT 

%%

program:	/* epsilon */ 
		| func_loop func {printf("program -> func_loop func\n");}
		;

func_loop:	/* epsilon */ {printf("func_loop -> epsilon\n");} 
		| func_loop func {printf("func_loop -> func_loop func\n");}
		;

func:	        FUNCTION ident SEMICOLON param local body {printf("func -> ident SEMICOLON param local body\n");}
		;

param:          BEGIN_PARAMS declr_loop END_PARAMS {printf("param -> BEGIN_PARAMS declr_loop END_PARAMS\n");}
                ;
		
local:		BEGIN_LOCALS declr_loop END_LOCALS {printf("local -> BEGIN_LOCALS declr_loop END_LOCALS\n");}
                ;

body:		BEGIN_BODY stmt_loop stmt SEMICOLON END_BODY {printf("body -> BEGIN_BODY stmt_loop stmt SEMICOLON END_BODY\n");}
                ;

ident:		IDENT {printf("ident -> IDENT %s\n" , $1);}
		;

number:		NUMBER {printf("number -> NUMBER %d\n" , $1);}
		;

declr_loop:	/* epsilon */ {printf("declr_loop -> epsilon\n");}
		| declr_loop declr SEMICOLON {printf("declr_loop -> declr_loop declr SEMICOLON\n");}
		;

stmt_loop:	/* epsilon */ {printf("stmt_loop -> epsilon\n");}
		| stmt_loop stmt SEMICOLON {printf("stmt_loop -> stmt_loop stmt SEMICOLON\n");}
		;

declr:		comma_loop ident COLON declr2 INTEGER {printf("declr -> comma_loop ident COLON declr2 INTEGER\n");}
		;

comma_loop:	/* epsilon */ {printf("comma_loop -> epsilon\n");}
		| comma_loop ident COMMA {printf("comma_loop -> comma_loop ident COMMA\n");}
		;

declr2:		/* epsilon */ {printf("declr2 -> epsilon\n");}
		| ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF {printf("declr2 -> ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF\n");}
		;

stmt:		var ASSIGN expr {printf("stmt -> var ASSIGN expr\n");} 
		| if_stmt {printf("stmt -> if_stmt\n");} 
                | while_stmt {printf("stmt -> while_stmt\n");} 
                | do_stmt {printf("stmt -> do_stmt\n");} 
                | read_stmt {printf("stmt -> read_stmt\n");}
                | write_stmt {printf("stmt -> write_stmt\n");}
                | CONTINUE {printf("stmt -> CONTINUE\n");}
                | RETURN expr {printf("stmt -> RETURN expr\n");}
		;

if_stmt:	IF bool_expr THEN stmt_loop stmt SEMICOLON else_stmt ENDIF {printf("if_stmt -> IF bool_expr THEN stmt_loop stmt SEMICOLON else_stmt ENDIF\n");}
		;

else_stmt:	/* epsilon */ {printf("else_stmt -> epsilon\n");}
		| ELSE stmt_loop stmt SEMICOLON { printf("else_stmt -> ELSE stmt_loop stmt SEMICOLON\n");}
		;

while_stmt:	WHILE bool_expr BEGINLOOP stmt_loop stmt SEMICOLON ENDLOOP {printf("while_stmt -> WHILE bool_expr BEGINLOOP stmt_loop stmt SEMICOLON ENDLOOP\n");}
		;

do_stmt:	DO BEGINLOOP stmt_loop stmt SEMICOLON ENDLOOP WHILE bool_expr {printf("do_stmt -> DO BEGINLOOP stmt_loop stmt SEMICOLON ENDLOOP WHILE bool_expr\n");}
		;

read_stmt:	READ var_loop var {printf("read_stmt -> READ var_loop var\n");}
		;

write_stmt:	WRITE var_loop var {printf("write_stmt -> WRITE var_loop var\n");}
		;

var_loop:	/* epsilon */ {printf("var_loop -> epsilon\n");}
		| var_loop var COMMA {printf("var_loop -> var_loop var COMMA\n");}
		;

bool_expr:      rae_loop rae {printf("bool_expr -> rae_loop rae\n");}	
		;

rae:		re_loop re {printf("rae -> re_loop re\n");}
		;

rae_loop:	/* epsilon */ {printf("rae_loop -> epsilon\n");}
		| rae_loop rae OR {printf("rae_loop -> rae_loop rae OR\n");}
		;

re_loop:	/* epsilon */ {printf("re_loop -> epsilon\n");}
		| re_loop re AND {printf("re_loop -> re_loop re AND\n");}
		;

re:		not re2 {printf("re -> not re2\n");}
		;

not:		/* epsilon */ {printf("not -> epsilon\n");}
		| NOT {printf("not -> NOT\n");}
		;

re2:		expr comp expr {printf("re2 -> expr comp expr\n");}
		| TRUE {printf("re2 -> TRUE\n");}
		| FALSE {printf("re2 -> FALSE\n");}
		| L_PAREN bool_expr R_PAREN {printf("re2 -> L_PAREN bool_expr R_PAREN\n");}
		;

comp:		EQ {printf("comp -> EQ\n");}
		| NEQ {printf("comp -> NEQ\n");}
		| LT {printf("comp -> LT\n");} 
		| GT {printf("comp -> GT\n");}
		| LTE {printf("comp -> LTE\n");}
		| GTE {printf("comp -> GTE\n");}
		;

expr:		me_loop me {printf("expr -> me_loop me\n");}
		;

me_loop:	/* epsilon */ {printf("me_loop -> epsilon\n");}
		| me_loop me ADD {printf("me_loop -> me_loop me ADD\n");}
		| me_loop me SUB {printf("me_loop -> me_loop me SUB\n");}
		;

me:		term_loop term {printf("me -> term_loop term\n");}
		;

term_loop:	/* epsilon */ {printf("term_loop -> epsilon\n");}
		| term_loop term MULT {printf("term_loop -> term_loop term MULT\n");}
		| term_loop term DIV {printf("term_loop -> term_loop term DIV\n");}
		| term_loop term MOD {printf("term_loop -> term_loop term MOD\n");}
		;

term:	        SUB var {printf("term -> SUB var\n");} 
	        | var {printf("term -> var\n");} 
	        | neg number {printf("term -> neg number\n");} 
	        | neg L_PAREN expr R_PAREN {printf("term -> neg L_PAREN expr R_PAREN\n");} 
		| term2 {printf("term -> term2\n");}
		;

term2:		ident L_PAREN expr_loop R_PAREN {printf("term -> ident L_PAREN expr_loop R_PAREN\n");}
		;

neg:		/* epsilon */ {printf("neg -> epsilon\n");}
		| SUB {printf("neg -> SUB\n");}
		;

expr_loop:	/* epsilon */ {printf("expr_loop -> epsilon\n");}
		| expr_loop2 expr {printf("expr_loop -> L_PAREN expr_loop expr R_PAREN\n");}
		;

expr_loop2:	/* epsilon */
		| expr_loop2 expr COMMA {printf("expr_loop2 -> expr_loop2 expr COMMA\n");}
		;

var:	        ident {printf("var -> ident\n");}
		| ident L_SQUARE_BRACKET expr R_SQUARE_BRACKET {printf("var -> ident L_SQUARE_BRACKET expr R_SQUARE_BRACKET\n");}
		;
%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}








