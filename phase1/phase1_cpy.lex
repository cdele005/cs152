%{
   int currLine = 1, currPos = 1;
   int i = 0;
   char id[20];
   int id_start = 0;
%}

DIGIT    [0-9]
LETTER [a-zA-Z]
WSPACE [ \t]
SEMICOLON [;]
COLON [:]
COMMA [,]
L_PAREN [(]
R_PAREN [)]
L_SQUARE_BRACKET [[]
R_SQUARE_BRACKET []]
ASSIGN (":=")
IDENT {LETTER}({LETTER}|{DIGIT}|[_])*
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
COMPARE ({LT}|{GT}|{LTE}|{GTE}|{EQ})
OPERATE ({SUB}|{ADD}|{MULT}|{DIV}|{MOD})
EXPRESS ({IDENT}|{DIGIT}+){WSPACE}*{OPERATE}{WSPACE}*({IDENT}|{DIGIT}+)
LOGIC ({AND}|{OR}) 
BOOL  ({TRUE}|{FALSE})
LEXPR	({L_PAREN}{WSPACE}*)*({DIGIT}+|{IDENT}){WSPACE}*({OPERATE}{WSPACE}*(({DIGIT}+{R_PAREN}*{WSPACE}*)|({IDENT}{WSPACE}*{R_PAREN}*{WSPACE}*)|(({L_PAREN}{WSPACE}*)*({DIGIT}+|{IDENT}|({R_PAREN}))){WSPACE}*))*{R_PAREN}*

%%

