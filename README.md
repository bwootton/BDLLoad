== BDL Parse

This rails app is used to parse BDL files (described here: ) and support distributed viewing and (eventually) update of
the underlying models.

The app uses Ruby 1.9.3 and the Rails 3.1.x framework. I've left it configured with sqlite and webrick, but it
shouldn't have any issues running with a more advanced db and app server.

== Basic installation

The application can be accessed online here:

Alternatively,

1. install ruby, rubygems and bundler,
2. clone the git repo to your app server,
3. cd to the app root
4. run *bundle install* to install dependencies
5. run *rails s* to start the server

Rspec of a small number of tests (mostly around tokenization and parsing) may be run : using *bundle exec rspec spec*


== Using the App
The UI is very simple.

*/bdl_files* will allow you to browse uploaded files.
*/bdl_files/new* Will allow you to upload files for parsing. Large files take about a minute to parse and persist.
I couldn't find any other bdl files to try.
*/bdl_files/:id* will display a summary of the uploaded file.
*/bdl_files/:id/polygons* will display a floor plan of the spaces on each floor.  Since I was unable to determine the protocol
for specifying floors (outside of uname conventions,) I added a regex filter for viewing floor plans.  By default, it's set to
see all spaces starting with 1 (/^1/).  Leaving the filter off will show all floors stacked on top of each other.
*/bdl_files/:id/instruction/:instruction_id* will display the instruction with any subordinate relationships.



 == Thoughts on using rails
 I wanted to see how easy it would be to create a distributed app for this purpose and to mess with the D3 library a bit.
 It seems to me that having models online would be useful for rerunning simulations periodically to optimize the model
 base on new data.
 To make it really useful, some sort of MVCish framework like backbone would be wise, particularly so that models could be
 persisted in the browser when a user did not have network access (ipad use case).  In this case, the controllers would
 probably be updated to send a more complete set of json in response to requests, and update ingestion would need to
 occur.
 I didn't implement polygon containment,which would be necessary to select spaces from the ui, which I would be useful.
 It would also be cool to be able to add spaces/etc on the fly.


 == Data representation
 BdlFiles are parsed into Instructions.  Each Instruction has an i_type, an optional uname and 0 or more attributes
 maintained in the NameValue objects.   BdlFiles can refer to multiple subordinate records keyed off of instruction
 unames appearing as a value in the attributes.  This subordinate records are maintained in Reference objects which
 join parent Instructions to child instructions.

 It would be easy to create subclassed Instruction types (spaces, polygons, materials, etc ...), and would probably be
 worth it to add on extra functionality and validations (spaces should have walls, etc.)  However, I chose to use dynamic
 typing for the sake of time.


 == Limitations
 1. Assumed all attributes of instructions followed the *name = value* convention and not the *name value* convention.
 2. Could not find a way to differentiate elevations for spaces.  Because of this, I implemented some filtering on
 space views (described above).
 3. There's no editing of data implemented, although it would be relatively easy to do, given the db backing.
 4. Testing's not as thorough as I'd like to be, but good for the demo nature of this project.

