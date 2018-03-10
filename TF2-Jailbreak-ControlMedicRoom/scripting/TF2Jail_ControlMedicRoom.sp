#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Battlefield Duck"
#define PLUGIN_VERSION "1.0"

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <morecolors>
#include <tf2jail>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "[TF2] Jailbreak - Control Medic Room",
	author = PLUGIN_AUTHOR,
	description = "Let Warden to Enable or Disable medic room",
	version = PLUGIN_VERSION,
	url = "http://steamcommunity.com/id/battlefieldduck/"
};

Handle hEnabled;
bool bEnableMR; //bool Enable Medic Room

public void OnPluginStart()
{
	LoadTranslations("TF2Jail.phrases");
	HookEvent("teamplay_round_start", OnRoundStart);
	
	CreateConVar("sm_tf2jail_cmr_version", PLUGIN_VERSION, "Version of [TF2] Jailbreak - Control Medic Room", FCVAR_SPONLY|FCVAR_DONTRECORD|FCVAR_NOTIFY);
	hEnabled = CreateConVar("sm_tf2jail_cmr_enable", "1", "Enable [TF2] Jailbreak - Control Medic Room", _, true, 0.0, true, 1.0);
	RegConsoleCmd("sm_cmr", ControlMR, "Enable or Disable Medic room");
}

public Action ControlMR(int client, int args)
{
	if(!GetConVarBool(hEnabled))
		return Plugin_Continue;
		
	if(!TF2Jail_IsWarden(client))
	{
		CPrintToChat(client, "%t %t", "plugin tag", "not warden");
		return Plugin_Continue;
	}
	
	if(bEnableMR)
	{
		bEnableMR = false;
		CPrintToChatAll("%t {darkkhaki} Warden {green}%N {darkkhaki}has disabled the Medic Room!", "plugin tag", client);
	}
	else
	{
		bEnableMR = true;
		CPrintToChatAll("%t {darkkhaki} Warden {green}%N {darkkhaki}has enabled the Medic Room!", "plugin tag", client);
	}
		
	int i = -1;
	while((i = FindEntityByClassname(i, "trigger_hurt")) != -1)
	{
		if(bEnableMR) 
       		AcceptEntityInput(i, "Enable");
    		else
       		AcceptEntityInput(i, "Disable");
	}
	return Plugin_Continue;
}

//------------------[ Enable Medic Room On round start]----------------------
public Action OnRoundStart(Handle event, char[] name, bool dontBroadcast)
{
	if(!GetConVarBool(hEnabled))
		return;
		
	bEnableMR = true;
}