{FUNCTION}{WSPACE}+{IDENT}{WSPACE}*{SEMICOLON}           {printf("FUNCTION\nIDENT ");
							  for(i = 8; i < yyleng; i++){
							   if(yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
								id[0] = yytext[i]; printf("%s", id);}}
							  printf("\nSEMICOLON\n");}
{BEGIN_PARAMS}		{printf("BEGIN_PARAMS\n");}
{END_PARAMS}		{printf("END_PARAMS\n");}
{BEGIN_LOCALS}           {printf("BEGIN_LOCALS\n");}
{END_LOCALS}             {printf("END_LOCALS\n");}
{IDENT}{WSPACE}*{COLON}{WSPACE}*{INTEGER}{SEMICOLON}	   {printf("IDENT ");
							   for(i = 0; i < yyleng; i++){
							   if(yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
								id[0] = yytext[i]; printf("%s", id);}
							   else if (yytext[i] == ':'){
								i = yyleng;}}
							     printf("\nCOLON\nINTEGER\nSEMICOLON\n");}
{IDENT}{WSPACE}*({COMMA}{WSPACE}*{IDENT})+{WSPACE}*{COLON}{WSPACE}*{INTEGER}{SEMICOLON}	    {printf("IDENT ");
												for(i = 0; i < yyleng; i++){
							   					if(yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
												id[0] = yytext[i]; printf("%s", id);}
												else if (yytext[i] == ','){
												printf("\nCOMMA\nIDENT ");}
												else if (yytext[i] == ':'){
												i = yyleng;}}
												printf("\nCOLON\nINTEGER\nSEMICOLON\n");}
{IDENT}{WSPACE}*{COLON}{WSPACE}*{ARRAY}{WSPACE}*{L_SQUARE_BRACKET}{DIGIT}+{R_SQUARE_BRACKET}{WSPACE}{OF}{WSPACE}{INTEGER}{SEMICOLON} 	{printf("IDENT ");
																for(i = 0; i < yyleng; i++){
							   									if(yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
																id[0] = yytext[i]; printf("%s", id);}
																else if (yytext[i] == ':'){
																i = yyleng;}}
																  printf("\nCOLON\nARRAY\nL_SQUARE_BRACKET\nNUMBER ");
																	for(i = 0; i < yyleng; i++){
							   										if(yytext[i] >= '0' && yytext[i] <= '9'){
																	id[0] = yytext[i]; printf("%s", id);}} 
																printf("\nR_SQUARE_BRACKET\nOF\nINTEGER\nSEMICOLON\n");}
{BEGIN_BODY}		{printf("BEGIN_BODY\n");}
{END_BODY}		{printf("END_BODY\n");}
{DO}			{printf("DO\n");}
{READ}{WSPACE}+{IDENT}({COMMA}{WSPACE}*{IDENT})*{WSPACE}*{SEMICOLON}	{printf("READ\nIDENT ");
					for(i = 4; i < yyleng; i++){
					if(yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
					id[0] = yytext[i]; printf("%s", id);}
					else if (yytext[i] == ','){
					printf("\nCOMMA\nIDENT ");}
					}		
					printf("\nSEMICOLON\n");}
{IDENT}{WSPACE}*{ASSIGN}{WSPACE}*({DIGIT}+|{LEXPR}|{IDENT}){WSPACE}*{SEMICOLON}	{
                                                        id_start = 0;
							for(i = 0; i < yyleng; i++){
							if (yytext[i] == ';') {printf("\nSEMICOLON\n");}
							else if(yytext[i] == '*'){if(id_start == 1){printf("\n");}printf("MULT\n"); id_start = 0;}
							else if(yytext[i] == ':' && yytext[i+1] == '='){i++ ;id_start = 0; printf("ASSIGN\n"); }
							else if(yytext[i] == '-'){if(id_start == 1){printf("\n");}printf("SUB\n"); id_start = 0;}
							else if(yytext[i] == '+'){if(id_start == 1){printf("\n");}printf("ADD\n"); id_start = 0;}
							else if(yytext[i] == '/'){if(id_start == 1){printf("\n");}printf("DIV\n"); id_start = 0;}
							else if(yytext[i] == '%'){if(id_start == 1){printf("\n");}printf("MOD\n"); id_start = 0;}
							else if(yytext[i] == ')'){if(id_start == 1){printf("\n");}printf("R_PAREN\n"); id_start = 0;}
							else if(yytext[i] == '('){printf("L_PAREN\n"); id_start = 0;}
							else if(yytext[i] == ' '){if(id_start == 1){printf("\n");}id_start = 0;}

							else {
											if (id_start == 0) {
                                                                                           id[0] = yytext[i];
                                                                                           if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                              printf("NUMBER %s", id);
											      id_start = 1;
        										   }
                                                                                           else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
         										      printf("IDENT %s", id);
                                                                                              id_start = 1;
                                                                                           }
	                                                                             }
											else {
                                                                                           id[0] = yytext[i];
                                                                                        if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                              printf("%s", id);
											      id_start = 1;
        										   }
                                                                                           else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
         										      printf("%s", id);
                                                                                              id_start = 1;
                                                                                           }

											}
										     }
    							}
							}
{IDENT}({L_SQUARE_BRACKET}({IDENT}|{DIGIT}+|{EXPRESS}){R_SQUARE_BRACKET})*{WSPACE}*{ASSIGN}{WSPACE}*({DIGIT}+|{IDENT}|{EXPRESS}|({IDENT}({L_SQUARE_BRACKET}({IDENT}|{DIGIT}+|{EXPRESS}){R_SQUARE_BRACKET}))){WSPACE}*{SEMICOLON}	{
                                                        id_start = 0;
                                                                               for (i = 0; i < yyleng; i++) {
                                                                                if (yytext[i] == '[') {printf("\nL_SQUARE_BRACKET\n"); id_start = 0;} 
                                                                                else if (yytext[i] == ']') {printf("\nR_SQUARE_BRACKET"); id_start = 0;} 
                                                                                else if (yytext[i] == ':' && yytext[i+1] == '=') {printf("\nASSIGN\n"); id_start = 0;i++;} 
                                                                                else if (yytext[i] == ';') {printf("\nSEMICOLON\n"); id_start = 0;}
											 else if(yytext[i] == '/'){printf("\nDIV\n"); id_start = 0;}
							   else if(yytext[i] == '*'){printf("\nMULT\n"); id_start = 0;}
							   else if(yytext[i] == '-'){printf("\nSUB\n"); id_start = 0;}
							   else if(yytext[i] == '+'){printf("\nADD\n");id_start = 0;}
							   else if(yytext[i] == '%'){printf("\nMOD\n"); id_start = 0;}
 
										else {
											if (id_start == 0) {
                                                                                           id[0] = yytext[i];
                                                                                           if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                              printf("NUMBER %s", id);
											      id_start = 1;
        										   }
                                                                                           else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
         										      printf("IDENT %s", id);
                                                                                              id_start = 1;
                                                                                           }
	                                                                             }
											else {
                                                                                        if (yytext[i] >= '0' && yytext[i] <= '9'){
                    								              id[0] = yytext[i];
                                                                                              printf("%s", id);
											      id_start = 1;
        										   }
                                                                                           else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
                    								              id[0] = yytext[i];
         										      printf("%s", id);
                                                                                              id_start = 1;
                                                                                           }

											}
										     }
                                                                               }

}

