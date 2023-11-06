#include <td-string-width>

#define NOT_MODE_DEFAULT
#define MAX_NOT             6
#define NOT_POS_X           495.000000
#define NOT_POS_Y           132.000000
#define NOT_FONT            1
#define NOT_LETTER_SIZE_X   0.188333
#define NOT_LETTER_SIZE_Y   1.100000
#define NOT_SIZE            125.000000
#define NOT_COLOR           0xFFFFFFFF
#define NOT_COLOR_BOX       185
#define NOT_PROPORTIONAL    1
#define NOT_DISTANCE        0
#define NOT_MODE_DOWN
#define NOT_TIME            8000
#define MAX_NOT_TEXT        800


// ---- MACRO ---- //

#define     function%0(%1)      forward %0(%1); public %0(%1)


enum InformacionNotificador
{
    Usado,
    Linea,
    Text[MAX_NOT_TEXT],
    PlayerText:TextDraw,
    Float:MinPosY,
    Float:MaxPosY,
    Ocultar
}
new TextDrawsNotificador[MAX_PLAYERS][MAX_NOT][InformacionNotificador],
    contadornotificador[MAX_PLAYERS],CicloNotif[MAX_PLAYERS];

function TimerOcultarNotificador(playerid)
{
    for(new ciclo; ciclo < MAX_NOT; ciclo++)
    {
        if(TextDrawsNotificador[playerid][ciclo][Ocultar] == -1)
        {
            TextDrawsNotificador[playerid][ciclo][Usado] = 0;
            if(TextDrawsNotificador[playerid][ciclo][TextDraw] != PlayerText:-1)
            {
                PlayerTextDrawDestroy(playerid, TextDrawsNotificador[playerid][ciclo][TextDraw]);
                TextDrawsNotificador[playerid][ciclo][Linea] = 0;
                TextDrawsNotificador[playerid][ciclo][Text][0] = EOS;
                TextDrawsNotificador[playerid][ciclo][MinPosY] = 0;
                TextDrawsNotificador[playerid][ciclo][MaxPosY] = 0;
                TextDrawsNotificador[playerid][ciclo][TextDraw] = PlayerText:-1;
            }
            TextDrawsNotificador[playerid][ciclo][Ocultar] = -1;
            UpdateNOT(playerid);

            return 1;
        }
    }
    return 0;
}

