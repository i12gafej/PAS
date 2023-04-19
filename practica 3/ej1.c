/*
    mejoras: que no imprima lo posterior a error de m;
    cuando busco grupo por gid solo muesta el root
*/

#include <getopt.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <pwd.h>
#include <grp.h>
#include <string.h>
#include <ctype.h>
/*
    int stringoint 
    param string value: uid o nombre
    return: 1 si es string
            0 si es int

*/
void todos_los_grupos(){
    struct group *gr;
    while ((gr = getgrent()) != NULL) {
        printf("Nombre del grupo: %s\n", gr->gr_name);
        printf("GID: %d\n", gr->gr_gid);
        printf("Miembros secundarios:\n");

        char **member = gr->gr_mem;
        while (*member != NULL) {
            printf("    %s\n", *member);
            member++;
        }
        printf("\n");
    }

    endgrent();
}
int stringoint(char *value){
    for(int i = 0; i < strlen(value); i++){
        if(isdigit(value[i]) != 0){
            if(i == (strlen(value) - 1)){ //si no deteca y es ultima it, analiza uid
                return 0;
            }                        
        }
        else{
            return 1;       //detecta caracter, devuelve 1
                            //no detecta, sigue
        }
    }
}
void ayuda(){
    printf("Uso del programa: ejercicio1 [opciones]\nOpciones:\n");
    printf("-h, --help                              Imprimir esta ayuda\n");
    printf("-u, --user (<nombre>|<uid>)             Información sobre los usuarios\n");
    printf("-s, --active,                           Información sobre el usuario activo actual\n");
    printf("-m, --maingroup,                        Además de info de usuario, imprimir la info de su \n |--> grupo principal\n");
    printf("-g, --group (<nombre>|<gid>)            Información sobre el grupo\n");
    printf("-s, --allgroups                         Muestra info de todos los grupos del sistema\n");
}
void imprimirusuario(struct passwd *pw){
    printf("Información del usuario\nNombre: %s\n", pw->pw_name);
    printf("Login: %s\n", pw->pw_gecos);
    printf("UID: %d\n", pw->pw_uid);
    printf("Directorio home: %s\n", pw->pw_dir);
    printf("Shell: %s\n", pw->pw_shell);
    printf("GID: %d\n", pw->pw_gid);
}

