// ---- Liberación By duki.dev ---- //


1). Instalación:

- Primero que todo van a pegar la carpeta pawno en tu gm y le dan reemplazar y se pega el archivo que hay en dicha carpeta, o pega el archivo dentro del pawno de tu gm, TuGm/pawno/include en esa ubicacion pegan el archivo .inc

- Van a pegar la carpeta "src" dentro de la carpeta gamemodes

2). Adaptación

- se dirigen al .pwn de tu gm y deajo de todos los defines van a poner lo siguiente   	#include "src/notificaciones.pwn"

- Y ya pueden usar el notificador por ejemplo asi.

- SE DIRIGEN A SU GAMEMODE Y BUSCAN EL public OnPlayerConnect y pegan lo siguiente


    for(new ciclo; ciclo < MAX_NOT; ciclo++)
    {
        TextDrawsNotificador[playerid][ciclo][Usado] = 0;
        TextDrawsNotificador[playerid][ciclo][Linea] = 0;
        TextDrawsNotificador[playerid][ciclo][Text][0] = EOS;
        TextDrawsNotificador[playerid][ciclo][MinPosY] = 0;
        TextDrawsNotificador[playerid][ciclo][MaxPosY] = 0;
        TextDrawsNotificador[playerid][ciclo][Ocultar] = -1;
        TextDrawsNotificador[playerid][ciclo][TextDraw] = PlayerText:-1;
    }
    CicloNotif[playerid] = -1;

3). Usar

NOTIFICADOR(playerid, "~p~Felicidades~w~, has conseguido un nuevo trabajo.");

NOTIFICADOREX(playerid, "~p~Felicidades~w~, has conseguido un nuevo trabajo.");

- Ambos funcionan a la perfeccion.



Mas ayuda en discord: https://discord.gg/yaWEwkvFKf
