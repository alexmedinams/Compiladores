//Librerias
#include <stdio.h>
#include <stdlib.h>
#include "op_cadenas.h"

/*
int main(){
  char* cad1 = "simon ";
  char* cad2 = "adios";
  char* concat;

  concat = concatenar(cad1, cad2);

  printf("%s\n", concat);

  return 0;
}*/

int len_cadena(char* cad){
  int i = 0;
  while(cad[i]) i++;
  return i;
}

char* concatenar(char* cad1, char* cad2){
  char* cadena;
  cadena = malloc(len_cadena(cad1)+1);
  int len_cadena1 = len_cadena(cad1);
  int len_cadena2 = len_cadena(cad2);
  int i, j;

  for(i = 0; i < len_cadena1; i++) cadena[i] = cad1[i];

  for(j = 0; j < len_cadena2; j++){
    cadena[i] = cad2[j];
    i++;
  }

  cadena[i] = '\0';

  return cadena;
}

/*
char* resta(char* cad1, char* cad2){
  char* cadena;
  len_cadena_r = len_cadena(cad1);
  int j = 0

  for(i = 0; i < len_cadena_r; i++){
    if(cad1[i] == cad2[j])
  }

  return cadena;
}*/