/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author May Keam
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> allLeads() {
		return [SELECT Id, LastName, Company, Phone, Email
				FROM Lead
				WITH SECURITY_ENFORCED];
	}

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> contactFirstNameJohn() {
		return [SELECT Id, Name, FirstName
				FROM Contact
				WHERE FirstName = 'John'
				WITH SECURITY_ENFORCED];
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> contactSmithOrJones() {
		List<Id> idSmithJones = new List<Id>();
		List<Contact> lastNameSmithOrJones = [SELECT Id, Name, FirstName, LastName
											  FROM Contact
											  WHERE LastName = 'Smith' OR LastName = 'Jones'
											  WITH SECURITY_ENFORCED];
		for( Contact con : lastNameSmithOrJones ) {
			idSmithJones.add(con.Id);
		}
		return idSmithJones;
	}

	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	public static List<Opportunity> closedWonOppsForAcct(Id accountId) {
		return [SELECT Id, Name, Amount, CloseDate, StageName, Account.Name, Account.Id
				FROM Opportunity
				WHERE Account.Id = :accountId AND StageName = 'Closed Won'
				WITH SECURITY_ENFORCED];
	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	public static Integer countOfAccounts() {
		AggregateResult[] result = [SELECT COUNT(Id) totalAccounts
								  FROM Account
								  WITH SECURITY_ENFORCED];
		return (Integer)result[0].get('totalAccounts');
	}

	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	public static Map<Id, Task> taskIdToTask() {
		Map<Id, Task> idToTask = new Map<Id, Task>();
		List<Task> myTasks = [SELECT Id, Subject, ActivityDate
	  	  	  		          FROM Task
			 		          WHERE ActivityDate = NEXT_N_Days:7
							  WITH SECURITY_ENFORCED];
		for(Task tsk : myTasks) {
			idToTask.put(tsk.Id, tsk);
		}
	return idToTask;
	}

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> myContactEmails(){
		return [SELECT Id, Name, Email
				FROM Contact
				WHERE Email LIKE '%example.com'
				WITH SECURITY_ENFORCED];
	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		String findKeyword = '%' + keyword + '%';
		return [SELECT Id, Name
				FROM Opportunity
				WHERE Name LIKE :findKeyword
				WITH SECURITY_ENFORCED];
		// Replace null with the variable you used to store the result
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		return [SELECT CaseNumber, Origin
				FROM Case
				WHERE Origin != 'Web' AND Origin != 'Email' AND Origin != ''
				WITH SECURITY_ENFORCED];
		// Replace null with the variable you used to store the result
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> leadSourceTitle(String source, String title){
		String titleKeyWord = '%' + title + '%';
		return [SELECT LeadSource, Title, Company, Phone, Email, LastName
				FROM Lead
				WHERE LeadSource = :source
				OR Title LIKE :titleKeyWord
				WITH SECURITY_ENFORCED];
	}

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		// Create a list to hold the Contact LastNames
		List<String> contactLastNames = new List<String>();
		// Query the Contacts
		List<Contact> contactsInAccount = [SELECT Id, LastName, AccountId
										   FROM Contact
										   WHERE AccountId = :accountId
										   WITH SECURITY_ENFORCED];
		// Loop through each Contact and add the LastName to the list
		for (Contact con: contactsInAccount) {
			contactLastNames.add(con.LastName);
		}
		// Return the list of Contact LastNames
		return contactLastNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		// Use AggregateQuery to get the total revenue
		AggregateResult[] groupedResults = [SELECT SUM(Amount)rev
											FROM Opportunity
											WHERE StageName = :stage
											OR Amount > 10000
											WITH SECURITY_ENFORCED];
		// Return the total revenue
		return (Decimal)groupedResults[0].get('rev'); // Replace null with the variable you used to store the result
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		return [SELECT Id, Name
				FROM Account
				WITH SECURITY_ENFORCED
				ORDER BY Name ASC
				LIMIT 10];
	// Replace null with the variable you used to store the result
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		return [SELECT AccountId, Name, CloseDate, StageName, Amount
				FROM Opportunity
				WHERE Amount > 100000
				WITH SECURITY_ENFORCED
				ORDER BY CloseDate ASC
				LIMIT 5];
	// Replace null with the variable you used to store the result
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		Date today = Date.today();
		Integer currentMonth = today.month();
		return [SELECT LastName, Birthdate
				FROM Contact
				WHERE Birthdate != null
				AND CALENDAR_MONTH(Birthdate) = :currentMonth
				WITH SECURITY_ENFORCED
				ORDER BY Birthdate DESC
				LIMIT 3]; 
		// Replace null with the variable you used to store the result
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		return [SELECT Status, CreatedDate
				FROM Case
				WHERE Status = 'Open'
				WITH SECURITY_ENFORCED
				ORDER BY CreatedDate ASC
				LIMIT 10
				OFFSET 5];
		// Replace null with the variable you used to store the result
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		// Create a set to hold the Case Ids
		Set<Id> myCasesForAcct = new Set<Id>();
		// Query the Cases
		List<Case> myCases = [SELECT Id, CaseNumber, Account.Id, Account.Name
							  FROM Case
							  WHERE Account.Id = :accountId
							  WITH SECURITY_ENFORCED];
		// Loop through each Case and add the Id to the set
		for(Case cases : myCases) {
			myCasesForAcct.add(cases.Id);
		}
		//}

		return myCasesForAcct; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		// Create a map to hold the Account Ids to Account Names
		Map<Id, String> accountIdsToNames = new Map<Id, String>();

		// Query the Accounts
		List<Account> myAccts = [SELECT Id, Name, BillingCountry
								 FROM Account
								 WHERE BillingCountry != :country
								 WITH SECURITY_ENFORCED];
		// Loop through each Account and add the Id and Name to the map
		for(Account acc : myAccts) {
			accountIdsToNames.put(acc.Id, acc.Name);
		}
		return accountIdsToNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		List<Contact> myContact = [SELECT Id, LastName, AccountId, Account.Name
								   FROM Contact
								   WHERE Id = :contactId
								   WITH SECURITY_ENFORCED
								   LIMIT 1];
		String myAcct = myContact[0].Account.Name;
		return myAcct; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		return [SELECT Id, Name, 
				(SELECT Id, Name FROm Opportunities)
				FROM Account
				WHERE Id = :accountId
				WITH SECURITY_ENFORCED
				LIMIT 1];
		// Replace null with the variable you used to store the result
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		// Query the Account
		Account acct = [SELECT Id, Name, BillingState
						FROM Account
						WHERE Id = :accountId
						WITH SECURITY_ENFORCED];		
		// Query the Contacts
		List<Contact> myContacts = [SELECT Id, Name, MailingState, AccountId, Account.BillingState
								    FROM Contact
									WHERE AccountId = :accountId];

		List<Contact> contactsWithSameMailing = new List<Contact>();
		for(Contact con : myContacts) {
			if(con.MailingState == con.Account.BillingState) {
				contactsWithSameMailing.add(con);
			} 
			continue;
		}
		return contactsWithSameMailing; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 22
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		// Query the Leads
		List<Lead> myLeads = [SELECT Id, Company, Email
							  FROM Lead
							  WHERE Id IN:leadIds
							  WITH SECURITY_ENFORCED];
		// Loop through each Lead
		Set<String> myDomains = new Set<String>();
		// Check if the email is not null
		for(Lead lead : myLeads) {
			if(lead.Email != null) {
				myDomains.add(lead.Email);
			}
		}
		// Create a set of email domains from the Leads
		Set<String> leadDomains = new Set<String>();
		// Get the email from the Lead
		// Add the email domain to the set
		for(String str: myDomains) {
			leadDomains.add(str.substringAfter('@'));
		}
		// Create website based on email domain 
		List<String> websites = new List<String>();
		for(String email : leadDomains) {
			websites.add('www.' + email);
		}
		// Query the Accounts
		return [SELECT Id, Name, Website
				FROM Account
				WHERE Website IN:websites
				WITH SECURITY_ENFORCED];
	 	// Replace null with the variable you used to store the result
	}
	
	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		// Query the original Opportunity Line Items
		List<OpportunityLineItem> myOppLineItems = [SELECT 
														Id, 
														Description, 
														Product2Id, 
														PricebookEntryId, 
														Quantity, UnitPrice, 
														Opportunity.Name, 
														OpportunityId
									 				FROM OpportunityLineItem
													WHERE OpportunityId = :origOppId
													WITH SECURITY_ENFORCED];
		// Create a list to hold the new line items
		List<OpportunityLineItem> clonedOppLineItems = new List<OpportunityLineItem>();
		// Generate a random number between 1 and 3
		for(Id cloneOppId : cloneOppIds) {
		Integer randomnumber = (Integer) Math.floor(Math.random() * 3 + 1);
							
		for(OpportunityLineItem newOppLineItem : myOppLineItems) {
			OpportunityLineItem clonedOppLineItem = new OpportunityLineItem();
				clonedOppLineItem.Description = newOppLineItem.Description;
				clonedOppLineItem.Product2Id = newOppLineItem.Product2Id;
				clonedOppLineItem.Quantity = randomnumber;
				clonedOppLineItem.UnitPrice = newOppLineItem.UnitPrice;
				clonedOppLineItem.PricebookEntryId = newOppLineItem.PricebookEntryId;			
				clonedOppLineItem.OpportunityId = cloneOppId;
				clonedOppLineItems.add(clonedOppLineItem);
		}
		database.insert(clonedOppLineItems, accessLevel.USER_MODE);
	}
		// Loop through each cloned Opportunity Id
		// Loop through each original line item
		// Clone the original line item and add the random number to the quantity
		// Insert the new line items
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		return [SELECT Name, AccountId, Account.Name, Owner.UserName
				FROM Opportunity
				WHERE StageName = 'Closed Won'
				WITH SECURITY_ENFORCED]; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() {
		//Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
		List<Opportunity> oppDetailsClosedWon = [SELECT Name, AccountId, Account.Name, Owner.UserName
												 FROM Opportunity
												 WHERE StageName = 'Closed Won'
												 WITH SECURITY_ENFORCED];

		// Create a set of Account Ids from the Opportunities
		Set<Id> acctIds = new Set<Id>();
		for(Opportunity opp : oppDetailsClosedWon) {
			acctIds.add(opp.AccountId);
		}

		// Query the Contacts
		List<Contact> myContacts = [SELECT Id, FirstName, AccountId
									FROM Contact
									WHERE AccountId IN :acctIds
									WITH SECURITY_ENFORCED
									ORDER By FirstName ASC];

		// Loop through each Contact and add the Account Id and Contact to the map
		Map<Id, Contact> accountToFirstContactMap = new Map<Id, Contact>();
		for(Contact con : myContacts) {
			if(!accountToFirstContactMap.containsKey(con.AccountId)){
				accountToFirstContactMap.put(con.AccountId, con);
			}
		}
		// Loop through each Opportunity
		//Update the Opportunity primary contact from accountToContactMap
		// Update the Opportunity primary contact from accountToContactMap		
		List<Opportunity> oppsToUpdate = new List<Opportunity>();
		for(Opportunity opp : oppDetailsClosedWon) {
			Contact primaryContact = accountToFirstContactMap.get(opp.AccountId);
			if(primaryContact != null) {
				opp.Primary_Contact__c = primaryContact.Id;
				oppsToUpdate.add(opp);
			}
		}
		// Update the Opportunities
		database.update(oppsToUpdate);
	}
}