{BEGINLOOP}	{printf("BEGINLOOP\n");}
{WHILE}{WSPACE}+({IDENT}|{EXPRESS}){WSPACE}*{COMPARE}{WSPACE}*({IDENT}|{DIGIT}+|{EXPRESS}){WSPACE}*{SEMICOLON} {  printf("WHILE\n");
                                                                               id_start = 0;
                                                                               for (i = 5; i < yyleng; i++) {
                                                                                if(yytext[i] == '<' && yytext[i+1] == '='){printf("\nLTE\n");i++; id_start = 0;}
										else if(yytext[i] == '>' && yytext[i+1] == '='){printf("\nGTE\n");i++; id_start = 0;}
										else if(yytext[i] == '=' && yytext[i+1] == '='){printf("\nEQ\n");i++; id_start = 0;}
                                                                                else if (yytext[i] == '>') {printf("\nGT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '<') {printf("\nLT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == ' ') {id_start = 0;} 
                                                                                else if (yytext[i] == '/') {printf("\nDIV\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '*') {printf("\nMULT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '-') {printf("\nSUB\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '+') {printf("\nADD\n"); id_start = 0;}
										else if(yytext[i] == '%'){printf("\nMOD\n"); id_start = 0;}

										else {
										if (id_start == 0) {
                                                                                    id[0] = yytext[i]; 
                                                                                    if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                    printf("NUMBER %s", id);
										      id_start = 1;
        							   }
                                                                                else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
        									      printf("IDENT %s", id);
                                                                                    id_start = 1;
                                                                                  }
	                                                                          }  
										else {
                                                                                 id[0] = yytext[i];  
                                                                                 if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                printf("%s", id);
									      id_start = 1;
        									   }
                                                                                  else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
         									      printf("%s", id);
                                                                                             id_start = 1;
                                                                                           }

										     }
                                                                               }
                                                                           }
										printf("\nSEMICOLON\n");
										}

{WHILE}{WSPACE}+{IDENT}{WSPACE}*{COMPARE}{WSPACE}*({EXPRESS}|{IDENT}|{DIGIT}+){WSPACE}+({LOGIC}{WSPACE}+({EXPRESS}|{DIGIT}+|{IDENT}|{BOOL}))* {
                                                                               printf("WHILE\n");
                                                                               id_start = 0;
                                                                               for (i = 5; i < yyleng; i++) {
                                                                                if(yytext[i] == '<' && yytext[i+1] == '='){printf("\nLTE\n");i++; id_start = 0;}
										else if(yytext[i] == '>' && yytext[i+1] == '='){printf("\nGTE\n");i++; id_start = 0;}
										else if(yytext[i] == 'o' && yytext[i+1] == 'r'){printf("\nOR\n");i++; id_start = 0;}
										else if(yytext[i] == 'f' && yytext[i+1] == 'a' && yytext[i+2] == 'l' && yytext[i+3] == 's' && yytext[i+4] == 'e'){printf("FALSE\n");i+=4; id_start = 0;}
										else if(yytext[i] == '=' && yytext[i+1] == '='){printf("\nEQ\n");i++; id_start = 0;}
                                                                                else if (yytext[i] == '>') {printf("\nGT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '<') {printf("\nLT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == ' ') {id_start = 0;} 
                                                                                else if (yytext[i] == '/') {printf("\nDIV\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '*') {printf("\nMULT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '-') {printf("\nSUB\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '+') {printf("\nADD\n"); id_start = 0;}
										else if(yytext[i] == '%'){printf("\nMOD\n"); id_start = 0;}

										else {
										if (id_start == 0) {
                                                                                    id[0] = yytext[i]; 
                                                                                    if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                    printf("NUMBER %s", id);
										      id_start = 1;
        							   }
                                                                                else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
        									      printf("IDENT %s", id);
                                                                                    id_start = 1;
                                                                                  }
	                                                                          }  
										else {
                                                                                 id[0] = yytext[i];
                                                                                 if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                printf("%s", id);
									      id_start = 1;
        									   }
                                                                                  else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
         									      printf("%s", id);
                                                                                             id_start = 1;
                                                                                           }

										     }
                                                                                 if (i >= yyleng - 2){printf("\n"); id_start = 0;}
                                                                               }
                                                                           }}
{CONTINUE}{SEMICOLON}	{printf("CONTINUE\nSEMICOLON\n");}
{IF}{WSPACE}+({IDENT}|{EXPRESS}){WSPACE}*({L_SQUARE_BRACKET}({IDENT}|{DIGIT}+){R_SQUARE_BRACKET})*{WSPACE}*{COMPARE}{WSPACE}*({EXPRESS}|{IDENT}|{DIGIT}+){WSPACE}+({LOGIC}{WSPACE}+({IDENT}|{EXPRESS}){WSPACE}*({L_SQUARE_BRACKET}({IDENT}|{DIGIT}+){R_SQUARE_BRACKET})*{WSPACE}*{COMPARE}{WSPACE}*({EXPRESS}|{IDENT}|{DIGIT}+){WSPACE}+)*{THEN} {
                                                                               printf("IF\n");
                                                                               id_start = 0;
                                                                               for (i = 2; i < yyleng - 4; i++) {
                                                                                if(yytext[i] == '<' && yytext[i+1] == '='){printf("\nLTE\n");i++; id_start = 0;}
										else if(yytext[i] == 'a' && yytext[i+1] == 'n' && yytext[i+2] == 'd'){printf("\nAND\n"); i=i+2; id_start = 0;}
										else if(yytext[i] == 'o' && yytext[i+1] == 'r'){printf("\nOR\n");i++; id_start = 0;}
										else if(yytext[i] == '>' && yytext[i+1] == '='){printf("\nGTE\n");i++; id_start = 0;}
										else if(yytext[i] == '=' && yytext[i+1] == '='){printf("\nEQ\n");i++; id_start = 0;}
                                                                                else if (yytext[i] == '>') {printf("\nGT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '<') {printf("\nLT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == ' ') {id_start = 0;} 
                                                                                else if (yytext[i] == '/') {printf("\nDIV\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '*') {printf("\nMULT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '-') {printf("\nSUB\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '+') {printf("\nADD\n"); id_start = 0;}
										else if(yytext[i] == '%'){printf("\nMOD\n"); id_start = 0;}

										else if (yytext[i] == '[') {printf("\nL_SQUARE_BRACKET\n"); id_start = 0;}
										else if (yytext[i] == ']') {printf("\nR_SQUARE_BRACKET"); id_start = 0;}
										else {
											if (id_start == 0) {
                                                                                    id[0] = yytext[i]; 
                                                                                    if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                    printf("NUMBER %s", id);
										      id_start = 1;
        							   }
                                                                                else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
        									      printf("IDENT %s", id);
                                                                                    id_start = 1;
                                                                                  }
	                                                                             }
										else {
                                                                                 id[0] = yytext[i];
                                                                                 if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                printf("%s", id);
									      id_start = 1;
        									   }
                                                                                  else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
         									      printf("%s", id);
                                                                                             id_start = 1;
                                                                                           }


											}
										     }
                                                                               }
										printf("\nTHEN\n");
                                                                            }