void imprimirgrupo(struct group *gr){
    printf("Informacion del grupo\nNombre del grupo: %s\n", gr->gr_name);
    printf("GID: %d\n", gr->gr_gid);
    printf("Miembros secundarios: \n");
    char **member = gr->gr_mem;
    while (*member != NULL) {
        printf("    %s\n", *member);
        member++;
    }
}
int main(int argc, char** argv){
    int c;

    static struct option long_options[] = {
        {"help", no_argument, NULL, 'h'},
        {"user", required_argument, NULL, 'u'},
        {"group", required_argument, NULL, 'g'},
        {"active", no_argument, NULL, 'a'},
        {"maingroup", no_argument, NULL, 'm'},
        {"allgroups", no_argument, NULL, 's'},
        {0,0,0,0}
    };

    char *value = NULL;
    int uid, gid;
    struct passwd *pw;
    struct group *gr;
    bool uflag = false,gflag = false, aflag = false, mflag = false,sflag = false,hflag = false; 
    
    

    while((c = getopt_long(argc, argv, "u:g:amsh", long_options, NULL)) != -1){
        //printf("optind: %d, optarg: %s, optopt: %c, opterr: %d\n\n", optind, optarg, optopt, opterr);
        switch(c){
            case 'h':
                hflag = true;
            break;
            case 'u':
                value = optarg;
                uflag = true;
            break;
            case 'g':
                value = optarg;
                gflag = true;
            break;
            case 'a':
                aflag = true;
            break;
            case 'm':
                mflag = true;
            break;
            case 's':
                sflag = true;
            break;
            case '?':
                if(optopt == 'u' || optopt == 'g') // Para el caso de que 'c' no tenga el argumento
                                                                    // obligatorio.
                fprintf(stderr, "La opción %c requiere un argumento. Valor de opterr = "
                            "%d\n",
                            optopt, opterr);
                else if (isprint(optopt)) // Se mira si el caracter es imprimible
                    fprintf(stderr,"Opción desconocida \"-%c\". Valor de opterr = %d\n",
                            optopt, opterr);
                else // Caracter no imprimible o especial
                    fprintf(stderr, "Caracter `\\x%x'. Valor de opterr = %d\n",
                            optopt, opterr);
                return 1;       
            break;
            default:
                abort();
        }
    }
    //si h se ha nombrado, se anulan las demás
    if(hflag == true){
        ayuda();
        return 1;
    }
    //si todos son falsos o ponemos a y m 
    if((uflag == false && gflag == false &&  aflag == false &&  mflag == false && sflag == false && hflag == false) || (aflag == true && mflag == true)){
        value = getenv("USER");
        if((pw = getpwnam(value) )== NULL){
                perror("error, no existe ese usuario\n");
                exit(EXIT_SUCCESS);
        }
        imprimirusuario(pw);

        if((gr = getgrgid(pw->pw_gid))== NULL){
            perror("error, este gid no corresponde a ningun grupo\n");
            exit(EXIT_SUCCESS);
        }
        imprimirgrupo(gr);
        return 1;
    }
    //si algunos de u y/o m son verdad
    if(uflag == true || mflag == true){
        if(gflag == true || hflag == true || sflag == true){
            printf("No compatibilidad con -u\n");
            return 1;
        }
        if (aflag == true && uflag == true){
            printf("No se puede -u y -a a la vez\n");
            return 1;
        }
        //se activa u
        if(uflag == true){
            if(stringoint(value) == 1){
                if((pw = getpwnam(value) )== NULL){
                    perror("error, no existe ese usuario\n");
                    exit(EXIT_SUCCESS);
                }
            }
            else{
                uid = atoi(value);
                if((pw = getpwuid(uid) )== NULL){
                    perror("error, este uid no corresponde a ningun usuario\n");
                    exit(EXIT_SUCCESS);
                }
            }
            imprimirusuario(pw);
            //valoramos m, porque a y m se valoraron antes
            if(mflag == true){
                if((gr = getgrgid(pw->pw_gid))== NULL){
                    perror("error, este gid no corresponde a ningun grupo\n");
                    exit(EXIT_SUCCESS);
                }
                imprimirgrupo(gr);
            }
        }
        return 1;
    }
    //se activa a
    if(aflag == true){
        if(uflag == true || gflag == true || hflag == true || sflag == true){
            printf("No compatibilidad con -a\n");
            return 1;
        }
        value = getenv("USER");
        if((pw = getpwnam(value) )== NULL){
                perror("error, no existe ese usuario\n");
                exit(EXIT_SUCCESS);
        }
        imprimirusuario(pw);
    }
    if(gflag == true){
        if(uflag == true || gflag == true ||  aflag == true ||  mflag == true || hflag == true){
            printf("No compatibilidad con -g\n");
            return 1;
        }
        if(stringoint(value) == 1){
            if((gr = getgrnam(value) )== NULL){
                perror("error, no existe ese grupo\n");
                exit(EXIT_SUCCESS);
            }
        }
        else{
            gid = atoi(value);
            if((gr = getgrgid(uid))== NULL){
                perror("error, este gid no corresponde a ningun grupo\n");
                exit(EXIT_SUCCESS);
            }
        }
        imprimirgrupo(gr);
        return 1;
    }
    if(sflag == true && (uflag == false && gflag == false &&  aflag == false &&  mflag == false && hflag == false)){
        todos_los_grupos();
        return 1;
    }
    else{
        printf("No compatible con -s\n");
        return 1;        
    }
    
    if(mflag == true && (uflag == false && aflag == false)){
        printf("La opcion --maingroup solo puede acompañar a --user o --active\n");
        ayuda();
        exit(EXIT_SUCCESS);
    }
    if (optind < argc) {
        printf("Argumentos ARGV que no son opciones: ");
        while (optind < argc)
            printf("%s ", argv[optind++]);
        putchar('\n');
    }

    exit(0);
}