function NOTIFICADOR(playerid, const reason[])
{
    for(new ciclo; ciclo < MAX_NOT; ciclo++)
    {
        if(!TextDrawsNotificador[playerid][ciclo][Usado])
        {
            TextDrawsNotificador[playerid][ciclo][Text][0] = EOS;

            new text[MAX_NOT_TEXT];

            for(new len = strlen(reason), pos; pos < len; pos ++)
            {
                switch(reason[pos])
                {
                     case 'à': text[pos] = 151;
                    case 'á': text[pos] = 152;
                    case 'â': text[pos] = 153;
                    case 'ä': text[pos] = 154;
                    case 'À': text[pos] = 128;
                    case 'Á': text[pos] = 129;
                    case 'Â': text[pos] = 130;
                    case 'Ä': text[pos] = 131;
                    case 'è': text[pos] = 157;
                    case 'é': text[pos] = 158;
                    case 'ê': text[pos] = 159;
                    case 'ë': text[pos] = 160;
                    case 'È': text[pos] = 134;
                    case 'É': text[pos] = 135;
                    case 'Ê': text[pos] = 136;
                    case 'Ë': text[pos] = 137;
                    case 'ì': text[pos] = 161;
                    case 'í': text[pos] = 162;
                    case 'î': text[pos] = 163;
                    case 'ï': text[pos] = 164;
                    case 'Ì': text[pos] = 138;
                    case 'Í': text[pos] = 139;
                    case 'Î': text[pos] = 140;
                    case 'Ï': text[pos] = 141;
                    case 'ò': text[pos] = 165;
                    case 'ó': text[pos] = 166;
                    case 'ô': text[pos] = 167;
                    case 'ö': text[pos] = 168;
                    case 'Ò': text[pos] = 142;
                    case 'Ó': text[pos] = 143;
                    case 'Ô': text[pos] = 144;
                    case 'Ö': text[pos] = 145;
                    case 'ù': text[pos] = 169;
                    case 'ú': text[pos] = 170;
                    case 'û': text[pos] = 171;
                    case 'ü': text[pos] = 172;
                    case 'Ù': text[pos] = 146;
                    case 'Ú': text[pos] = 147;
                    case 'Û': text[pos] = 148;
                    case 'Ü': text[pos] = 149;
                    case 'ñ': text[pos] = 174;
                    case 'Ñ': text[pos] = 173;
                    case '¡': text[pos] = 64;
                    case '¿': text[pos] = 175;
                    case '`': text[pos] = 177;
                    case '&': text[pos] = 38;
                    default:  text[pos] = reason[pos];
                }
            }

            strcat(TextDrawsNotificador[playerid][ciclo][Text], text, MAX_NOT_TEXT);

            TextDrawsNotificador[playerid][ciclo][Usado] = 1;
            LinesNOT(playerid, ciclo);

            #if defined NOT_MODE_DOWN

            MinPosYNOT(playerid, ciclo);
            MaxPosYNOT(playerid, ciclo);

            #endif

            #if defined NOT_MODE_UP

            MaxPosYNOT(playerid, ciclo);
            MinPosYNOT(playerid, ciclo);

            #endif

            TextDrawsNotificador[playerid][ciclo][Ocultar] = -1;

            CrearNOT(playerid, ciclo);

            SetTimerEx("TimerOcultarNotificador", NOT_TIME, false, "i", playerid);

            return 1;
        }
    }
    return -1;
}
// Nuevo notificador - editar notificador estatico sin sacarlo
function EditarNotifSeleccionado(playerid, const reason[], var)
{
    // Para que no modifique algo que no existe
    if(TextDrawsNotificador[playerid][CicloNotif[playerid]][Ocultar] == var) 
    {
        format(TextDrawsNotificador[playerid][CicloNotif[playerid]][Text], MAX_NOT_TEXT, reason);
        PlayerTextDrawSetString(playerid, TextDrawsNotificador[playerid][CicloNotif[playerid]][TextDraw], TextDrawsNotificador[playerid][CicloNotif[playerid]][Text]);
    }
    return 0;
}
//
function NotificadorSeleccionado(playerid, const reason[], var)
{
    for(new ciclo; ciclo < MAX_NOT; ciclo++)
    {
        if(!TextDrawsNotificador[playerid][ciclo][Usado])
        {
            TextDrawsNotificador[playerid][ciclo][Text][0] = EOS;

            new text[MAX_NOT_TEXT];

            for(new len = strlen(reason), pos; pos < len; pos ++)
            {
                switch(reason[pos])
                {
                    case 'à': text[pos] = 151;
                    case 'á': text[pos] = 152;
                    case 'â': text[pos] = 153;
                    case 'ä': text[pos] = 154;
                    case 'À': text[pos] = 128;
                    case 'Á': text[pos] = 129;
                    case 'Â': text[pos] = 130;
                    case 'Ä': text[pos] = 131;
                    case 'è': text[pos] = 157;
                    case 'é': text[pos] = 158;
                    case 'ê': text[pos] = 159;
                    case 'ë': text[pos] = 160;
                    case 'È': text[pos] = 134;
                    case 'É': text[pos] = 135;
                    case 'Ê': text[pos] = 136;
                    case 'Ë': text[pos] = 137;
                    case 'ì': text[pos] = 161;
                    case 'í': text[pos] = 162;
                    case 'î': text[pos] = 163;
                    case 'ï': text[pos] = 164;
                    case 'Ì': text[pos] = 138;
                    case 'Í': text[pos] = 139;
                    case 'Î': text[pos] = 140;
                    case 'Ï': text[pos] = 141;
                    case 'ò': text[pos] = 165;
                    case 'ó': text[pos] = 166;
                    case 'ô': text[pos] = 167;
                    case 'ö': text[pos] = 168;
                    case 'Ò': text[pos] = 142;
                    case 'Ó': text[pos] = 143;
                    case 'Ô': text[pos] = 144;
                    case 'Ö': text[pos] = 145;
                    case 'ù': text[pos] = 169;
                    case 'ú': text[pos] = 170;
                    case 'û': text[pos] = 171;
                    case 'ü': text[pos] = 172;
                    case 'Ù': text[pos] = 146;
                    case 'Ú': text[pos] = 147;
                    case 'Û': text[pos] = 148;
                    case 'Ü': text[pos] = 149;
                    case 'ñ': text[pos] = 174;
                    case 'Ñ': text[pos] = 173;
                    case '¡': text[pos] = 64;
                    case '¿': text[pos] = 175;
                    case '`': text[pos] = 177;
                    case '&': text[pos] = 38;
                    default:  text[pos] = reason[pos];
                }
            }

            strcat(TextDrawsNotificador[playerid][ciclo][Text], text, MAX_NOT_TEXT);

            TextDrawsNotificador[playerid][ciclo][Usado] = 1;

            LinesNOT(playerid, ciclo);

            #if defined NOT_MODE_DOWN

            MinPosYNOT(playerid, ciclo);
            MaxPosYNOT(playerid, ciclo);

            #endif

            #if defined NOT_MODE_UP

            MaxPosYNOT(playerid, ciclo);
            MinPosYNOT(playerid, ciclo);

            #endif

            CrearNOT(playerid, ciclo);

            for(new i; i < MAX_NOT; i++)
            {
                if(SeUso(playerid, contadornotificador[playerid]))
                {
                    if(contadornotificador[playerid] == MAX_NOT - 1) contadornotificador[playerid] = 0;
                    else contadornotificador[playerid]++;
                }

                else break;
            }

            new NOT = contadornotificador[playerid];

            TextDrawsNotificador[playerid][ciclo][Ocultar] = var; //
            CicloNotif[playerid] = ciclo; //

            if(contadornotificador[playerid] == MAX_NOT - 1) contadornotificador[playerid] = 0;
            else contadornotificador[playerid]++;
            return NOT;
        }
    }
    return -1;
}
function OcultarNotificador(playerid, var)
{
    for(new ciclo; ciclo < MAX_NOT; ciclo++)
    {
        if(TextDrawsNotificador[playerid][ciclo][Ocultar] == var) //
        {
            TextDrawsNotificador[playerid][ciclo][Usado] = 0;
            if(TextDrawsNotificador[playerid][ciclo][TextDraw] != PlayerText:-1)
            {
                PlayerTextDrawDestroy(playerid, TextDrawsNotificador[playerid][ciclo][TextDraw]);
                TextDrawsNotificador[playerid][ciclo][Linea] = 0;
                TextDrawsNotificador[playerid][ciclo][Text][0] = EOS;
                TextDrawsNotificador[playerid][ciclo][MinPosY] = 0;
                TextDrawsNotificador[playerid][ciclo][MaxPosY] = 0;
                TextDrawsNotificador[playerid][ciclo][TextDraw] = PlayerText:-1;
            }
            TextDrawsNotificador[playerid][ciclo][Ocultar] = -1;
            CicloNotif[playerid] = -1;
            UpdateNOT(playerid);
            return 1;
        }
    }
    return 0;
}
function SeUso(playerid, id)
{
    for(new ciclo; ciclo < MAX_NOT; ciclo++)
    {
        if(TextDrawsNotificador[playerid][ciclo][Ocultar] == id) return 1;
    }
    return 0;
}
function UpdateNOT(playerid)
{
    for(new ciclo = 0; ciclo < MAX_NOT; ciclo ++)
    {
        if(!TextDrawsNotificador[playerid][ciclo][Usado])
        {
            if(ciclo != MAX_NOT - 1)
            {
                if(TextDrawsNotificador[playerid][ciclo + 1][Usado])
                {
                    TextDrawsNotificador[playerid][ciclo][Usado] = TextDrawsNotificador[playerid][ciclo + 1][Usado];
                    TextDrawsNotificador[playerid][ciclo][Linea] = TextDrawsNotificador[playerid][ciclo + 1][Linea];
                    strcat(TextDrawsNotificador[playerid][ciclo][Text], TextDrawsNotificador[playerid][ciclo + 1][Text], MAX_NOT_TEXT);
                    TextDrawsNotificador[playerid][ciclo][TextDraw] = TextDrawsNotificador[playerid][ciclo + 1][TextDraw];
                    TextDrawsNotificador[playerid][ciclo][Ocultar] = TextDrawsNotificador[playerid][ciclo + 1][Ocultar];

                    TextDrawsNotificador[playerid][ciclo + 1][Usado] = 0;
                    TextDrawsNotificador[playerid][ciclo + 1][Linea] = 0;
                    TextDrawsNotificador[playerid][ciclo + 1][Text][0] = EOS;
                    TextDrawsNotificador[playerid][ciclo + 1][TextDraw] = PlayerText:-1;
                    TextDrawsNotificador[playerid][ciclo + 1][MinPosY] = 0;
                    TextDrawsNotificador[playerid][ciclo + 1][MaxPosY] = 0;
                    TextDrawsNotificador[playerid][ciclo + 1][Ocultar] = -1;

                    #if defined NOT_MODE_DOWN

                    MinPosYNOT(playerid, ciclo);
                    MaxPosYNOT(playerid, ciclo);

                    #endif

                    #if defined NOT_MODE_UP

                    MaxPosYNOT(playerid, ciclo);
                    MinPosYNOT(playerid, ciclo);

                    #endif
                }
            }
        }
        else if(TextDrawsNotificador[playerid][ciclo][Usado])
        {
            if(ciclo != 0)
            {
                if(!TextDrawsNotificador[playerid][ciclo - 1][Usado])
                {
                    TextDrawsNotificador[playerid][ciclo - 1][Usado] = TextDrawsNotificador[playerid][ciclo][Usado];
                    TextDrawsNotificador[playerid][ciclo - 1][Linea] = TextDrawsNotificador[playerid][ciclo][Linea];
                    strcat(TextDrawsNotificador[playerid][ciclo - 1][Text], TextDrawsNotificador[playerid][ciclo][Text], MAX_NOT_TEXT);
                    TextDrawsNotificador[playerid][ciclo - 1][TextDraw] = TextDrawsNotificador[playerid][ciclo][TextDraw];
                    TextDrawsNotificador[playerid][ciclo - 1][Ocultar] = TextDrawsNotificador[playerid][ciclo][Ocultar];

                    TextDrawsNotificador[playerid][ciclo][Usado] = 0;
                    TextDrawsNotificador[playerid][ciclo][Linea] = 0;
                    TextDrawsNotificador[playerid][ciclo][Text][0] = EOS;
                    TextDrawsNotificador[playerid][ciclo][TextDraw] = PlayerText:-1;
                    TextDrawsNotificador[playerid][ciclo][MinPosY] = 0;
                    TextDrawsNotificador[playerid][ciclo][MaxPosY] = 0;
                    TextDrawsNotificador[playerid][ciclo][Ocultar] = -1;

                    #if defined NOT_MODE_DOWN

                    MinPosYNOT(playerid, ciclo - 1);
                    MaxPosYNOT(playerid, ciclo - 1);

                    #endif

                    #if defined NOT_MODE_UP

                    MaxPosYNOT(playerid, ciclo - 1);
                    MinPosYNOT(playerid, ciclo - 1);

                    #endif
                }
            }
        }
        CrearNOT(playerid, ciclo);
    }
    return 1;
}

