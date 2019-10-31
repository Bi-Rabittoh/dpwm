import std.stdio;
import std.file;
import std.utf : byChar;
import std.string;
import secured.symmetric;
import std.json;
import std.digest.md;

//base functions
string getFileContent(string filename){
	assert(exists(filename));
	return cast(string) read(filename.byChar);
}

ubyte[16] string2MD5(string input){
	MD5 md5;
	md5.start();
	md5.put(cast(ubyte[]) input);
	return md5.finish();
}

JSONValue decryptDB(string pw, string filename){
	string content = getFileContent(filename);
	ubyte[] dec;
	dec = decrypt(string2MD5(pw), cast(ubyte[])content, dec);
	return parseJSON(cast(string)dec);
}


void encryptDB(string pw, string content, string filename){
		//write default data structure on DB
		std.file.write(filename, cast(string) encrypt(string2MD5(pw), cast(ubyte[]) content, null));
}

void main(){
	const string inputFile = "data.db";

	//welcome text
	writeln("Welcome to my pw manager tool.\n");

	string temp;
	JSONValue db;

	if(exists(inputFile)){
		//the file exists, ask for key and test it
		writeln("DB detected. Please insert your decryption key:");
		do {
			temp = readln.strip;
		} while(temp == "");
		db = decryptDB(temp, inputFile);
		
		writeln(db["test"].str);

	} else {
		//the file doesn't exist, ask for key and create it
		writeln("I didn't detect any database, so I will create a new one for you. Please write your encryption key.");
		do {
			temp = readln.strip;
		} while(temp == "");
		db = [ "test": "0" ];
		encryptDB(temp, db.toString, inputFile);
	}

	/* MENU */
	int choice;
	do {
		writeln("\nEnter a number for what you wish to do:");
		writeln("1. Show all passwords in DB (WIP)");
		writeln("2. Generate a new password (WIP)");
		writeln("3. Add an existing password (WIP)");
		writeln("4. Delete a saved password (WIP)");
		writeln("0. Exit program");

		readf(" %s", &choice);
		switch(choice){
			case 0: //exit
				writeln("Bye bye!");
				break;
			case 1:
				writeln(db);
				break;
			case 2:

				break;
			case 3:

				break;
			case 4:

				break;
			default:
				writeln("Please insert a number from the menu!");
		}
	} while(choice != 0);
	/* END MENU */
}

/* JSON EXAMPLES

// create a json struct
JSONValue jj = [ "language": "D" ];

// rating doesnt exist yet, so use .object to assign
jj.object["rating"] = JSONValue(3.5);

// create an array to assign to list
jj.object["list"] = JSONValue( ["a", "b", "c"] );

// list already exists, so .object optional
jj["list"].array ~= JSONValue("D");

*/