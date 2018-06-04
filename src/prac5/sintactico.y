%{
#include <stdio.h>
#include <math.h>
#include <string.h>
#include "op_cadenas.h"
#include "lista.h"
int yylex(void);
void yyerror(char *);
lista ts;
%}

/* Declaraciones de BISON */

%union{  /* especifica la colección completa de tipo de datos pibles */
  int entero;
  double flotante;
  char* str;
  /*Valor* valor;*/
}

%token <entero> ENTERO /* terminal, define el token y su tipo */
%token <flotante> REAL
%token <str> CADENA
%token <str> ID TIPO
%token POW
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
        | asig '\n'
;

exp_e:  ENTERO { $$ = $1; printf("%d\n", $1); }
        | '-' ENTERO { $$ = ($2)*(-1); }
        | exp_e '+' exp_e { $$ = $1 + $3; }
        | exp_e '-' exp_e { $$ = $1 - $3; }
        | exp_e '*' exp_e { $$ = $1 * $3; }
        | exp_e '/' exp_e { $$ = $1 / $3; }
        | POW '(' exp_e ',' exp_e ')' ';' { $$ = pow($3,$5); }
;

exp_f:  REAL { $$ = $1; printf("%f\n", $1); }
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

exp_c:  CADENA  { $$ = $1; printf("%s\n", $1)  }
      | exp_c '+' exp_c {
                          printf( "%s\n", $3);
                          char* aux;
                          aux = concatenar($1, $3);
                          $$ = aux;
                        }
;


decl:  TIPO ' ' ID ';' {
                      elemento e;
                      int tipo;

                      if(!strcmp($1, "int")){
                        tipo = 1;
                      }
                      else if(!strcmp($1, "double")){
                        tipo = 2;
                      }
                      else if(!strcmp($1, "string")){
                        tipo = 3;
                      }

                      e.name = $3;
                      e.tipo = tipo;

                      if(Buscar(&ts, e)){
                        printf("\n\t-->ERROR! ya ha sido declarada previamente %s\n", $3);
                      }
                      else{
                        Insert(&ts, e);
                        printf("\n\t Se agregó correctamente\n");
                      }
                      ImprimeTS(&ts);
                    }

        | TIPO ' ' ID '=' exp_e ';'   {
                                        elemento e;

                                        if(!strcmp($1, "int")){
                                          e.name = $3;
                                          e.tipo = 1;
                                          e.valor.valor1 = $5;
                                          if(Buscar(&ts, e)){
                                            printf("\n\t-->ERROR! ya ha sido declarada previamente %s\n", $3);
                                          }
                                          else{
                                            Insert(&ts, e);
                                            printf("\n\t Se agregó correctamente\n");
                                          }
                                          ImprimeTS(&ts);
                                        }
                                        else if(!strcmp($1, "double")){
                                          e.name = $3;
                                          e.tipo = 2;
                                          e.valor.valor2 = $5;
                                          if(Buscar(&ts, e)){
                                            printf("\n\t-->ERROR! ya ha sido declarada previamente %s\n", $3);
                                          }
                                          else{
                                            Insert(&ts, e);
                                            printf("\n\t Se agregó correctamente\n");
                                          }
                                          ImprimeTS(&ts);
                                        }
                                        else if(!strcmp($1, "string")){
                                          printf("\n\t--->ERROR! Incompatible types in assigment\n");
                                        }
                                      }

        | TIPO ' ' ID '=' exp_f ';'   {
                                        elemento e;

                                        if(!strcmp($1, "int")){
                                          e.name = $3;
                                          e.tipo = 1;
                                          e.valor.valor1 = $5;
                                          if(Buscar(&ts, e)){
                                            printf("\n\t-->ERROR! ya ha sido declarada previamente %s\n", $3);
                                          }
                                          else{
                                            Insert(&ts, e);
                                            printf("\n\t Se agregó correctamente\n");
                                          }
                                          ImprimeTS(&ts);
                                        }
                                        else if(!strcmp($1, "double")){
                                          e.name = $3;
                                          e.tipo = 2;
                                          e.valor.valor2 = $5;
                                          if(Buscar(&ts, e)){
                                            printf("\n\t-->ERROR! ya ha sido declarada previamente %s\n", $3);
                                          }
                                          else{
                                            Insert(&ts, e);
                                            printf("\n\t Se agregó correctamente\n");
                                          }
                                          ImprimeTS(&ts);
                                        }
                                        else if(!strcmp($1, "string")){
                                          printf("\n\t--->ERROR! Incompatible types in assigment\n");
                                        }
                                      }

        | TIPO ' ' ID '=' exp_c ';'   {
                                        elemento e;

                                        if(!strcmp($1, "int")){
                                          printf("\n\t--->ERROR! Incompatible types in assigment\n");
                                        }
                                        else if(!strcmp($1, "double")){
                                          printf("\n\t--->ERROR! Incompatible types in assigment\n");
                                        }
                                        else if(!strcmp($1, "string")){
                                          e.name = $3;
                                          e.tipo = 3;
                                          e.valor.valor3 = $5;
                                          if(Buscar(&ts, e)){
                                            printf("\n\t-->ERROR! ya ha sido declarada previamente %s\n", $3);
                                          }
                                          else{
                                            Insert(&ts, e);
                                            printf("\n\t Se agregó correctamente\n");
                                          }
                                          ImprimeTS(&ts);
                                        }
                                      }
                                      