{ENDLOOP}{SEMICOLON}		{printf("ENDLOOP\nSEMICOLON\n");}
{ENDIF}{SEMICOLON}		{printf("ENDIF\nSEMICOLON\n");}
{ELSE}				{printf("ELSE\n");}
{WRITE}{WSPACE}+({COMMA}*{WSPACE}*({IDENT}|{DIGIT}+){WSPACE}*({L_SQUARE_BRACKET}({IDENT}|{DIGIT}+|{EXPRESS}){R_SQUARE_BRACKET})*)*{SEMICOLON}                             {printf("WRITE\n");
											id_start = 0;
											for (i = 5; i < yyleng; i++){
										if (yytext[i] == '[') {printf("\nL_SQUARE_BRACKET\n"); id_start = 0;}
										else if (yytext[i] == ']') {printf("\nR_SQUARE_BRACKET"); id_start = 0;}
									 	 else if (yytext[i] == ' ') {id_start = 0;} 
                                                                                else if (yytext[i] == '/') {printf("\nDIV\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '*') {printf("\nMULT\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '-') {printf("\nSUB\n"); id_start = 0;} 
                                                                                else if (yytext[i] == '+') {printf("\nADD\n"); id_start = 0;}
                                                                                else if (yytext[i] == ',') {printf("\nCOMMA\n"); id_start = 0;}
										else if(yytext[i] == '%'){printf("\nMOD\n"); id_start = 0;}


										if (id_start == 0) {
                                                                                    id[0] = yytext[i]; 
                                                                                    if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                    printf("NUMBER %s", id);
										      id_start = 1;
        							   }
                                                                                else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
        									      printf("IDENT %s", id);
                                                                                    id_start = 1;
                                                                                  }
	                                                                             }
										else {
										id[0] = yytext[i];
                                                                                 if (yytext[i] >= '0' && yytext[i] <= '9'){
                                                                                printf("%s", id);
									      id_start = 1;
        									   }
                                                                                  else if (yytext[i] >= 'a' && yytext[i] <= 'z' || yytext[i] == '_'){
         									      printf("%s", id);
                                                                                             id_start = 1;
                                                                                           }
										}}
									 printf("\nSEMICOLON\n");}
{COMMENT}		{}

[ \t]+         {/* ignore spaces */ currPos += yyleng;}

"\n"           {currLine++; currPos = 1;}

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