function MinPosYNOT(playerid, NOT)
{
    #if defined NOT_MODE_DOWN

    if(NOT == 0)
    {
        TextDrawsNotificador[playerid][NOT][MinPosY] = NOT_POS_Y;
    }
    else
    {
        TextDrawsNotificador[playerid][NOT][MinPosY] = TextDrawsNotificador[playerid][NOT - 1][MaxPosY] + NOT_DISTANCE;
    }
    return 1;

    #endif

    #if defined NOT_MODE_UP

    TextDrawsNotificador[playerid][NOT][MinPosY] = TextDrawsNotificador[playerid][NOT][MaxPosY] - ((NOT_LETTER_SIZE_Y * 2) + 2) - ((NOT_LETTER_SIZE_Y * 5.75) * TextDrawsNotificador[playerid][NOT][Linea]) - ((TextDrawsNotificador[playerid][NOT][Linea] - 1) * ((NOT_LETTER_SIZE_Y * 2) + 2 + NOT_LETTER_SIZE_Y)) - (NOT_LETTER_SIZE_Y + 3);
    return 1;

    #endif
}

function MaxPosYNOT(playerid, NOT)
{
    #if defined NOT_MODE_DOWN

    TextDrawsNotificador[playerid][NOT][MaxPosY] = TextDrawsNotificador[playerid][NOT][MinPosY] + (NOT_LETTER_SIZE_Y * 2) + 2 + (NOT_LETTER_SIZE_Y * 5.75 * TextDrawsNotificador[playerid][NOT][Linea]) + ((TextDrawsNotificador[playerid][NOT][Linea] - 1) * ((NOT_LETTER_SIZE_Y * 2) + 2 + NOT_LETTER_SIZE_Y)) + NOT_LETTER_SIZE_Y + 3;
    return 1;

    #endif

    #if defined NOT_MODE_UP

    if(NOT == 0)
    {
        TextDrawsNotificador[playerid][NOT][MaxPosY] = NOT_POS_Y;
    }
    else
    {
        TextDrawsNotificador[playerid][NOT][MaxPosY] = TextDrawsNotificador[playerid][NOT - 1][MinPosY] - NOT_DISTANCE;
    }
    return 1;

    #endif
}

