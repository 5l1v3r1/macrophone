Macrophone
======

After asking you for a song, Macrophone fetches lyrics from [MetroLyrics](http://www.metrolyrics.com) and reads them in a voice of your choosing.

#### How It Works
When Macrophone receives your preferred song and artist, it formats your selection and pastes it into a MetroLyrics URL. Once it grabs your song's lyrics page, it strips away all of the HTML to reveal the words to your song. That text is then sent to the OS X `say` command, a useful text-to-speech program bundled in with the system's default software.

#### Usage
Download the file and add execution permissions to the script. If you're unfamiliar with the command-line interface, you can open up the Terminal application on your computer and copy+paste the following commands:

	cd ~/Downloads
	curl -o macrophone.sh https://raw.githubusercontent.com/calebgross/macrophone/master/macrophone.sh
	sudo chmod +x macrophone.sh
	
 Invoke the program by simply typing:
 
	./macrophone.sh

When prompted to select a song, artist, or voice, enter your choice followed by the "Enter" key. Don't worry about capitalization—your input will be processed and formatted automatically. Note that some song names might be formatted in an odd way on the MetroLyrics site; if your selection doesn't work after a few tries, try checking their [website](http://www.metrolyrics.com) to see how they've listed the song. You can also pass the song, artist, and voice as command-line arguments instead:

	./macrophone.sh "wrecking ball" "miley cyrus" "alex"

Your most recent selections are saved in `/tmp/.macrophone_config`. For example, simply hitting "Enter" after each of the following lines:

	Enter song [Wrecking Ball]:  
	Enter artist [Miley Cyrus]:  
	Enter voice (for a list of voices, type help) [Alex]:
	
will tell your computer to use those settings. You should then see:

	Now singing Wrecking Ball by Miley Cyrus in the voice of Alex (hit ctrl+c to cancel)...
	
#### To-do
* Search across multiple lyrics sites
* Print lyrics as they're being read (probably unrealistic, but fun to suggest)
* Implement error handling on user input