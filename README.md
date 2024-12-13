The objective is to populate a template using information from Boomi and a DB.

## Steps
1. Create a Maria/MySQL/AuroraDB DB with the [DDL file](https://github.com/p-hatz/Boomi-DocGen/blob/main/MariaDB-DDL.sql); the tables will need to be populated with the required data
2. Create a Google Apps Script using the [Google Script](https://github.com/p-hatz/Boomi-DocGen/blob/main/main.gs)
3. Ensure you create the Apps Script Properties (Project Settings -> Script Properties)<br>
   `auth` (AtomSphere API password in Base64)<br>
   `boomiAccount` (AtomSphere Account)<br>
   `url` (jdbc URL to DB)<br>
   `user` (DB User)<br>
   `pass` (DB password)<br>
   `templateId` (GDoc template)<br>
4. Deploy the Script where you will get a URL that you can POST a `processId` to. For example<br>
> {<br>
> &emsp;&emsp;"processId": "f50c35e7-96b7-4626-9d02-18644f259f7a"<br>
> }<br>

The API should respond with a link to the Google Doc generated (in the same folder that the Template is in). For example<br>
> {<br>
> &emsp;&emsp;"status": "success",<br>
> &emsp;&emsp;"document": "https://docs.google.com/document/d/1IjRtXrXltc6BvwwyLw05DIx4ZBmMuC7cACl1asW0wd/edit?usp=drivesdk"<br>
> }