function LinesNOT(playerid, NOT)
{
    new lines = 1, Float:width, lastspace = -1, supr, len = strlen(TextDrawsNotificador[playerid][NOT][Text]);

    for(new i = 0; i < len; i ++)
    {
        if(TextDrawsNotificador[playerid][NOT][Text][i] == '~')
        {
            if(supr == 0)
            {
                supr = 1;
                if(TextDrawsNotificador[playerid][NOT][Text][i+2] != '~') SendClientMessage(playerid, -1, "Error: '~' uso mal hecho che'");
            }
            else if(supr == 1) supr = 0;
        }
        else
        {
            if(supr == 1)
            {
                if(TextDrawsNotificador[playerid][NOT][Text][i] == 'n')
                {
                    lines ++;
                    lastspace = -1;
                    width = 0;
                }
            }
            else
            {
                if(TextDrawsNotificador[playerid][NOT][Text][i] == ' ') lastspace = i;

                width += NOT_LETTER_SIZE_X * GetTextDrawCharacterWidth(TextDrawsNotificador[playerid][NOT][Text][i], NOT_FONT, bool:NOT_PROPORTIONAL);

                if(width > NOT_SIZE - 3)
                {
                    if(lastspace != i && lastspace != -1)
                    {
                        lines ++;
                        i = lastspace;
                        lastspace = -1;
                        width = 0;
                    }
                    else
                    {
                        lines ++;
                        lastspace = -1;
                        width = 0;
                    }
                }
            }
        }
    }

    TextDrawsNotificador[playerid][NOT][Linea] = lines;

    return 1;
}