asig: ID '=' exp_e ';'  {
                          elemento e;
                          posicion p;
                          elemento * e_ts;

                          e.name = $1;
                          p = Search(&ts,e);

                          if(p != NULL){
                            printf("Posicion en la que encontre el elemento %p\n", p);
                            e_ts = getElement(&ts, p);
                            printf("Elemento apuntado y guardado: %p\n", e_ts);

                            if(e_ts->tipo == 1){
                              e_ts->valor.valor1=$3;
                              printf("\n\tAsignacion correcta\n");
                            }
                            else if(e_ts->tipo == 2){
                              e_ts->valor.valor2=$3;
                              printf("\n\tAsignacion correcta\n");
                            }
                            else if(e_ts->tipo == 3){
                              printf("\n\t--->ERROR! Incompatible types in assigment\n");
                            }
                          }
                          else{
                            printf("\n\t-->ERROR! asignacion primero tiene que ser declarado %s\n", e.name);
                          }
                          ImprimeTS(&ts);
                        }

      | ID '=' exp_f ';'  {
                            elemento e;
                            posicion p;
                            elemento * e_ts;

                            e.name = $1;
                            p = Search(&ts,e);

                            if(p != NULL){
                              printf("Posicion en la que encontre el elemento %p\n", p);
                              e_ts = getElement(&ts, p);
                              printf("Elemento apuntado y guardado: %p\n", e_ts);

                              if(e_ts->tipo == 1){
                                e_ts->valor.valor1=$3;
                                printf("\n\tAsignacion correcta\n");
                              }
                              else if(e_ts->tipo == 2){
                                e_ts->valor.valor2=$3;
                                printf("\n\tAsignacion correcta\n");
                              }
                              else if(e_ts->tipo == 3){
                                printf("\n\t--->ERROR! Incompatible types in assigment\n");
                              }
                            }
                            else{
                              printf("\n\t-->ERROR! asignacion primero tiene que ser declarado %s\n", e.name);
                            }
                            ImprimeTS(&ts);
                          }
      | ID '=' exp_c ';'  {
                            elemento e;
                            posicion p;
                            elemento * e_ts;

                            e.name = $1;
                            p = Search(&ts,e);

                            if(p != NULL){
                              printf("Posicion en la que encontre el elemento %p\n", p);
                              e_ts = getElement(&ts, p);
                              printf("Elemento apuntado y guardado: %p\n", e_ts);

                              if(e_ts->tipo == 1){
                                printf("\n\t--->ERROR! Incompatible types in assigment\n");
                              }
                              else if(e_ts->tipo == 2){
                                printf("\n\t--->ERROR! Incompatible types in assigment\n");
                              }
                              else if(e_ts->tipo == 3){
                                e_ts->valor.valor3=$3;
                                printf("\n\tAsignacion correcta\n");
                              }
                            }
                            else{
                              printf("\n\t-->ERROR! asignacion primero tiene que ser declarado %s\n", e.name);
                            }
                            ImprimeTS(&ts);
                          }


;


/* expvar, expdec, exptipo exprvarIntDO */


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
