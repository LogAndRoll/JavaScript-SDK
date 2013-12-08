![image](http://logroll.in/images/logo-promo.png)

Log&Roll SDK
=======

Use the official Log&Roll JavaScript SDK to push logs from your Web or Node app to the Log&Roll network.

##"Web or Node?"
Yeah that's right. I'll write a blog post about it how it works, for now you have to deal with the instructions from "Installation from source". :)

##Installation from source

***Note:*** This will set you up with the latest experimental version of Log&Roll. If you want to use a stable version, please download the SDK from your app's installation page.

- Sign up on [Log&Roll](http://logroll.in) if you haven't done already
- Select or Register your application
	
	Optionally, add team members to your app so they can view logs too
			
	
- Go to installation, choose 'Node' or 'Web' as platform and grab the example code for your application and follow the instructions from there.

  ***Instead of downloading the SDK from the installation page,*** make sure you do the following:
  
    
  - Install the Brunch Continuous Integration Server, if you haven't done already	- Use this command: `sudo npm install -g brunch`	- More info on [brunch.io](http://brunch.io/)
  - Clone this repository: `git clone https://github.com/LogAndRoll/JavaScript-SDK.git`
  - Build the SDK
	  - If you want a SDK for Node, build using `brunch b -e node`
	  - If you want a SDK for browser JavaScript, build using `brunch b -e browser`
  
	  If you want a minified SDK, just put -P behind the brunch commands
  

##Contribute

Help from the community means a lot to me to me, which is why all Log&Roll SDKs are open-source.

If you would like to make changes to the JavaScript SDK, you are encouraged to clone this repository and make a pull request!
Want to make an SDK for a new platform? Please submit your information about the SDK on the [contact page](http://logroll.in/#/contact) and if you like, we can add and support it as a official plarfrom SDK!

