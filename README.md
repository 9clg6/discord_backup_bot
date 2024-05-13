
This bot enables anyone to make backups of their Discord server(s) at configurable frequencies. It can also import these backups to rebuild the servers.

## 💻 Installation

###  Supabase

1. To deploy this bot, you need to set up a [Supabase](https://supabase.com/) database.
2. Create two collections named : 
	2.1. "**initialization**"
	
	It allows you to save the status of your servers, whether they are initialized or not.
	The fields to be set are :
	
			- serverId: int8 (primaryKey)
			- isInitialized: bool
			- isInitialized: int8
			- isInitialized: int8
			
	2.2. "**save**"

	This collection will directly store exports from your Discord servers. Channels (voice and text) and messages will be compressed and stored as strings.
The fields to be set are :
	
			- id: int8
			- server: text
			- serverName: text
			- serverId: int8
			
3. Retrieve your API Key on [Discord Developer Portal](https://discord.com/developers/applications)
4. Create a `.env` file containing the Discord API Key, the Supabase token and the URL of the Supabase database. An `.example.env` file has already been versioned
5. **OPTIONAL**: Ideally, you should set up a Docker, hosted on your own server or in a cloud, like OVH for example.

## 💡 How to use 

Once you've set up the environment, all you have to do is type `/initialize` in a text channel and your backup will be scheduled every day at the time you sent the command.

## 😀 Support

I will gladly accept your MRs :) 
