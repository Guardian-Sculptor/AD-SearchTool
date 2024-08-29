# AD-SearchTool
AD-SearchTool is a collection of PowerShell scripts designed to streamline the process of querying and managing Active Directory (AD) user information. This toolkit allows administrators to efficiently search for users based on email, username, or phone number, and retrieve detailed user properties including name, email, telephone number, account status, group memberships, and etc. This script will process a single file containing a list of emails, usernames, or phone numbers, identify the type of input, and search AD accordingly. The results are exported to output.csv

**How to Use:**
1.	Prerequisites

  	•	Ensure you have PowerShell installed.

    •	You must have the Active Directory module installed. If you don’t have this module installed, you can use the command ```Install-WindowsFeature -Name RSAT-AD-PowerShell ```



2.	Clone the Repository:

    •	git clone https://github.com/cyberhub-programmer/AD-SearchTool.git


3.	Running the Scripts:

    •	Modify input.txt file to search for email addresses, phone numbers & usernames. *Note* that phone numbers will get modified to the correct format “(XXX) XXX-XXXX”. 

    •	Run File on PowerShell using command ```.\SearchAD.ps1 ```


4.	Customizing the Output:

    •	You can modify the properties retrieved by adjusting the ```objectproperties``` function. Add or remove properties as needed to tailor the output to your requirements.




**Contributing:**
  
  •	Contributions are welcome! Feel free to fork the repository, make improvements, and submit a pull request.
  
  •	Please report any issues or suggest new features via the GitHub Issues tab.




