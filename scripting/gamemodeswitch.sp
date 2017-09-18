#define PLUGIN_AUTHOR "Czar"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

char map[64];
char gamemode[64];

public Plugin myinfo = 
{
	name = "Gamemode Switcher",
	author = PLUGIN_AUTHOR,
	description = "Switch server gamemodes",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	RegAdminCmd("sm_gamemode", Gamemode, ADMFLAG_GENERIC);
}

public Action Gamemode(int client, int args)
{
	Menu menu = CreateMenu(MenuHandler1, MENU_ACTIONS_ALL);
	SetMenuTitle(menu, "Select a Gamemode");
	AddMenuItem(menu, "competitive", "Competitive");
	AddMenuItem(menu, "retake", "Retake");
	AddMenuItem(menu, "deathmatch", "Deathmatch");
	AddMenuItem(menu, "1v1", "1v1");
	AddMenuItem(menu, "paintball", "Paintball");
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, 0);
}

public int MenuHandler1(Handle menu, MenuAction action, int client, int temp)
{
	if ( action == MenuAction_Select ) 
	{
		GetMenuItem(menu, temp, gamemode, sizeof(gamemode));
		MapMenu(client);
	}
	else if (action == MenuAction_Cancel) 
	{ 
		PrintToServer("Client %d's menu was cancelled.  Reason: %d", client, temp); 
	} 
		
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}

}

public Action MapMenu(int client)
{	
	Menu menu2 = CreateMenu(MenuHandler2, MENU_ACTIONS_ALL);
	SetMenuTitle(menu2, "Select a Map");
	Handle hFile = OpenFile("maplist.txt", "rt");
	if(hFile == INVALID_HANDLE)
	{
		PrintToChat(client, " \x02 File not available");
		return;
	}
	char mapname[128];
	if (StrEqual(gamemode, "Competitive"))
	{
		while(!IsEndOfFile(hFile) && ReadFileLine(hFile, mapname, sizeof(mapname)))
		{
			if(StrContains(mapname, "de_", false) != -1)
			{
				AddMenuItem(menu2, mapname, mapname);
			}
		}
	}
	if (StrEqual(gamemode, "retake"))
	{
		while(!IsEndOfFile(hFile) && ReadFileLine(hFile, mapname, sizeof(mapname)))
		{
			if(StrContains(mapname, "de_", false) != -1)
			{
				AddMenuItem(menu2, mapname, mapname);
			}
		}
	}
	if (StrEqual(gamemode, "deathmatch"))
	{
		while(!IsEndOfFile(hFile) && ReadFileLine(hFile, mapname, sizeof(mapname)))
		{
			if(StrContains(mapname, "de_", false) != -1)
			{
				AddMenuItem(menu2, mapname, mapname);
			}
		}
	}
	if (StrEqual(gamemode, "1v1"))
	{
		while(!IsEndOfFile(hFile) && ReadFileLine(hFile, mapname, sizeof(mapname)))
		{
			if(StrContains(mapname, "am_", false) != -1)
			{
				AddMenuItem(menu2, mapname, mapname);
			}
		}
	}
	if (StrEqual(gamemode, "Paintball"))
	{
		while(!IsEndOfFile(hFile) && ReadFileLine(hFile, mapname, sizeof(mapname)))
		{
			if(StrContains(mapname, "pb_", false) != -1)
			{
				AddMenuItem(menu2, mapname, mapname);
			}
		}
	}
	CloseHandle(hFile)
	SetMenuExitButton(menu2, true);
	DisplayMenu(menu2, client, 0);
}

public int MenuHandler2(Handle menu, MenuAction action, int client, int temp)
{
	if ( action == MenuAction_Select ) 
	{
		GetMenuItem(menu, temp, map, sizeof(map));
		if(StrEqual(gamemode, "retake"))
		{
			GamemodeCompetitive();
		}
		if(StrEqual(gamemode, "retake"))
		{
			GamemodeRetake();
		}
		if(StrEqual(gamemode, "deathmatch"))
		{
			GamemodeDeathmatch();
		}
		if(StrEqual(gamemode, "1v1"))
		{
			Gamemode1v1();
		}
		if(StrEqual(gamemode, "paintball"))
		{
			GamemodePaintball();
		}
	}
	else if (action == MenuAction_Cancel) 
	{ 
		PrintToServer("Client %d's menu was cancelled.  Reason: %d", client, temp); 
	} 
		
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public void GamemodeCompetitive()
{
	ServerCommand("changelevel %s;sm plugins unload disabled/multi1v1;sm plugins unload disabled/deathmatch;sm plugins unload disabled/warmod;sm plugins unload disabled/paintball;sm plugins unload disabled/retakes;", map);
}

public void GamemodeRetake()
{
	ServerCommand("changelevel %s;sm plugins unload disabled/multi1v1;sm plugins unload disabled/deathmatch;sm plugins unload disabled/warmod;sm plugins unload disabled/paintball;sm plugins load disabled/retakes;", map);
}

public void GamemodeDeathmatch()
{
	ServerCommand("changelevel %s;sm plugins unload disabled/multi1v1;sm plugins unload disabled/retakes;sm plugins unload disabled/warmod;sm plugins unload disabled/paintball;sm plugins load disabled/deathmatch;mp_warmuptime 20", map);
}

public void Gamemode1v1()
{
	ServerCommand("changelevel %s;sm plugins unload disabled/retakes;sm plugins unload disabled/deathmatch;sm plugins unload disabled/warmod;sm plugins unload disabled/paintball;sm plugins load disabled/multi1v1;", map);
}

public void GamemodePaintball()
{
	ServerCommand("changelevel %s;sm plugins unload disabled/retakes;sm plugins unload disabled/deathmatch;sm plugins unload disabled/warmod;sm plugins unload disabled/multi1v1;sm plugins load disabled/paintball;", map);
}