function CrearNOT(playerid, NOT)
{
    if(TextDrawsNotificador[playerid][NOT][Usado] == 1)
    {
        if(TextDrawsNotificador[playerid][NOT][TextDraw] != PlayerText:-1)
        {
            PlayerTextDrawDestroy(playerid, TextDrawsNotificador[playerid][NOT][TextDraw]);
        }

        TextDrawsNotificador[playerid][NOT][TextDraw] = CreatePlayerTextDraw(playerid, NOT_POS_X, TextDrawsNotificador[playerid][NOT][MinPosY], TextDrawsNotificador[playerid][NOT][Text]);
        PlayerTextDrawFont(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], NOT_FONT);
        PlayerTextDrawLetterSize(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], NOT_LETTER_SIZE_X, NOT_LETTER_SIZE_Y);
        PlayerTextDrawTextSize(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], floatadd(NOT_POS_X, NOT_SIZE), 1.100000);
        PlayerTextDrawSetOutline(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], 1);
        PlayerTextDrawSetShadow(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], 0);
        PlayerTextDrawAlignment(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], 1);
        PlayerTextDrawColor(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], NOT_COLOR);
        PlayerTextDrawBackgroundColor(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], NOT_COLOR_BOX);
        PlayerTextDrawBoxColor(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], NOT_COLOR_BOX);
        PlayerTextDrawUseBox(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], 1);
        PlayerTextDrawSetProportional(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], NOT_PROPORTIONAL);
        PlayerTextDrawSetSelectable(playerid, TextDrawsNotificador[playerid][NOT][TextDraw], 0);
        PlayerTextDrawShow(playerid, TextDrawsNotificador[playerid][NOT][TextDraw]);
    }
    return 1;
}

function NOTIFICADOREX(playerid, const text[], {Float, _}:...)
{
    static
        args,
        str[192];

    if ((args = numargs()) <= 2)
    {
        NOTIFICADOR(playerid, text);
    }
    else
    {
        while (--args >= 2)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 192
        #emit PUSH.C str
        #emit LOAD.S.pri 8
        #emit CONST.alt 4
        #emit ADD
        #emit PUSH.pri
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        NOTIFICADOR(playerid, str);

        #emit RETN
    }
    return 1;
}
