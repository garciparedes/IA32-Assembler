// Sergio Garcia Prado
// Oscar Fernandez Angulo

#include <stdlib.h>
#include <stdio.h>
#include <math.h> 
#include <time.h>

//para resolver este ejercicio tendremos en cuenta que e^(a+bi)= e^a*(cos b + i*sen b)	
double lista[1024][4];
	
	
double randfrom(double min, double max) {
    double range = (max - min); 
    double div = RAND_MAX / range;
    return min + (rand() / div);
}


void generaValores(){
	// Inicializamos el random
	srand ( time(NULL) );

	int i, j;
	for (i = 0; i < 1024; i++){
		for (j = 0; j < 2; j++){
			lista[i][j] = randfrom(-50, 50);
		}
	}
}


void fourierC(){

	double p, real, imaginario;
	int j, k;
	//calculamos la compuesta
	for(j = 0 ; j < 1024 ; j++){
		for(k = 0 ; k < 1024 ; k++){

			p = - (j * k) / (double) 512;
			
			real = cos(p * M_PI);
			imaginario = sin(p * M_PI);

			lista[j][2] = lista[j][2] + lista[k][0] * real - lista[k][1] * imaginario;
			lista[j][3] = lista[j][3] + lista[k][0] * imaginario + lista[k][1] * real;
		}
	}
}

void pintaLista(int n, int m, double lista[n][m]){
	int j, k;
	for(j = 0 ; j < n; j++){
		printf("%d -> ", j);
		for(k = 0; k < m; k++){

			printf("%lf  " , lista[j][k]);

		}
		printf("\n");
	}


}

void dftsse();

int main(){

	generaValores();

	printf("Calculando en C...\n");
	clock_t startC = clock();
	fourierC();
	double tiempoC=((double)clock() - startC) / CLOCKS_PER_SEC;
	printf("Tiempo transcurrido: %f", tiempoC);
	printf("\n");

	//pintaLista(1024, 4,lista);
	printf("Valores de comprobacion:\n");
	printf("%lf  " , lista[1023][2]);
	printf("%lf  " , lista[1023][3]);
	printf("%lf  " , lista[500][2]);
	printf("%lf  " , lista[500][3]);
	printf("\n");
	printf("\n");



	//vaciamos las f's de la lista
	int j, k;
	for(j = 0 ; j < 1024; j++){
		for(k = 0;k < 2; k++){

			lista[j][k+2]=0;

		}
	}



	printf("Calculando en sse...\n");
	clock_t startSse = clock();
	dftsse();
	double tiempoSse=((double)clock() - startSse) / CLOCKS_PER_SEC;
	printf("Tiempo transcurrido: %f", tiempoSse);
	printf("\n");
	//pintaLista(1024, 4,lista);
	printf("Valores de comprobacion:\n");
	printf("%lf  " , lista[1023][2]);
	printf("%lf  " , lista[1023][3]);
	printf("%lf  " , lista[500][2]);
	printf("%lf  " , lista[500][3]);
	printf("\n");
	printf("\n");

	printf("El codigo de SSE es %f",(tiempoC/tiempoSse) );
	printf(" veces mas rapido. \n");
	

	
}
