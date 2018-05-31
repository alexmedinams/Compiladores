%{
#include <stdio.h>
#include <math.h>
#include "op_cadenas.h"
#include "lista.h"
int yylex(void);
void yyerror(char *);
lista ts;
%}

/* Declaraciones de BISON */

%union{  /* especifica la colección completa de tipo de datos posibles */
  int entero;
  double flotante;
  char* str;
  /*Valor* valor;*/
}

%token <entero> ENTERO /* terminal, define el token y su tipo */
%token <flotante> REAL
%token <str> CADENA
%token <str> ID
%token POW
%token INT
%token DOUBLE
%token STRING
%type <entero> exp_e /* no terminal */
%type <flotante> exp_f
%type <str> exp_c

%left '='
%left '+''-'
%left '*''/'

/* Gramática */
%%

input:    /* cadena vacía */
        | input line
;

line:     '\n'
        | exp_e '\n' { printf("\tresultado: %d\n", $1); }
        | exp_f '\n' { printf("\tresultado: %.2f\n", $1); }
        | exp_c '\n' { printf("\tresultado: %s\n", $1); }
        | decl '\n'
;

exp_e:  ENTERO { $$ = $1; }
        | '-' ENTERO { $$ = ($2)*(-1); }
        | exp_e '+' exp_e { $$ = $1 + $3; }
        | exp_e '-' exp_e { $$ = $1 - $3; }
        | exp_e '*' exp_e { $$ = $1 * $3; }
        | exp_e '/' exp_e { $$ = $1 / $3; }
        | POW '(' exp_e ',' exp_e ')' ';' { $$ = pow($3,$5); }
;

exp_f:  REAL { $$ = $1; }
        | exp_f '+' exp_f { $$ = $1 + $3; }
        | exp_f '-' exp_f { $$ = $1 - $3; }
        | exp_f '*' exp_f { $$ = $1 * $3; }
        | exp_f '/' exp_f { $$ = $1 / $3; }
        | exp_e '+' exp_f { $$ = $1 + $3; }
        | exp_e '-' exp_f { $$ = $1 - $3; }
        | exp_e '*' exp_f { $$ = $1 * $3; }
        | exp_e '/' exp_f { $$ = $1 / $3; }
        | exp_f '+' exp_e { $$ = $1 + $3; }
        | exp_f '-' exp_e { $$ = $1 - $3; }
        | exp_f '*' exp_e { $$ = $1 * $3; }
        | exp_f '/' exp_e { $$ = $1 / $3; }
;

exp_c:  CADENA  { $$ = $1; }
      | exp_c '+' exp_c {
                          printf( "%s\n", $3);
                          char* aux;
                          aux = concatenar($1, $3);
                          $$ = aux;
                        }
;


decl: INT ID ';' {  elemento e;
                    char * aux;
                    aux = $2;
                    e.name = aux;
                    e.tipo = 1;
                    if(Buscar(&ts, e)){
                      printf("\n--->ERROR! Ya ha sido declarada %s con int\n", e.name);
                    }
                    else{
                      Insert(&ts, e);
                      printf("\nSe agregó correctamente\n");
                    }

                    ImprimeTS(&ts);

                  }
    | INT ID '=' exp_e ';' {  elemento e;
                              e.name = $2;
                              e.tipo = 1;
                              e.valor.valor1 = $4;
                              if(Buscar(&ts, e)){
                                printf("\n--->ERROR! Ya ha sido declarada %s con int\n", e.name);
                              }
                              else{
                                Insert(&ts, e);
                                printf("\nSe agregó correctamente\n");
                              }
                              ImprimeTS(&ts);
                            }
    | DOUBLE ID ';' {
                      elemento e;
                      e.name = $2;
                      e.tipo = 2;

                      if(Buscar(&ts, e)){
                        printf("\n--->ERROR! Ya ha sido declarada %s con double\n", e.name);
                      }
                      else{
                        Insert(&ts, e);
                        printf("\nSe agregó correctamente\n");
                      }
                      ImprimeTS(&ts);
                    }
    | DOUBLE ID '=' exp_f ';' { elemento e;
                                e.name = $2;
                                e.tipo = 2;
                                e.valor.valor2 = $4;
                                if(Buscar(&ts, e)){
                                  printf("\n--->ERROR! Ya ha sido declarada %s con double\n", e.name);
                                }
                                else{
                                  Insert(&ts, e);
                                  printf("\nSe agregó correctamente\n");
                                }
                                ImprimeTS(&ts);
                              }
   | STRING ID '=' exp_c ';' { elemento e;
                                e.name = $2;
                                e.tipo = 3;
                                e.valor.valor3 = $4;
                                if(Buscar(&ts, e)){
                                  printf("\n--->ERROR! Ya ha sido declarada %s con double\n", e.name);
                                }
                                else{
                                  Insert(&ts, e);
                                  printf("\nSe agregó correctamente\n");
                                }
                                ImprimeTS(&ts);
                              }
    | STRING ID ';' { elemento e;
                                e.name = $2;
                                e.tipo = 3;
                                if(Buscar(&ts, e)){
                                  printf("\n--->ERROR! Ya ha sido declarada %s con double\n", e.name);
                                }
                                else{
                                  Insert(&ts, e);
                                  printf("\nSe agregó correctamente\n");
                                }
                                ImprimeTS(&ts);
                              }

;


/* expvar, expdec, exptipo */

%%

int main(){
  Initialize(&ts);
  yyparse();
  Destroy(&ts);
  ImprimeTS(&ts);
  return 0;
}

void yyerror(char *s){
  printf("--%s--\n", s);
}

int yywrap(){
  return 1;
}
