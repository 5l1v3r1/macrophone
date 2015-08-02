Macrophone
======

After asking you for a song, Macrophone fetches lyrics from [MetroLyrics](http://www.metrylyrics.com) and reads it them in a voice of your choosing.

When prompted to select a song, artist, or voice, enter your choice followed by the "Enter" key. Don't worry about capitalization—your input will be processed and formatted automatically. Note that some song names might be formatted in an odd way on the MetroLyrics site; if your selection doesn't work after a few tries, try checking their [website](http://www.metrylyrics.com) to see how they've listed the song.

Your most recent selections are saved in `/tmp/.sing_config`. For example, simply hitting "Enter" after each of the following lines:

	Enter song [wrecking-ball]: 
	Enter artist [miley-cyrus]: 
	Enter voice (type help for a list of voices) [Alex]:
	
will tell your computer to use those settings. You should see:

	Now singing wrecking-ball by miley-cyrus in the voice of Alex (hit ctrl+c to cancel)...
	
#### To-do
* Display most recent configurations in a more easily readable format
* Reuse code, and generally rewrite it to be more efficient
* Allow user to select voices with spaces in the name